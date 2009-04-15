/*
 * Copyright (c) 2007-2008 DotNetHelperClass
 *
 * All rights reserved. 
 */

using System;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;

using ScrewTurn.Wiki.PluginFramework;

namespace NOS.TabsMenu
{
	internal class TabsMenu : IFormatterProvider
	{
		IHost _host;
		bool _log;

		#region IFormatterProvider Members
		public string Format(string raw, ContextInformation context, FormattingPhase phase)
		{
			if (_log)
			{
				_host.LogEntry(String.Format("Rendering tabs, phase {0}", phase), LogEntryType.General, "SYSTEM");
			}

			Regex tabsMenu = new Regex(@"\{MENU(\ [^\n]*)?\n.+?\}",
			                           RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline);
			StringBuilder result = new StringBuilder(raw);

			Match match = tabsMenu.Match(result.ToString());

			while (match.Success)
			{
				result.Remove(match.Index, match.Length);
				result.Insert(match.Index, BuildTabsMenu(match.Value, context.HttpContext));

				match = tabsMenu.Match(result.ToString());
			}

			return result.ToString();
		}

		public bool PerformPhase1
		{
			get { return false; }
		}

		public bool PerformPhase2
		{
			get { return true; }
		}

		public bool PerformPhase3
		{
			get { return false; }
		}

		public ComponentInformation Information
		{
			get { return new ComponentInformation(GetType().Name, "Junie Lorenzo and Alexander Groﬂ", "http://therightstuff.de"); }
		}

		public void Init(IHost host, string config)
		{
			if (config.Contains("log"))
			{
				_log = true;
			}

			_host = host;
		}

		public void Shutdown()
		{
		}
		#endregion

		#region Methods
		string BuildTabsMenu(string menu, HttpContext context)
		{
			// Proceed line-by-line, ignoring the first and last one
			string[] lines = menu.Split(new[] { '\n' }, StringSplitOptions.RemoveEmptyEntries);
			if (lines.Length < 3)
			{
				return "<b>FORMATTER ERROR (Malformed Tabs Menu)</b>";
			}

			StringBuilder sb = new StringBuilder();
			sb.Append("<ul class=\"basictab\">");

			foreach (string line in lines)
			{
				if (line.Trim().StartsWith("|"))
				{
					string requestedPage = context.Request.QueryString["Page"];
					if (String.IsNullOrEmpty(requestedPage) &&
					    context.Request.Url.LocalPath.StartsWith("/Default.aspx", StringComparison.OrdinalIgnoreCase))
					{
						requestedPage = _host.GetSettingValue(SettingName.DefaultPage);
					}

					if (_log)
					{
						_host.LogEntry(
							String.Format("Rendering tabs, current page is {0}",
							              String.IsNullOrEmpty(requestedPage) ? "(none)" : requestedPage),
							LogEntryType.General,
							"SYSTEM");
					}

					string selected = String.Empty;
					if (!String.IsNullOrEmpty(requestedPage) && line.Substring(1).Contains(string.Format("{0}.ashx", requestedPage)))
					{
						selected = " class=\"selected\"";
					}

					sb.AppendFormat("<li{1}>{0}</li>", line.Substring(1), selected);
				}
			}

			sb.Append("</ul>");

			return sb.ToString();
		}
		#endregion
	}
}