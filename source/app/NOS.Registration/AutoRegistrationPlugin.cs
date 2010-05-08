using System;
using System.Reflection;

using NOS.Registration.Abstractions;
using NOS.Registration.Commands;
using NOS.Registration.Commands.Infrastructure;

using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration
{
	public class AutoRegistrationPlugin : IFormatterProviderV30
	{
		readonly ICommandInvoker _commandInvoker;
		readonly ILogger _logger;
		IHostV30 _host;

		public AutoRegistrationPlugin() : this(Container.GetInstance<ILogger>(),
		                                       Container.GetInstance<ICommandInvoker>())
		{
		}

		public AutoRegistrationPlugin(ILogger logger, ICommandInvoker commandInvoker)
		{
			_logger = logger;
			_commandInvoker = commandInvoker;
		}

		public void Init(IHostV30 host, string configurationString)
		{
			_host = host;

			var result = _commandInvoker.Process(new ConfigureEnvironmentMessage(configurationString, _host));
			if (result.Successful)
			{
				_host.UserAccountActivity += Host_UserAccountActivity;

				var config = result.ReturnItems.Get<IPluginConfiguration>();

				_logger.Info(String.Format("Waiting list is enabled after {0} attendees with a hard limit of {1}.",
				                           config.MaximumAttendees,
				                           config.HardLimit),
				             "SYSTEM");
			}
			else
			{
				result.Messages.Each(x => _logger.Error(x, "SYSTEM"));

				_logger.Error("The auto registration plugin will be disabled.", "SYSTEM");
			}
		}

		public void Shutdown()
		{
			_host.UserAccountActivity -= Host_UserAccountActivity;
		}

		public ComponentInformation Information
		{
			get
			{
				string version = Assembly.GetExecutingAssembly().GetName().Version.ToString();
				return new ComponentInformation(GetType().Name, "Alexander Groﬂ", version, "http://therightstuff.de", null);
			}
		}

		public string ConfigHelpHtml
		{
			get { return String.Empty; }
		}

		public string Format(string raw, ContextInformation context, FormattingPhase phase)
		{
			var result = _commandInvoker.Process(new FormatContentMessage(raw));
			if (result.Successful)
			{
				return result.ReturnItems.Get<string>();
			}

			return raw;
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

		void Host_UserAccountActivity(object sender, UserAccountActivityEventArgs e)
		{
			switch (e.Activity)
			{
				case UserAccountActivity.AccountActivated:
					_commandInvoker.Process(new ActivateUserMessage(e.User));
					break;
				
				case UserAccountActivity.AccountDeactivated:
					_commandInvoker.Process(new DeactivateUserMessage(e.User));
					break;

				case UserAccountActivity.AccountRemoved:
					_commandInvoker.Process(new DeleteUserMessage(e.User));
					break;
			}
		}
	}
}