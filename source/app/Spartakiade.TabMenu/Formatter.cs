using System;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Xml;

namespace NOS.TabMenu
{
	public class Formatter
	{
		readonly ILogger _logger;

		static readonly Regex TabMenu = new Regex(@"<tab-menu(.+?)>(?<Menu>.*?)</tab-menu>",
		                                          RegexOptions.CultureInvariant | RegexOptions.Singleline |
		                                          RegexOptions.Compiled |
		                                          RegexOptions.IgnoreCase);

		public Formatter(ILogger logger)
		{
			_logger = logger;
		}

		public string FormatMenu(string raw, string requestedPage)
		{
			requestedPage = HttpUtility.UrlPathEncode(requestedPage);

			StringBuilder markup = new StringBuilder(raw);

			Match match = TabMenu.Match(markup.ToString());
			while (match.Success)
			{
				markup.Remove(match.Index, match.Length);
				var menu = MarkSelectedMenuItems(match.Value, requestedPage);
				markup.Insert(match.Index, menu);

				match = TabMenu.Match(markup.ToString());
			}

			return markup.ToString();
		}

		 string MarkSelectedMenuItems(string menu, string requestedPage)
		{
			try
			{
				XmlDocument doc = new XmlDocument();
				doc.LoadXml(menu);

				if (doc.DocumentElement == null)
				{
					throw new FormatException("Tab menu does not contain a document element.");
				}

				var selector = doc.DocumentElement.GetAttribute("item-selector");
				var selectedAttribute = doc.DocumentElement.GetAttribute("selected-attr");
				var selectedValue = doc.DocumentElement.GetAttribute("selected-value");

				var attr = doc.CreateAttribute(selectedAttribute);
				attr.Value = selectedValue;

				foreach (XmlNode menuItem in doc.SelectNodes(selector))
				{
					_logger.Log("Menu item:" + menuItem.InnerXml);
					var isSelected = menuItem.InnerXml.IndexOf(requestedPage, StringComparison.OrdinalIgnoreCase) != -1;

					if (!isSelected)
					{
						continue;
					}
					
					_logger.Log("Selected menu item:" + menuItem.InnerText);

					AddOrUpdateSelectedAttribute(attr, menuItem);
				}

				return doc.DocumentElement.InnerXml;
			}
			catch (Exception ex)
			{
				_logger.Log("Error formatting Tab Menu:" + ex);
				return String.Format("<b>FORMATTER ERROR (Malformed Tab Menu: {0})</b>", ex);
			}
		}

		static void AddOrUpdateSelectedAttribute(XmlAttribute attr, XmlNode menuItem)
		{
			var existingAttribute = menuItem.Attributes[attr.Name];
			if (existingAttribute == null)
			{
				menuItem.Attributes.Append((XmlAttribute) attr.CloneNode(false));
			}
			else
			{
				existingAttribute.Value += " " + attr.Value;
			}
		}
	}
}