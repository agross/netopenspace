using System;
using System.Collections.Generic;
using System.Linq;

using Machine.Specifications;

using NOS.Registration.Abstractions;
using NOS.Registration.Formatting;
using NOS.Registration.Model;
using NOS.Registration.Queries;

using Rhino.Mocks;

using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration.Tests
{
	public abstract class AutoRegistrationPluginSpecs
	{
		protected static IPluginConfiguration Configuration;
		protected static IEntryFormatter EntryFormatter;
		protected static IMarkupFormatter[] MarkupFormatters;
		protected static IHostV30 Host;
		protected static ILogger Logger;
		protected static INotificationSender NotificationSender;
		protected static AutoRegistrationPlugin Plugin;
		protected static IRegistrationRepository RegistrationRepository;

		Establish context = () =>
			{
				Host = MockRepository.GenerateStub<IHostV30>();

				ISynchronizer synchronizer = MockRepository.GenerateStub<ISynchronizer>();
				synchronizer
					.Stub(x => x.Lock(Arg<Action>.Is.Anything))
					.WhenCalled(invocation => ((Action) invocation.Arguments.First()).Invoke());

				RegistrationRepository = MockRepository.GenerateStub<IRegistrationRepository>();
				Logger = MockRepository.GenerateStub<ILogger>();
				EntryFormatter = MockRepository.GenerateStub<IEntryFormatter>();
				NotificationSender = MockRepository.GenerateStub<INotificationSender>();
				Configuration = MockRepository.GenerateStub<IPluginConfiguration>();

				var settingsAccessor = MockRepository.GenerateStub<ISettingsAccessor>();

				MarkupFormatters = new[]
				             {
				             	MockRepository.GenerateStub<IMarkupFormatter>(),
				             	MockRepository.GenerateStub<IMarkupFormatter>()
				             };

				Plugin = new AutoRegistrationPlugin(synchronizer,
				                                    RegistrationRepository,
				                                    NotificationSender,
				                                    Logger,
				                                    Configuration,
				                                    settingsAccessor,
				                                    MarkupFormatters);
			};
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_the_auto_registration_is_initialized_with_invalid_configuration_data : AutoRegistrationPluginSpecs
	{
		Establish context = () => Configuration.Stub(x => x.Parse(null))
		                          	.IgnoreArguments()
		                          	.Return(new List<string> { "error1", "error2" });

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
	public class When_the_auto_registration_is_initialized_successfully : AutoRegistrationPluginSpecs
	{
		Establish context = () =>
			{
				Configuration
					.Stub(x => x.Parse(null))
					.IgnoreArguments()
					.Return(new List<string>());

				Configuration.Stub(x => x.MaximumAttendees).Return(15);
				Configuration.Stub(x => x.HardLimit).Return(42);
			};

		Because of = () => Plugin.Init(Host, String.Empty);

		It should_enable_the_plugin =
			() => Host.AssertWasCalled(x => x.UserAccountActivity += Arg<EventHandler<UserAccountActivityEventArgs>>.Is.NotNull);

		It should_log_the_maximum_attendee_count_and_the_hard_limit =
			() => Logger.AssertWasCalled(x => x.Info("Waiting list is enabled after 15 attendees with a hard limit of 42.",
			                                         "SYSTEM"));

		It should_not_respond_to_formatting_requests_in_phase_1 =
			() => Plugin.PerformPhase1.ShouldBeFalse();

		It should_not_respond_to_formatting_requests_in_phase_2 =
			() => Plugin.PerformPhase2.ShouldBeFalse();

		It should_render_on_each_request_regardless_of_the_cache =
			() => Plugin.PerformPhase3.ShouldBeTrue();
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_the_auto_registration_is_shut_down : AutoRegistrationPluginSpecs
	{
		Establish context = () =>
			{
				Configuration
					.Stub(x => x.Parse(null))
					.IgnoreArguments()
					.Return(new List<string>());

				Configuration.Stub(x => x.MaximumAttendees).Return(15);
				Configuration.Stub(x => x.HardLimit).Return(42);

				Plugin.Init(Host, String.Empty);
			};

		Because of = () => Plugin.Shutdown();

		It should_disable_the_plugin =
			() => Host.AssertWasCalled(x => x.UserAccountActivity -= Arg<EventHandler<UserAccountActivityEventArgs>>.Is.NotNull);
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_page_content_is_formatted : AutoRegistrationPluginSpecs
	{
		static string Formatted;

		Establish context = () => MarkupFormatters.Last()
		                          	.Stub(x => x.Format(null))
		                          	.Return("formatted");

		Because of = () => { Formatted = Plugin.Format("raw", null, FormattingPhase.Phase3); };

		It should_return_the_formatted_result_of_the_last_formatter =
			() => Formatted.ShouldEqual("formatted");

		It should_format_the_content_with_all_known_formatters =
			() => MarkupFormatters.Each(x => x.AssertWasCalled(y => y.Format(Arg<string>.Is.Anything)));
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_a_user_account_is_activated : AutoRegistrationPluginSpecs
	{
		static IPagesStorageProviderV30 Provider;
		static UserAccountActivityEventArgs EventArgs;
		protected static UserInfo UserInfo;
		static User User;
		protected static PageInfo PageInfo;

		Establish context = () =>
			{
				UserInfo = new UserInfo("user",
				                        "The User",
				                        "email@example.com",
				                        true,
				                        DateTime.Now,
				                        MockRepository.GenerateStub<IUsersStorageProviderV30>());
				EventArgs = new UserAccountActivityEventArgs(UserInfo, UserAccountActivity.AccountActivated);

				User = new User("user");
				RegistrationRepository
					.Stub(x => x.Query(Arg<UserByUserName>.Matches(y => y.UserName == "user")))
					.Return(User);

				Configuration
					.Stub(x => x.Parse(null))
					.IgnoreArguments()
					.Return(new List<string>());

				Host
					.Stub(x => x.SendEmail(null, null, null, null, false))
					.IgnoreArguments()
					.Return(true);

				Plugin.Init(Host, String.Empty);

				EntryFormatter
					.Stub(x => x.FormatUserEntry(User, Configuration.EntryTemplate))
					.Return(Configuration.EntryTemplate);
			};

		Because of = () => Host.Raise(x => x.UserAccountActivity += null, null, EventArgs);

		It should_try_to_find_the_user_in_the_user_list =
			() =>
			RegistrationRepository.AssertWasCalled(x => x.Query(Arg<UserByUserName>.Matches(y => y.UserName == User.UserName)));

		It should_notify_the_user_about_the_activation =
			() => NotificationSender.AssertWasCalled(x => x.SendMessage(Arg<string>.Is.Equal(UserInfo.Username),
			                                                            Arg<string>.Is.Equal(UserInfo.Email),
			                                                            Arg<string>.Is.Equal("AutoRegistration"),
			                                                            Arg<bool>.Is.Equal(false)));

		It should_not_delete_the_user = () => RegistrationRepository.AssertWasNotCalled(x => x.Delete("user"));
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
	public class When_any_other_user_account_activity_takes_place : AutoRegistrationPluginSpecs
	{
		static UserAccountActivityEventArgs EventArgs;
		static UserInfo UserInfo;

		Establish context = () =>
			{
				UserInfo = new UserInfo("user",
				                        "The User",
				                        "email@example.com",
				                        true,
				                        DateTime.Now,
				                        MockRepository.GenerateStub<IUsersStorageProviderV30>());
				EventArgs = new UserAccountActivityEventArgs(UserInfo, UserAccountActivity.AccountAdded);
			};

		Because of = () => Host.Raise(x => x.UserAccountActivity += null, null, EventArgs);

		It should_not_load_users =
			() => RegistrationRepository.AssertWasNotCalled(x => x.Query(Arg<AllUsers>.Is.TypeOf));

		It should_not_save_users =
			() => RegistrationRepository.AssertWasNotCalled(x => x.Save(Arg<User>.Is.Anything));

		It should_not_delete_users =
			() => RegistrationRepository.AssertWasNotCalled(x => x.Delete(Arg<string>.Is.Anything));
	}
}