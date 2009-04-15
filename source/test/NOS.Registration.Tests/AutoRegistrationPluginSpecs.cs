using System;
using System.Linq;

using Machine.Specifications;

using Rhino.Mocks;
using Rhino.Mocks.Constraints;

using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration.Tests
{
	public class With_auto_registration_plugin
	{
		protected static IEntryFormatter EntryFormatter;
		protected static IHost Host;
		protected static ILogger Logger;
		protected static INotificationSender NotificationSender;
		protected static IPageFormatter PageFormatter;
		protected static IPageRepository PageRepository;
		protected static AutoRegistrationPlugin Plugin;
		protected static IRegistrationRepository RegistrationRepository;

		Establish context = () =>
			{
				Host = MockRepository.GenerateStub<IHost>();

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

				Plugin = new AutoRegistrationPlugin(synchronizer,
				                                    RegistrationRepository,
				                                    PageRepository,
				                                    PageFormatter,
				                                    EntryFormatter,
				                                    NotificationSender,
				                                    Logger);
			};
	}

	public class With_configured_auto_registration_plugin : With_auto_registration_plugin
	{
		protected static PageInfo PageInfo;

		Establish context = () =>
			{
				PageInfo = new PageInfo("page", null, PageStatus.Normal, DateTime.Now);
				PageRepository.Stub(x => x.FindPage("page")).Repeat.Once().Return(PageInfo);

				Plugin.Init(Host,
				            "PageName=page\nEntryTemplate=EntryTemplate\nEntryPattern=Entry\nListStartPattern=ListStart\nListEndPattern=ListEnd\nWaitingListEndPattern=WaitingListEnd\nMaximumAttendees=10");

				PageRepository.BackToRecord(BackToRecordOptions.All ^ BackToRecordOptions.EventSubscribers);
				PageRepository.Replay();
			};
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_the_auto_registration_is_initialized_with_invalid_configuration_data : With_auto_registration_plugin
	{
		Because of = () => Plugin.Init(Host, "foo=bar\nMaximumAttendees=not an int");

		It should_log_unknown_entries = () => Logger.AssertWasCalled(x => x.Error(Arg<string>.Matches(y => y.Contains("foo")),
		                                                                          Arg<string>.Is.Equal("SYSTEM")));

		It should_log_the_invalid_maximum_attendee_number =
			() => Logger.AssertWasCalled(x => x.Error(
			                                  	Arg<string>.Matches(y => y.Contains("MaximumAttendees".ToLowerInvariant())),
			                                  	Arg<string>.Is.Equal("SYSTEM")));
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_the_auto_registration_is_initialized_without_required_options_being_configured
		: With_auto_registration_plugin
	{
		Because of = () => Plugin.Init(Host, String.Empty);

		It should_log_the_missing_page_name =
			() =>
			Logger.AssertWasCalled(x => x.Error(null, null),
			                       o => o.Constraints(Text.Contains("The page name for the attendee page is missing"),
			                                          Text.Like("SYSTEM")));

		It should_log_the_missing_entry_pattern =
			() =>
			Logger.AssertWasCalled(x => x.Error(null, null),
			                       o => o.Constraints(Text.Contains("The entry pattern is missing"),
			                                          Text.Like("SYSTEM")));

		It should_log_the_missing_list_start_pattern =
			() =>
			Logger.AssertWasCalled(x => x.Error(null, null),
			                       o => o.Constraints(Text.Contains("The attendee list start pattern is missing"),
			                                          Text.Like("SYSTEM")));

		It should_log_the_missing_list_end_pattern =
			() =>
			Logger.AssertWasCalled(x => x.Error(null, null),
			                       o => o.Constraints(Text.Contains("The attendee list end pattern is missing"),
			                                          Text.Like("SYSTEM")));

		It should_log_the_missing_waiting_list_end_pattern =
			() =>
			Logger.AssertWasCalled(x => x.Error(null, null),
			                       o => o.Constraints(Text.Contains("The attendee waiting list end pattern is missing"),
			                                          Text.Like("SYSTEM")));

		It should_log_that_the_plugin_is_disabled =
			() => Logger.AssertWasCalled(x => x.Error("The auto registration plugin will be disabled.", "SYSTEM"));

		It should_disable_the_plugin =
			() => Host.AssertWasNotCalled(x => x.UserAccountActivity += Arg<EventHandler<UserAccountActivityEventArgs>>
			                                                            	.Is.Anything);
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_the_auto_registration_is_initialized_with_a_non_existing_page_name
		: With_auto_registration_plugin
	{
		Because of = () =>
			{
				Host.Stub(x => x.FindPage("does not exist")).Return(null);
				Plugin.Init(Host, "PageName=does not exist");
			};

		It should_log_the_non_existing_page =
			() =>
			Logger.AssertWasCalled(x => x.Error(null, null),
			                       o => o.Constraints(Text.Contains("The attendee page 'does not exist' does not exist"),
			                                          Text.Like("SYSTEM")));

		It should_disable_the_plugin =
			() => Host.AssertWasNotCalled(x => x.UserAccountActivity += Arg<EventHandler<UserAccountActivityEventArgs>>
			                                                            	.Is.Anything);
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_the_auto_registration_has_been_initialized : With_configured_auto_registration_plugin
	{
		It should_enable_the_plugin =
			() => Host.AssertWasCalled(x => x.UserAccountActivity += Arg<EventHandler<UserAccountActivityEventArgs>>.Is.NotNull);

		It should_not_respond_to_formatting_requests_in_phase_1 = () => Plugin.PerformPhase1.ShouldBeFalse();
		It should_not_respond_to_formatting_requests_in_phase_2 = () => Plugin.PerformPhase2.ShouldBeFalse();
		It should_not_respond_to_formatting_requests_in_phase_3 = () => Plugin.PerformPhase3.ShouldBeFalse();

		It should_have_set_the_entry_template_on_the_formatter =
			() => EntryFormatter.EntryTemplate.ShouldEqual("EntryTemplate");

		It should_have_set_the_entry_pattern_on_the_formatter =
			() => PageFormatter.EntryPattern.ShouldEqual("Entry");

		It should_have_set_the_list_start_on_the_formatter =
			() => PageFormatter.ListStartPattern.ShouldEqual("ListStart");

		It should_have_set_the_list_end_on_the_formatter = () => PageFormatter.ListEndPattern.ShouldEqual("ListEnd");

		It should_have_set_the_waiting_list_end_on_the_formatter =
			() => PageFormatter.WaitingListEndPattern.ShouldEqual("WaitingListEnd");

		It should_have_set_the_maximum_attendee_number_on_the_formatter =
			() => PageFormatter.MaximumAttendees.ShouldEqual(10);
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_a_user_account_is_activated : With_configured_auto_registration_plugin
	{
		static IPagesStorageProvider Provider;
		static UserAccountActivityEventArgs EventArgs;
		protected static UserInfo UserInfo;
		static User User;

		Establish context = () =>
			{
				UserInfo = new UserInfo("user",
				                        "email@example.com",
				                        true,
				                        DateTime.Now,
				                        false,
				                        MockRepository.GenerateStub<IUsersStorageProvider>());
				EventArgs = new UserAccountActivityEventArgs(UserInfo, UserAccountActivity.AccountActivated);

				User = new User("user");
				RegistrationRepository.Stub(x => x.FindByUserName("user")).Return(User);

				PageInfo = new PageInfo("page", null, PageStatus.Normal, DateTime.Now);
				PageRepository.Stub(x => x.FindPage("page")).Return(PageInfo);

				Host.Stub(x => x.GetPageContent(PageInfo)).Return(new PageContent(PageInfo,
				                                                                  "title",
				                                                                  "user that saved the content last",
				                                                                  DateTime.Now,
				                                                                  String.Empty,
				                                                                  "content"));
				Host.Stub(x => x.SendEmail(null, null, null, null, false)).IgnoreArguments().Return(true);

				EntryFormatter.Stub(x => x.FormatUserEntry(User)).Return(" and entry");
				PageFormatter.Stub(x => x.AddEntry("content", " and entry")).Return("content and entry");
			};

		Because of = () => Host.Raise(x => x.UserAccountActivity += null, null, EventArgs);

		It should_try_to_find_the_user_in_the_user_list =
			() => RegistrationRepository.AssertWasCalled(x => x.FindByUserName(User.UserName));

		It should_find_the_attendee_page =
			() => PageRepository.AssertWasCalled(x => x.FindPage("page"), o => o.Repeat.Twice());

		It should_load_the_attendee_page_contents =
			() => Host.AssertWasCalled(x => x.GetPageContent(PageInfo));

		It should_format_the_users_entry = () => EntryFormatter.AssertWasCalled(x => x.FormatUserEntry(User));

		It should_add_the_users_entry_to_the_attendee_page =
			() => PageFormatter.AssertWasCalled(x => x.AddEntry("content", " and entry"));

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
			                                                 Arg<string>.Is.Equal("AutoRegistration"),
			                                                 Arg<string>.Is.Anything));

		It should_notify_the_user_about_the_activation =
			() => NotificationSender.AssertWasCalled(x => x.SendMessage(Arg<string>.Is.Equal(UserInfo.Username),
			                                                            Arg<string>.Is.Equal(UserInfo.Email),
			                                                            Arg<string>.Is.NotNull,
			                                                            Arg<bool>.Is.Equal(false)));

		It should_delete_the_user = () => RegistrationRepository.AssertWasCalled(x => x.Delete("user"));
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
			() => PageFormatter.AssertWasNotCalled(x => x.AddEntry(null, null), o => o.IgnoreArguments());
	}

	[Behaviors]
	public class FailureNotificationBehavior
	{
		protected static INotificationSender NotificationSender;
		protected static UserInfo UserInfo;

		It should_notify_the_administrator_about_the_failure =
			() => NotificationSender.AssertWasCalled(x => x.SendMessage(Arg<string>.Is.NotNull,
			                                                            Arg<string>.Is.NotEqual(UserInfo.Email),
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
				PageRepository.Stub(x => x.FindPage("page")).Return(null);
				PageRepository.Replay();
			};

		It should_log_that_the_page_does_not_exist =
			() => Logger.AssertWasCalled(x => x.Error("The attendee page 'page' does not exist.", "SYSTEM"));

		It should_not_add_the_users_entry_to_the_attendee_page =
			() => PageFormatter.AssertWasNotCalled(x => x.AddEntry(null, null), o => o.IgnoreArguments());

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
			() => PageFormatter.AssertWasNotCalled(x => x.AddEntry(null, null), o => o.IgnoreArguments());

		Behaves_like<FailureNotificationBehavior> failing_activation;
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_a_user_account_is_activated_and_users_entry_cannot_be_added
		: When_a_user_account_is_activated
	{
		Establish context = () =>
			{
				PageFormatter.BackToRecord();
				PageFormatter.Stub(x => x.AddEntry(null, null)).IgnoreArguments().Throw(new Exception());
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
	public class When_any_other_user_account_activity_takes_place : With_configured_auto_registration_plugin
	{
		static UserAccountActivityEventArgs EventArgs;
		static UserInfo UserInfo;

		Establish context = () =>
			{
				UserInfo = new UserInfo("user",
				                        "email@example.com",
				                        true,
				                        DateTime.Now,
				                        false,
				                        MockRepository.GenerateStub<IUsersStorageProvider>());
				EventArgs = new UserAccountActivityEventArgs(UserInfo, UserAccountActivity.AccountAdded);
			};

		Because of = () => Host.Raise(x => x.UserAccountActivity += null, null, EventArgs);

		It should_not_load_users = () => RegistrationRepository.AssertWasNotCalled(x => x.GetAll());

		It should_not_save_users = () => RegistrationRepository.AssertWasNotCalled(x => x.Save(Arg<User>.Is.Anything));

		It should_not_delete_users = () => RegistrationRepository.AssertWasNotCalled(x => x.Delete(Arg<string>.Is.Anything));
	}
}