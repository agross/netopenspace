using System;
using System.Linq;
using System.Text;
using System.Xml;

using NOS.Registration.Abstractions;
using NOS.Registration.Formatting.Lists;

namespace NOS.Registration.Formatting
{
	public class ListMarkupFormatter<T> : IMarkupFormatter
	{
		readonly IDataProvider<T> _dataProvider;
		readonly IListFormatter<T> _emptyListFormatter;
		readonly IMarkupScanner _markupScanner;
		readonly IListFormatter<T> _listFormatter;
		readonly ILogger _logger;

		public ListMarkupFormatter(ILogger logger,
		                     IMarkupScanner markupScanner,
		                     IDataProvider<T> dataProvider,
		                     IListFormatter<T> emptyListFormatter,
		                     IListFormatter<T> listFormatter)
		{
			_logger = logger;
			_dataProvider = dataProvider;
			_emptyListFormatter = emptyListFormatter;
			_listFormatter = listFormatter;
			_markupScanner = markupScanner;
		}

		public string Format(string raw)
		{
			var markup = new StringBuilder(raw);

			var match = _markupScanner.Match(markup.ToString());
			while (match.Success)
			{
				markup.Remove(match.Index, match.Length);
				var rendered = RenderList(match.Value);
				markup.Insert(match.Index, rendered);

				match = _markupScanner.Match(markup.ToString());
			}

			return markup.ToString();
		}

		StringBuilder RenderList(string markup)
		{
			try
			{
				XmlDocument doc = new XmlDocument();
				doc.LoadXml(markup);

				if (doc.DocumentElement == null)
				{
					throw new FormatException(_markupScanner.Name + " does not contain a document element.");
				}

				var items = _dataProvider.GetItems();
				if (!items.Any())
				{
					return _emptyListFormatter.FormatEmptyList(doc);
				}

				return _listFormatter.FormatList(items);
			}
			catch (Exception ex)
			{
				_logger.Error(string.Format("Error formatting {0}: {1}", _markupScanner.Name, ex), "SYSTEM");
				return new StringBuilder().AppendFormat("<b>FORMATTER ERROR (Malformed {0}: {1})</b>", _markupScanner.Name, ex);
			}
		}
	}
}