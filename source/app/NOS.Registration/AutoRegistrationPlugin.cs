using System;

using ScrewTurn.Wiki;
using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration
{
	public class AutoRegistrationPlugin : IFormatterProvider
	{
		readonly IEntryFormatter _entryFormatter;
		readonly ILogger _logger;
		readonly IPageFormatter _pageFormatter;
		readonly IPageRepository _pageRepository;
		readonly IRegistrationRepository _registrationRepository;
		readonly ISynchronizer _synchronizer;
		IHost _host;
		INotificationSender _notificationSender;

		public AutoRegistrationPlugin()
			: this(new CrossContextSynchronizer(),
			       new RegistrationRepository(),
			       new PageRepository(),
			       new PageFormatter(new DefaultLogger()),
			       new NVelocityEntryFormatter(),
			       new EmailNotificationSender(),
			       new DefaultLogger())
		{
		}

		public AutoRegistrationPlugin(ISynchronizer synchronizer,
		                              IRegistrationRepository registrationRepository,
		                              IPageRepository pageRepository,
		                              IPageFormatter pageFormatter,
		                              IEntryFormatter entryFormatter,
		                              INotificationSender notificationSender,
		                              ILogger logger)
		{
			_synchronizer = synchronizer;
			_registrationRepository = registrationRepository;
			_pageRepository = pageRepository;
			_pageFormatter = pageFormatter;
			_entryFormatter = entryFormatter;
			_notificationSender = notificationSender;
			_logger = logger;
		}

		string PageName
		{
			get;
			set;
		}

		string Comment
		{
			get;
			set;
		}

		#region IFormatterProvider Members
		public void Init(IHost host, string config)
		{
			_host = host;

			if (Configure(config))
			{
				_host.UserAccountActivity += Host_UserAccountActivity;
			}

			_notificationSender.Configure(_host);
		}

		public void Shutdown()
		{
		}

		public ComponentInformation Information
		{
			get { return new ComponentInformation(GetType().Name, "Alexander Groß", "http://therightstuff.de"); }
		}

		public string Format(string raw, ContextInformation context, FormattingPhase phase)
		{
			return raw;
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
		#endregion

		bool Configure(string config)
		{
			ConfigureDefaults();
			ParseConfig(config ?? String.Empty);
			return AssertConfigurationIsValid();
		}

		void ConfigureDefaults()
		{
			_entryFormatter.EntryTemplate = "# $user.UserName";
			Comment = "AutoRegistration";
		}

		void ParseConfig(string config)
		{
			config
				.Split(new[] { '\n' }, StringSplitOptions.RemoveEmptyEntries)
				.Each(x =>
					{
						string key = x.Substring(0, x.IndexOf('=')).ToLowerInvariant();
						string value = x.Substring(x.IndexOf('=') + 1).Trim();

						switch (key)
						{
							case "entrytemplate":
								_entryFormatter.EntryTemplate = value;
								break;

							case "entrypattern":
								_pageFormatter.EntryPattern = value;
								break;

							case "pagename":
								PageName = value;
								break;

							case "liststartpattern":
								_pageFormatter.ListStartPattern = value;
								break;

							case "listendpattern":
								_pageFormatter.ListEndPattern = value;
								break;

							case "waitinglistendpattern":
								_pageFormatter.WaitingListEndPattern = value;
								break;

							case "maximumattendees":
								int result;
								if (!int.TryParse(value, out result))
								{
									_logger.Error(String.Format("Could not convert configuration value to integer: Key='{0}' Value='{1}'",
									                            key,
									                            value),
									              "SYSTEM");
								}
								else
								{
									_pageFormatter.MaximumAttendees = result;
								}
								break;

							case "comment":
								Comment = value;
								break;

							default:
								_logger.Error(String.Format("Unknown configuration key: {0}", key), "SYSTEM");
								break;
						}
					});
		}

		bool AssertConfigurationIsValid()
		{
			bool isInvalid = false;

			if (String.IsNullOrEmpty(PageName))
			{
				_logger.Error("The page name for the attendee page is missing. Configuration sample: 'PageName=Attendee list'.",
				              "SYSTEM");

				isInvalid |= true;
			}

			if (!String.IsNullOrEmpty(PageName))
			{
				if (_pageRepository.FindPage(PageName) == null)
				{
					_logger.Error(String.Format("The attendee page '{0}' does not exist.", PageName), "SYSTEM");
					isInvalid |= true;
				}
			}

			if (String.IsNullOrEmpty(_pageFormatter.EntryPattern))
			{
				_logger.Error(
					"The entry pattern is missing. Configuration sample: 'EntryPattern=^#.*$'.",
					"SYSTEM");

				isInvalid |= true;
			}

			if (String.IsNullOrEmpty(_pageFormatter.ListStartPattern))
			{
				_logger.Error(
					"The attendee list start pattern is missing. Configuration sample: 'ListStartPattern=<!--DO NOT REMOVE List start-->'.",
					"SYSTEM");

				isInvalid |= true;
			}

			if (String.IsNullOrEmpty(_pageFormatter.ListEndPattern))
			{
				_logger.Error(
					"The attendee list end pattern is missing. Configuration sample: 'ListEndPattern=<!--DO NOT REMOVE List end-->'.",
					"SYSTEM");

				isInvalid |= true;
			}

			if (String.IsNullOrEmpty(_pageFormatter.WaitingListEndPattern))
			{
				_logger.Error(
					"The attendee waiting list end pattern is missing. Configuration sample: 'WaitingListEndPattern=<!--DO NOT REMOVE Waiting list end-->'.",
					"SYSTEM");

				isInvalid |= true;
			}

			_logger.Info(String.Format("Waiting list is enabled after {0} attendees", _pageFormatter.MaximumAttendees), "SYSTEM");

			if (isInvalid)
			{
				_logger.Error("The auto registration plugin will be disabled.", "SYSTEM");
			}

			return !isInvalid;
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

						var pageInfo = _pageRepository.FindPage(PageName);
						if (pageInfo == null)
						{
							_logger.Error(String.Format("The attendee page '{0}' does not exist.", PageName), "SYSTEM");
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
							_logger.Error(String.Format("The attendee page's content ('{0}') could not be loaded: {1}", PageName, ex),
							              "SYSTEM");
							failed = true;
							return;
						}

						try
						{
							string entry = _entryFormatter.FormatUserEntry(user);
							string newContent = _pageFormatter.AddEntry(pageContent.Content, entry, user);

							_pageRepository.Save(pageInfo, pageContent.Title, user.UserName, Comment, newContent);

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
						_notificationSender.SendMessage(e.User.Username, e.User.Email, Comment, failed);
						if (failed)
						{
							_notificationSender.SendMessage(e.User.Username, Settings.ContactEmail, Comment, true);
						}
					}
				});
		}
	}
}