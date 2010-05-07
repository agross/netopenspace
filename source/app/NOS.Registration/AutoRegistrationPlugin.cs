using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

using NOS.Registration.Abstractions;
using NOS.Registration.Formatting;
using NOS.Registration.Queries;

using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration
{
	public class AutoRegistrationPlugin : IFormatterProviderV30
	{
		readonly IPluginConfiguration _configuration;
		readonly IList<IMarkupFormatter> _formatters;
		readonly ILogger _logger;
		readonly INotificationSender _notificationSender;
		readonly IRegistrationRepository _registrationRepository;
		readonly ISettingsAccessor _settingsAccessor;
		readonly ISynchronizer _synchronizer;
		IHostV30 _host;

		public AutoRegistrationPlugin()
			: this(Container.GetInstance<ISynchronizer>(),
			       Container.GetInstance<IRegistrationRepository>(),
			       Container.GetInstance<INotificationSender>(),
			       Container.GetInstance<ILogger>(),
			       Container.GetInstance<IPluginConfiguration>(),
			       Container.GetInstance<ISettingsAccessor>(),
			       Container.GetAllInstances<IMarkupFormatter>())
		{
		}

		public AutoRegistrationPlugin(ISynchronizer synchronizer,
		                              IRegistrationRepository registrationRepository,
		                              INotificationSender notificationSender,
		                              ILogger logger,
		                              IPluginConfiguration configuration,
		                              ISettingsAccessor settingsAccessor,
		                              IList<IMarkupFormatter> formatters)
		{
			_synchronizer = synchronizer;
			_registrationRepository = registrationRepository;
			_notificationSender = notificationSender;
			_logger = logger;
			_configuration = configuration;
			_settingsAccessor = settingsAccessor;
			_formatters = formatters;
		}

		public void Init(IHostV30 host, string config)
		{
			_host = host;

			if (Configure(config))
			{
				_host.UserAccountActivity += Host_UserAccountActivity;
				_notificationSender.Configure(_host);

				_logger.Info(String.Format("Waiting list is enabled after {0} attendees with a hard limit of {1}.",
				                           _configuration.MaximumAttendees,
				                           _configuration.HardLimit),
				             "SYSTEM");
			}
			else
			{
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
				return new ComponentInformation(GetType().Name, "Alexander Groß", version, "http://therightstuff.de", null);
			}
		}

		public string ConfigHelpHtml
		{
			get { return String.Empty; }
		}

		public string Format(string raw, ContextInformation context, FormattingPhase phase)
		{
			return _formatters.Aggregate(raw, (partial, formatter) => formatter.Format(partial));
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

		bool Configure(string config)
		{
			var errors = _configuration.Parse(config ?? String.Empty);

			errors.Each(x => _logger.Error(x, "SYSTEM"));

			return !errors.Any();
		}

		void Host_UserAccountActivity(object sender, UserAccountActivityEventArgs e)
		{
			if (e.Activity != UserAccountActivity.AccountActivated)
			{
				return;
			}

			_synchronizer.Lock(() =>
				{
					var failed = false;
					try
					{
						var user = _registrationRepository.Query(new UserByUserName(e.User.Username));
						if (user == null)
						{
							return;
						}

						// TODO
					}
					finally
					{
						_notificationSender.SendMessage(e.User.Username, e.User.Email, "AutoRegistration", failed);
						if (failed)
						{
							_notificationSender.SendMessage(e.User.Username, _settingsAccessor.ContactEmail, "AutoRegistration", true);
						}
					}
				});
		}
	}
}