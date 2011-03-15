using System;
using System.Linq;

using NOS.Registration.EntryPositioning;

using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration
{
	public class AutoRegistrationPlugin : IFormatterProviderV30
	{
		readonly IPluginConfiguration _configuration;
		readonly IEntryFormatter _entryFormatter;
		readonly IFileReader _fileReader;
		readonly ILogger _logger;
		readonly INotificationSender _notificationSender;
		readonly IPageFormatter _pageFormatter;
		readonly IPageRepository _pageRepository;
		readonly IRegistrationRepository _registrationRepository;
		readonly ISettings _settings;
		readonly ISynchronizer _synchronizer;
		IHostV30 _host;

		public AutoRegistrationPlugin()
			: this(new CrossContextSynchronizer(),
			       new RegistrationRepository(),
			       new PageRepository(),
			       new PageFormatter(new DefaultLogger(),
			                         new DefaultOpinionEvaluator(
			                         	new IHasOpinionAboutEntryPosition[]
			                         	{
			                         		new AtListEnd(),
			                         		new AtListEndWhenSponsoring(),
			                         		new AtWaitingListEndWhenHardLimitReached()
			                         	})),
			       new NVelocityEntryFormatter(),
			       new EmailNotificationSender(),
			       new DefaultLogger(),
			       new DefaultPluginConfiguration(),
			       new DefaultFileReader(),
			       new WikiSettings())
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
		                              IFileReader fileReader,
		                              ISettings settings)
		{
			_synchronizer = synchronizer;
			_fileReader = fileReader;
			_settings = settings;
			_registrationRepository = registrationRepository;
			_pageRepository = pageRepository;
			_pageFormatter = pageFormatter;
			_entryFormatter = entryFormatter;
			_notificationSender = notificationSender;
			_logger = logger;
			_configuration = configuration;
		}

		#region IFormatterProvider Members
		public void Init(IHostV30 host, string config)
		{
			_host = host;

			if (Configure(config))
			{
				_host.UserAccountActivity += Host_UserAccountActivity;
				_notificationSender.Configure(_host, _settings);

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
			get { return new ComponentInformation(GetType().Name, "Alexander Groß", "1.1", "http://therightstuff.de", null); }
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
			get { return 100; }
		}
		#endregion

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
					User user = null;
					try
					{
						user = _registrationRepository.FindByUserName(e.User.Username);
						if (user == null)
						{
							return;
						}

						var pageInfo = _pageRepository.FindPage(_configuration.PageName);
						if (pageInfo == null)
						{
							_logger.Error(String.Format("The attendee page '{0}' does not exist.", _configuration.PageName), "SYSTEM");
							throw new Exception("Attendee page does not exist.");
						}

						PageContent pageContent;
						try
						{
							pageContent = _host.GetPageContent(pageInfo);
						}
						catch (Exception ex)
						{
							_logger.Error(String.Format("The attendee page's content ('{0}') could not be loaded: {1}", _configuration.PageName, ex),
								          "SYSTEM");
							throw;
						}

						try
						{
							string entry = _entryFormatter.FormatUserEntry(user, _settings, _configuration.EntryTemplate);
							string newContent = _pageFormatter.AddEntry(pageContent.Content, entry, user, _configuration);

							_pageRepository.Save(pageInfo, pageContent.Title, user.UserName, _configuration.Comment, newContent);

							_logger.Info("User entry written successfully", user.UserName);
						}
						catch (Exception ex)
						{
							_logger.Error(String.Format("Could not add the user's entry to the attendee list: {0}", ex), "SYSTEM");
							throw;
						}
					}
					catch
					{
						failed = true;
					}
					finally
					{
						if (user != null)
						{
							string message = LoadEmailTemplate(failed);
							message = FillTemplate(message, user);

							_notificationSender.SendMessage(e.User.Email, _configuration.Comment, message);
							_notificationSender.SendMessage(_settings.ContactEmail, _configuration.Comment, message);
						}
					}
				});
		}

		string LoadEmailTemplate(bool failed)
		{
			string file = typeof(AutoRegistrationPlugin).FullName + ".SuccessMessage";

			if (failed)
			{
				file = typeof(AutoRegistrationPlugin).FullName + ".FailureMessage";
			}

			return _fileReader.Read(file);
		}

		string FillTemplate(string template, User user)
		{
			return _entryFormatter.FormatUserEntry(user, _settings, template);
		}
	}
}