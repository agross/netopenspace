using System;
using System.Reflection;

using ScrewTurn.Wiki.PluginFramework;

namespace NOS.TabMenu
{
	public class TabMenu : IFormatterProviderV30, ILogger
	{
		bool _enableLogging;
		IHostV30 _host;

		public string Format(string raw, ContextInformation context, FormattingPhase phase)
		{
			var requestedPage = GetRequestedPage(context);

			Log(String.Format("Rendering tab menu, requested page is {0}", requestedPage));

			return new Formatter(this).FormatMenu(raw, requestedPage);
		}

		public string PrepareTitle(string title, ContextInformation context)
		{
			return title;
		}

		public bool PerformPhase1
		{
			get { return false; }
		}

		public bool PerformPhase2
		{
			get { return false; }
		}

		public bool PerformPhase3
		{
			get { return true; }
		}

		public int ExecutionPriority
		{
			get { return 100; }
		}

		public ComponentInformation Information
		{
			get
			{
				return new ComponentInformation(GetType().Name,
				                                "Junie Lorenzo and Alexander Groﬂ",
				                                Assembly.GetExecutingAssembly().GetName().Version.ToString(),
				                                "http://therightstuff.de",
				                                null);
			}
		}

		public string ConfigHelpHtml
		{
			get { return "Specify <i>log</i> to enable logging."; }
		}

		public void Init(IHostV30 host, string config)
		{
			if (config != null && config.Contains("log"))
			{
				_enableLogging = true;
			}

			_host = host;
		}

		public void Shutdown()
		{
		}

		public void Log(string message)
		{
			if (!_enableLogging)
			{
				return;
			}

			_host.LogEntry(message, LogEntryType.General, "SYSTEM", this);
		}

		string GetRequestedPage(ContextInformation context)
		{
			var defaultPage = _host.GetSettingValue(SettingName.RootNamespaceDefaultPage);
			
			if (context.Page == null)
			{
				return defaultPage;
			}

			return context.Page.FullName ?? defaultPage;
		}
	}
}