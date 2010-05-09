using System;

using Machine.Specifications;

using NOS.Registration.Abstractions;
using NOS.Registration.Commands;
using NOS.Registration.Commands.Infrastructure;

using Rhino.Mocks;

using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration.Tests
{
	public abstract class AutoRegistrationPluginSpecs
	{
		protected static ICommandInvoker CommandInvoker;
		protected static IHostV30 Host;
		protected static ILogger Logger;
		protected static AutoRegistrationPlugin Plugin;

		Establish context = () =>
			{
				Host = MockRepository.GenerateStub<IHostV30>();
				Logger = MockRepository.GenerateStub<ILogger>();
				CommandInvoker = MockRepository.GenerateStub<ICommandInvoker>();

				Plugin = new AutoRegistrationPlugin(Logger, CommandInvoker);
			};

		protected static void Initialize(AutoRegistrationPlugin plugin)
		{
			var result = new ExecutionResult();
			result.ReturnItems.Add(MockRepository.GenerateStub<IPluginConfiguration>());

			CommandInvoker
				.Stub(x => x.Process(Arg<ConfigureEnvironmentMessage>.Is.TypeOf))
				.Return(result)
				.Repeat.Once();

			plugin.Init(Host, String.Empty);
		}
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_the_auto_registration_plugin_initialization_fails : AutoRegistrationPluginSpecs
	{
		Establish context = () =>
			{
				var result = new ExecutionResult();
				result.Merge(ReturnValue.Fail(new[] { "some initalization error", "some initalization error" }));

				CommandInvoker
					.Stub(x => x.Process(Arg<ConfigureEnvironmentMessage>.Is.TypeOf))
					.Return(result);
			};

		Because of = () => Plugin.Init(Host, String.Empty);

		It should_log_all_configuration_errors =
			() => Logger.AssertWasCalled(x => x.Error("some initalization error", "SYSTEM"),
			                             o => o.Repeat.Twice());

		It should_log_that_the_plugin_is_disabled =
			() => Logger.AssertWasCalled(x => x.Error("The auto registration plugin will be disabled.", "SYSTEM"));

		It should_disable_the_plugin =
			() => Host.AssertWasNotCalled(x => x.UserAccountActivity += Arg<EventHandler<UserAccountActivityEventArgs>>
			                                                            	.Is.Anything);
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_the_auto_registration_plugin_is_initialized_successfully : AutoRegistrationPluginSpecs
	{
		Establish context = () =>
			{
				var config = MockRepository.GenerateStub<IPluginConfiguration>();
				config
					.Stub(x => x.MaximumAttendees)
					.Return(15);
				config
					.Stub(x => x.HardLimit)
					.Return(42);

				var result = new ExecutionResult();
				result.ReturnItems.Add(config);

				CommandInvoker
					.Stub(x => x.Process(Arg<ConfigureEnvironmentMessage>.Is.TypeOf))
					.Return(result);
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
	public class When_the_auto_registration_plugin_is_shut_down : AutoRegistrationPluginSpecs
	{
		Establish context = () => Initialize(Plugin);

		Because of = () => Plugin.Shutdown();

		It should_disable_the_plugin =
			() => Host.AssertWasCalled(x => x.UserAccountActivity -= Arg<EventHandler<UserAccountActivityEventArgs>>.Is.NotNull);
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_page_content_is_formatted : AutoRegistrationPluginSpecs
	{
		static string Formatted;

		Establish context = () =>
			{
				var result = new ExecutionResult();
				result.ReturnItems.Add("formatted");

				CommandInvoker
					.Stub(x => x.Process(Arg<FormatContentMessage>.Matches(y => y.RawContent == "raw")))
					.Return(result);
			};

		Because of = () => { Formatted = Plugin.Format("raw", null, FormattingPhase.Phase3); };

		It should_return_the_result_after_processing_the_formatting_message =
			() => Formatted.ShouldEqual("formatted");
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_a_user_account_is_activated : AutoRegistrationPluginSpecs
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
				EventArgs = new UserAccountActivityEventArgs(UserInfo, UserAccountActivity.AccountActivated);

				Initialize(Plugin);
			};

		Because of = () => Host.Raise(x => x.UserAccountActivity += null, null, EventArgs);

		It should_process_the_user_account_activation_message =
			() => CommandInvoker.AssertWasCalled(x => x.Process(Arg<ActivateUserMessage>
			                                                    	.Matches(
			                                                    		y => y.UserName == "user" && y.Email == "email@example.com")));
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_a_user_account_is_deactivated : AutoRegistrationPluginSpecs
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
				EventArgs = new UserAccountActivityEventArgs(UserInfo, UserAccountActivity.AccountDeactivated);

				Initialize(Plugin);
			};

		Because of = () => Host.Raise(x => x.UserAccountActivity += null, null, EventArgs);

		It should_process_the_user_account_activation_message =
			() => CommandInvoker.AssertWasCalled(x => x.Process(Arg<DeactivateUserMessage>.Matches(y => y.UserName == "user")));
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_a_user_account_is_activated_through_the_admin_interface : AutoRegistrationPluginSpecs
	{
		static UserAccountActivityEventArgs EventArgs;
		static UserInfo UserInfo;

		Establish context = () =>
			{
				UserInfo = new UserInfo("user",
				                        "The User",
				                        "email@example.com",
				                        false,
				                        DateTime.Now,
				                        MockRepository.GenerateStub<IUsersStorageProviderV30>());
				EventArgs = new UserAccountActivityEventArgs(UserInfo, UserAccountActivity.AccountModified);

				Initialize(Plugin);
			};

		Because of = () => Host.Raise(x => x.UserAccountActivity += null, null, EventArgs);

		It should_process_the_user_account_activation_message =
			() => CommandInvoker.AssertWasCalled(x => x.Process(Arg<ActivateUserMessage>
			                                                    	.Matches(
			                                                    		y => y.UserName == "user" && y.Email == "email@example.com")));
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_a_user_account_is_deactivated_through_the_admin_interface : AutoRegistrationPluginSpecs
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
				EventArgs = new UserAccountActivityEventArgs(UserInfo, UserAccountActivity.AccountModified);

				Initialize(Plugin);
			};

		Because of = () => Host.Raise(x => x.UserAccountActivity += null, null, EventArgs);

		It should_process_the_user_account_activation_message =
			() => CommandInvoker.AssertWasCalled(x => x.Process(Arg<DeactivateUserMessage>.Matches(y => y.UserName == "user")));
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_a_user_account_is_deleted : AutoRegistrationPluginSpecs
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
				EventArgs = new UserAccountActivityEventArgs(UserInfo, UserAccountActivity.AccountRemoved);

				Initialize(Plugin);
			};

		Because of = () => Host.Raise(x => x.UserAccountActivity += null, null, EventArgs);

		It should_process_the_user_account_deletion_message =
			() => CommandInvoker.AssertWasCalled(x => x.Process(Arg<DeleteUserMessage>.Matches(y => y.UserName == "user")));
	}

	[Subject(typeof(AutoRegistrationPlugin))]
	public class When_any_other_user_account_activity_takes_place : AutoRegistrationPluginSpecs
	{
		static UserAccountActivityEventArgs EventArgs;

		Establish context = () =>
			{
				EventArgs = new UserAccountActivityEventArgs(null, UserAccountActivity.AccountAdded);

				Initialize(Plugin);
			};

		Because of = () => Host.Raise(x => x.UserAccountActivity += null, null, EventArgs);

		It should_not_process_any_user_related_message = () =>
			{
				CommandInvoker.AssertWasNotCalled(x => x.Process(Arg<ActivateUserMessage>.Is.TypeOf));
				CommandInvoker.AssertWasNotCalled(x => x.Process(Arg<DeactivateUserMessage>.Is.TypeOf));
				CommandInvoker.AssertWasNotCalled(x => x.Process(Arg<DeleteUserMessage>.Is.TypeOf));
			};
	}
}