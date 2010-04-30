using System;
using System.Linq;
using System.Reflection;

using NOS.Registration.EntryPositioning;
using NOS.Registration.EntryPositioning.Opinions;

using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration
{
	public class AutoRegistrationPlugin : IFormatterProviderV30
	{
		readonly IPluginConfiguration _configuration;
		readonly IEntryFormatter _entryFormatter;
		readonly ILogger _logger;
		readonly INotificationSender _notificationSender;
		readonly IPageFormatter _pageFormatter;
		readonly IPageRepository _pageRepository;
		readonly IRegistrationRepository _registrationRepository;
		readonly ISettingsAccessor _settingsAccessor;
		readonly ISynchronizer _synchronizer;
		IHostV30 _host;

		public AutoRegistrationPlugin()
			: this(new CrossContextSynchronizer(),
			       new RegistrationRepository(),
			       new PageRepository(),
			       new PageFormatter(new DefaultLogger(),
			                         new DefaultOpinionEvaluator(
			                         	new IHaveOpinionAboutEntryPosition[]
			                         	{
			                         		new ListEnd(),
			                         		new ListEndWhenSponsoring(),
			                         		new WaitingListWhenHardLimitReached()
			                         	})),
			       new NVelocityEntryFormatter(),
			       new EmailNotificationSender(new DefaultFileReader()),
			       new DefaultLogger(),
			       new DefaultPluginConfiguration(),
			       new DefaultSettingsAccessor())
		{
		}

		public AutoRegistrationPlugin(ISynchronizer synchronizer,
		                              IRegistrationRepository registrationRepository,
		                              IPageRepository pageRepository,
		                              IPageFormatter pageFormatter,
		                              IEntryFormatter entryFormatter,
		                              INotificationSender notificationSender,
		                              ILogger logger,
		                              IPluginConfiguration configuration,
		                              ISettingsAccessor settingsAccessor)
		{
			_synchronizer = synchronizer;
			_registrationRepository = registrationRepository;
			_pageRepository = pageRepository;
			_pageFormatter = pageFormatter;
			_entryFormatter = entryFormatter;
			_notificationSender = notificationSender;
			_logger = logger;
			_configuration = configuration;
			_settingsAccessor = settingsAccessor;
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
			get { return false; }
		}

		public int ExecutionPriority
		{
			get { throw new NotImplementedException(); }
		}

		bool Configure(string config)
		{
			var errors = _configuration.Parse(config ?? String.Empty, _pageRepository);

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
						var user = _registrationRepository.FindByUserName(e.User.Username);
						if (user == null)
						{
							return;
						}

						var pageInfo = _pageRepository.FindPage(_configuration.PageName);
						if (pageInfo == null)
						{
							_logger.Error(String.Format("The attendee page '{0}' does not exist.", _configuration.PageName), "SYSTEM");
							failed = true;
							return;
						}

						PageContent pageContent;
						try
						{
							pageContent = _host.GetPageContent(pageInfo);
						}
						catch (Exception ex)
						{
							_logger.Error(
								String.Format("The attendee page's content ('{0}') could not be loaded: {1}", _configuration.PageName, ex),
								"SYSTEM");
							failed = true;
							return;
						}

						try
						{
							string entry = _entryFormatter.FormatUserEntry(user, _configuration.EntryTemplate);
							string newContent = _pageFormatter.AddEntry(pageContent.Content, entry, user, _configuration);

							_pageRepository.Save(pageInfo, pageContent.Title, user.UserName, _configuration.Comment, newContent);

							_registrationRepository.Delete(user.UserName);

							_logger.Info("User entry written successfully, registration data has been deleted", user.UserName);
						}
						catch (Exception ex)
						{
							_logger.Error(String.Format("Could not add the user's entry to the attendee list: {0}", ex), "SYSTEM");
							failed = true;
						}
					}
					finally
					{
						_notificationSender.SendMessage(e.User.Username, e.User.Email, _configuration.Comment, failed);
						if (failed)
						{
							_notificationSender.SendMessage(e.User.Username, _settingsAccessor.ContactEmail, _configuration.Comment, true);
						}
					}
				});
		}
	}
}