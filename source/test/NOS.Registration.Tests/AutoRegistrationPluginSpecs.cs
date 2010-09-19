using System;
using System.Collections.Generic;
using System.Linq;

using Machine.Specifications;

using Rhino.Mocks;
using Rhino.Mocks.Constraints;

using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration.Tests
{
	public class With_auto_registration_plugin
	{
		protected static IPluginConfiguration Configuration;
		protected static IEntryFormatter EntryFormatter;
		protected static IHostV30 Host;
		protected static ILogger Logger;
		protected static INotificationSender NotificationSender;
		protected static IPageFormatter PageFormatter;
		protected static IPageRepository PageRepository;
		protected static AutoRegistrationPlugin Plugin;
		protected static IRegistrationRepository RegistrationRepository;
		protected static IFileReader FileReader;
		protected static ISettings Settings;

		Establish context = () =>
			{
				Host = MockRepository.GenerateStub<IHostV30>();

				ISynchronizer synchronizer = MockRepository.GenerateStub<ISynchronizer>();
				synchronizer
					.Stub(x => x.Lock(Arg<Action>.Is.Anything))
					.WhenCalled(invocation => ((Action) invocation.Arguments.First()).Invoke());

				RegistrationRepository = MockRepository.GenerateStub<IRegistrationRepository>();
				PageRepository = MockRepository.GenerateStub<IPageRepository>();

				Logger = MockRepository.GenerateStub<ILogger>();

				EntryFormatter = MockRepository.GenerateStub<IEntryFormatter>();
				PageFormatter = MockRepository.GenerateStub<IPageFormatter>();

				NotificationSender = MockRepository.GenerateStub<INotificationSender>();
				FileReader = MockRepository.GenerateStub<IFileReader>();

				Configuration = MockRepository.GenerateStub<IPluginConfiguration>();

				Settings = MockRepository.GenerateStub<ISettings>();
				Settings
					.Stub(x => x.SenderEmail)
					.Return("sender@example.com");
				Settings
					.Stub(x => x.ContactEmail)
					.Return("admin@example.com");

				Plugin = new AutoRegistrationPlugin(synchronizer,
				                                    RegistrationRepository,
				                                    PageRepository,
				                                    PageFormatter,
				                                    EntryFormatter,
				                                    NotificationSender,
				                                    Logger,
				                                    Configuration,
													FileReader,
													Settings);
			};
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_the_auto_registration_is_initialized_with_invalid_configuration_data : With_auto_registration_plugin
	{
		Establish context = () =>
			{
				Configuration.Stub(x => x.Parse(null, null))
					.IgnoreArguments()
					.Return(new List<string> { "error1", "error2" });
			};

		Because of = () => Plugin.Init(Host, "invalid");

		It should_log_all_configuration_errors =
			() => Logger.AssertWasCalled(x => x.Error(Arg<string>.Matches(y => y.StartsWith("error")),
			                                          Arg<string>.Is.Equal("SYSTEM")),
			                             o => o.Repeat.Twice());

		It should_log_that_the_plugin_is_disabled =
			() => Logger.AssertWasCalled(x => x.Error("The auto registration plugin will be disabled.", "SYSTEM"));

		It should_disable_the_plugin =
			() => Host.AssertWasNotCalled(x => x.UserAccountActivity += Arg<EventHandler<UserAccountActivityEventArgs>>
			                                                            	.Is.Anything);
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_the_auto_registration_is_initialized_successfully : With_auto_registration_plugin
	{
		Establish context = () =>
			{
				Configuration
					.Stub(x => x.Parse(null, null))
					.IgnoreArguments()
					.Return(new List<string>());

				Configuration.Stub(x => x.MaximumAttendees).Return(15);
				Configuration.Stub(x => x.HardLimit).Return(42);
			};

		Because of = () => Plugin.Init(Host, String.Empty);

		It should_enable_the_plugin =
			() => Host.AssertWasCalled(x => x.UserAccountActivity += Arg<EventHandler<UserAccountActivityEventArgs>>.Is.NotNull);

		It should_log_the_maximum_attendee_count_and_the_hard_limit =
			() =>
			Logger.AssertWasCalled(x => x.Info("Waiting list is enabled after 15 attendees with a hard limit of 42.", "SYSTEM"));

		It should_not_respond_to_formatting_requests_in_phase_1 = () => Plugin.PerformPhase1.ShouldBeFalse();
		It should_not_respond_to_formatting_requests_in_phase_2 = () => Plugin.PerformPhase2.ShouldBeFalse();
		It should_not_respond_to_formatting_requests_in_phase_3 = () => Plugin.PerformPhase3.ShouldBeFalse();
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_a_user_account_is_activated : With_auto_registration_plugin
	{
		static IPagesStorageProviderV30 Provider;
		static UserAccountActivityEventArgs EventArgs;
		protected static UserInfo UserInfo;
		protected static User User;
		protected static PageInfo PageInfo;

		Establish context = () =>
			{
				UserInfo = new UserInfo("user",
				                        "Jon Doe",
				                        "email@example.com",
				                        true,
				                        DateTime.Now,
				                        MockRepository.GenerateStub<IUsersStorageProviderV30>());
				EventArgs = new UserAccountActivityEventArgs(UserInfo, UserAccountActivity.AccountActivated);

				User = new User("user");
				RegistrationRepository.Stub(x => x.FindByUserName("user")).Return(User);

				Configuration
					.Stub(x => x.Parse(null, null))
					.IgnoreArguments()
					.Return(new List<string>());

				Configuration.Stub(x => x.Comment).Return("comment");
				Configuration.Stub(x => x.PageName).Return("page");
				Configuration.Stub(x => x.EntryTemplate).Return(" and entry");

				PageInfo = new PageInfo(Configuration.PageName, null, DateTime.Now);
				PageRepository.Stub(x => x.FindPage(Configuration.PageName)).Return(PageInfo);

				Host
					.Stub(x => x.GetPageContent(PageInfo))
					.Return(new PageContent(PageInfo,
					                        "title",
					                        "user that saved the content last",
					                        DateTime.Now,
					                        String.Empty,
					                        "content",
					                        new[] { "keyword" },
					                        "description"));
				Host
					.Stub(x => x.SendEmail(null, null, null, null, false))
					.IgnoreArguments()
					.Return(true);

				Plugin.Init(Host, String.Empty);

				EntryFormatter
					.Stub(x => x.FormatUserEntry(User, Configuration.EntryTemplate))
					.Return(Configuration.EntryTemplate);
				PageFormatter
					.Stub(x => x.AddEntry("content", Configuration.EntryTemplate, User, Configuration))
					.Return("content and entry");
			};

		Because of = () => Host.Raise(x => x.UserAccountActivity += null, null, EventArgs);

		It should_try_to_find_the_user_in_the_user_list =
			() => RegistrationRepository.AssertWasCalled(x => x.FindByUserName(User.UserName));

		It should_try_to_find_the_attendee_page =
			() => PageRepository.AssertWasCalled(x => x.FindPage(Configuration.PageName));

		It should_load_the_attendee_page_contents =
			() => Host.AssertWasCalled(x => x.GetPageContent(PageInfo));

		It should_format_the_users_entry =
			() => EntryFormatter.AssertWasCalled(x => x.FormatUserEntry(User, Configuration.EntryTemplate));

		It should_add_the_users_entry_to_the_attendee_page =
			() => PageFormatter.AssertWasCalled(x => x.AddEntry("content", Configuration.EntryTemplate, User, Configuration));

		It should_save_the_modified_page_contents =
			() => PageRepository.AssertWasCalled(x => x.Save(Arg<PageInfo>.Is.Equal(PageInfo),
			                                                 Arg<string>.Is.Anything,
			                                                 Arg<string>.Is.Anything,
			                                                 Arg<string>.Is.Anything,
			                                                 Arg<string>.Is.Equal("content and entry")));

		It should_save_the_modified_page_contents_as_the_registered_user =
			() => PageRepository.AssertWasCalled(x => x.Save(Arg<PageInfo>.Is.Equal(PageInfo),
			                                                 Arg<string>.Is.Anything,
			                                                 Arg<string>.Is.Equal("user"),
			                                                 Arg<string>.Is.Anything,
			                                                 Arg<string>.Is.Anything));

		It should_save_the_modified_page_contents_without_altering_the_page_title =
			() => PageRepository.AssertWasCalled(x => x.Save(Arg<PageInfo>.Is.Equal(PageInfo),
			                                                 Arg<string>.Is.Equal("title"),
			                                                 Arg<string>.Is.Anything,
			                                                 Arg<string>.Is.Anything,
			                                                 Arg<string>.Is.Anything));

		It should_save_the_modified_page_contents_giving_a_comment =
			() => PageRepository.AssertWasCalled(x => x.Save(Arg<PageInfo>.Is.Equal(PageInfo),
			                                                 Arg<string>.Is.Anything,
			                                                 Arg<string>.Is.Anything,
			                                                 Arg<string>.Is.Equal(Configuration.Comment),
			                                                 Arg<string>.Is.Anything));

		It should_notify_the_user_about_the_activation =
			() => NotificationSender.AssertWasCalled(x => x.SendMessage(Arg<string>.Is.Equal(UserInfo.Username),
			                                                            Arg<string>.Is.Equal(UserInfo.Email),
			                                                            Arg<string>.Is.Equal(Configuration.Comment),
			                                                            Arg<bool>.Is.Equal(false)));
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_a_user_account_is_activated_and_the_user_cannot_be_found : When_a_user_account_is_activated
	{
		Establish context = () =>
			{
				RegistrationRepository.BackToRecord();
				RegistrationRepository.Stub(x => x.FindByUserName("user")).Return(null);
				RegistrationRepository.Replay();
			};

		It should_not_add_the_users_entry_to_the_attendee_page =
			() => PageFormatter.AssertWasNotCalled(x => x.AddEntry(null, null, null, null), o => o.IgnoreArguments());
	}

	[Behaviors]
	public class FailureNotificationBehavior
	{
		protected static INotificationSender NotificationSender;
		protected static UserInfo UserInfo;

		It should_notify_the_administrator_about_the_failure =
			() => NotificationSender.AssertWasCalled(x => x.SendMessage(Arg<string>.Is.NotNull,
			                                                            Arg<string>.Is.Equal("admin@example.com"),
			                                                            Arg<string>.Is.NotNull,
			                                                            Arg<bool>.Is.Equal(true)));

		It should_notify_the_user_about_the_failure =
			() => NotificationSender.AssertWasCalled(x => x.SendMessage(Arg<string>.Is.NotNull,
			                                                            Arg<string>.Is.Equal(UserInfo.Email),
			                                                            Arg<string>.Is.NotNull,
			                                                            Arg<bool>.Is.Equal(true)));
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_a_user_account_is_activated_and_the_attendee_page_does_not_exist
		: When_a_user_account_is_activated
	{
		Establish context = () =>
			{
				PageRepository.BackToRecord();
				PageRepository.Stub(x => x.FindPage(Configuration.PageName)).Return(null);
				PageRepository.Replay();
			};

		It should_log_that_the_page_does_not_exist =
			() => Logger.AssertWasCalled(x => x.Error("The attendee page 'page' does not exist.", "SYSTEM"));

		It should_not_add_the_users_entry_to_the_attendee_page =
			() => PageFormatter.AssertWasNotCalled(x => x.AddEntry(null, null, null, null), o => o.IgnoreArguments());

		Behaves_like<FailureNotificationBehavior> failing_activation;
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_a_user_account_is_activated_and_the_attendee_page_content_could_not_be_loaded
		: When_a_user_account_is_activated
	{
		Establish context = () =>
			{
				Host.BackToRecord(BackToRecordOptions.All ^ BackToRecordOptions.EventSubscribers);
				Host.Stub(x => x.GetPageContent(PageInfo)).Throw(new Exception());
				Host.Stub(x => x.SendEmail(null, null, null, null, false)).IgnoreArguments().Return(true);
				Host.Replay();
			};

		It should_log_that_page_content_loading_failed =
			() => Logger.AssertWasCalled(x => x.Error(null, null),
			                             o =>
			                             o.Constraints(
			                             	Text.StartsWith("The attendee page's content ('page') could not be loaded:"),
			                             	Is.Equal("SYSTEM")));

		It should_not_add_the_users_entry_to_the_attendee_page =
			() => PageFormatter.AssertWasNotCalled(x => x.AddEntry(null, null, null, null), o => o.IgnoreArguments());

		Behaves_like<FailureNotificationBehavior> failing_activation;
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_a_user_account_is_activated_and_users_entry_cannot_be_added
		: When_a_user_account_is_activated
	{
		Establish context = () =>
			{
				PageFormatter.BackToRecord();
				PageFormatter.Stub(x => x.AddEntry(null, null, null, null)).IgnoreArguments().Throw(new Exception());
				PageFormatter.Replay();
			};

		It should_log_that_adding_the_entry_failed =
			() => Logger.AssertWasCalled(x => x.Error(null, null),
			                             o =>
			                             o.Constraints(
			                             	Text.StartsWith("Could not add the user's entry to the attendee list:"),
			                             	Is.Equal("SYSTEM")));

		It should_swallow_the_error = () => true.ShouldBeTrue();

		Behaves_like<FailureNotificationBehavior> failing_activation;
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_any_other_user_account_activity_takes_place : With_auto_registration_plugin
	{
		static UserAccountActivityEventArgs EventArgs;
		static UserInfo UserInfo;

		Establish context = () =>
			{
				UserInfo = new UserInfo("user",
				                        "Jon Doe",
				                        "email@example.com",
				                        true,
				                        DateTime.Now,
				                        MockRepository.GenerateStub<IUsersStorageProviderV30>());
				EventArgs = new UserAccountActivityEventArgs(UserInfo, UserAccountActivity.AccountAdded);
			};

		Because of = () => Host.Raise(x => x.UserAccountActivity += null, null, EventArgs);

		It should_not_load_users =
			() => RegistrationRepository.AssertWasNotCalled(x => x.GetAll());

		It should_not_save_users =
			() => RegistrationRepository.AssertWasNotCalled(x => x.Save(Arg<User>.Is.Anything));
	}
}