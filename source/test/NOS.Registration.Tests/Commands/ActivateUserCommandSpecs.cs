using System;

using Machine.Specifications;

using NOS.Registration.Abstractions;
using NOS.Registration.Commands;
using NOS.Registration.DataAccess;
using NOS.Registration.Model;
using NOS.Registration.Queries;
using NOS.Registration.Tests.ForTesting;

using Rhino.Mocks;

namespace NOS.Registration.Tests.Commands
{
	[Subject(typeof(ActivateUserCommand))]
	public class When_a_user_account_is_activated
	{
		static ActivateUserCommand Command;
		static ReturnValue Result;
		static IRegistrationRepository Registrations;
		static INotificationSender NotificationSender;

		Establish context = () =>
			{
				Registrations = MockRepository.GenerateStub<IRegistrationRepository>();
				Registrations
					.Stub(x => x.Query(Arg<UserByUserName>.Is.TypeOf))
					.Return(New.User.Named("user").Inactive());

				NotificationSender = MockRepository.GenerateStub<INotificationSender>();

				Command = new ActivateUserCommand(Registrations,
				                                  new FakeSynchronizer(),
				                                  NotificationSender,
				                                  MockRepository.GenerateStub<IWikiSettings>());
			};

		Because of = () => { Result = Command.Execute(new ActivateUserMessage("user", "email@example.com")); };

		It should_succeed =
			() => Result.Messages.ShouldBeEmpty();

		It should_save_the_user =
			() => Registrations.AssertWasCalled(x => x.Save(Arg<User>.Matches(y => y.Active)));

		It should_notify_the_user_about_the_successful_registration =
			() => NotificationSender.AssertWasCalled(x => x.SendMessage("user",
			                                                            "email@example.com",
			                                                            "AutoRegistration",
																		"AutoRegistrationSuccessfulMessage"));

		It should_not_delete_the_user =
			() => Registrations.AssertWasNotCalled(x => x.Delete(null), o => o.IgnoreArguments());
	}

	[Subject(typeof(ActivateUserCommand))]
	public class When_a_user_without_registration_data_is_activated
	{
		static ActivateUserCommand Command;
		static ReturnValue Result;
		static IRegistrationRepository Registrations;
		static INotificationSender NotificationSender;

		Establish context = () =>
			{
				Registrations = MockRepository.GenerateStub<IRegistrationRepository>();
				NotificationSender = MockRepository.GenerateStub<INotificationSender>();

				Command = new ActivateUserCommand(Registrations,
				                                  new FakeSynchronizer(),
				                                  NotificationSender,
				                                  MockRepository.GenerateStub<IWikiSettings>());
			};

		Because of = () => { Result = Command.Execute(new ActivateUserMessage("user", "email@example.com")); };

		It should_succeed =
			() => Result.Messages.ShouldBeEmpty();

		It should_not_save_the_user =
			() => Registrations.AssertWasNotCalled(x => x.Save(null), o => o.IgnoreArguments());

		It should_not_notify_the_user =
			() => NotificationSender.AssertWasNotCalled(x => x.SendMessage(null, null, null, null),
			                                            o => o.IgnoreArguments());

		It should_not_delete_the_user =
			() => Registrations.AssertWasNotCalled(x => x.Delete(null), o => o.IgnoreArguments());
	}

	[Subject(typeof(ActivateUserCommand))]
	public class When_a_user_is_activated_for_the_second_time
	{
		static ActivateUserCommand Command;
		static ReturnValue Result;
		static IRegistrationRepository Registrations;
		static INotificationSender NotificationSender;

		Establish context = () =>
			{
				Registrations = MockRepository.GenerateStub<IRegistrationRepository>();
				Registrations
					.Stub(x => x.Query(Arg<UserByUserName>.Is.TypeOf))
					.Return(New.User.Named("user").Active());

				NotificationSender = MockRepository.GenerateStub<INotificationSender>();

				Command = new ActivateUserCommand(Registrations,
				                                  new FakeSynchronizer(),
				                                  NotificationSender,
				                                  MockRepository.GenerateStub<IWikiSettings>());
			};

		Because of = () => { Result = Command.Execute(new ActivateUserMessage("user", "email@example.com")); };

		It should_succeed =
			() => Result.Messages.ShouldBeEmpty();

		It should_not_save_the_user =
			() => Registrations.AssertWasNotCalled(x => x.Save(null), o => o.IgnoreArguments());

		It should_not_notify_the_user =
			() => NotificationSender.AssertWasNotCalled(x => x.SendMessage(null, null, null, null),
			                                            o => o.IgnoreArguments());

		It should_not_delete_the_user =
			() => Registrations.AssertWasNotCalled(x => x.Delete(null), o => o.IgnoreArguments());
	}

	[Subject(typeof(ActivateUserCommand))]
	public class When_a_user_account_is_activated_and_registration_fails
	{
		static ActivateUserCommand Command;
		static ReturnValue Result;
		static IRegistrationRepository Registrations;
		static INotificationSender NotificationSender;

		Establish context = () =>
			{
				Registrations = MockRepository.GenerateStub<IRegistrationRepository>();
				Registrations
					.Stub(x => x.Query(Arg<UserByUserName>.Is.TypeOf))
					.Return(New.User.Named("user").Inactive());

				Registrations
					.Stub(x => x.Save(Arg<User>.Matches(y => y.Active)))
					.Throw(new Exception());

				NotificationSender = MockRepository.GenerateStub<INotificationSender>();

				var settingsAccessor = MockRepository.GenerateStub<IWikiSettings>();
				settingsAccessor
					.Stub(x => x.ContactEmail)
					.Return("admin@example.com");

				Command = new ActivateUserCommand(Registrations,
				                                  new FakeSynchronizer(),
				                                  NotificationSender,
				                                  settingsAccessor);
			};

		Because of = () => { Result = Command.Execute(new ActivateUserMessage("user", "email@example.com")); };

		It should_fail =
			() => Result.Messages.ShouldNotBeEmpty();

		It should_notify_the_user_about_the_failed_registration =
			() => NotificationSender.AssertWasCalled(x => x.SendMessage("user",
			                                                            "email@example.com",
			                                                            "AutoRegistration",
																		"AutoRegistrationFailedMessage"));

		It should_notify_the_administrator_about_the_failed_registration =
			() => NotificationSender.AssertWasCalled(x => x.SendMessage("user",
			                                                            "admin@example.com",
			                                                            "AutoRegistration",
																		"AutoRegistrationFailedMessage"));

		It should_not_delete_the_user =
			() => Registrations.AssertWasNotCalled(x => x.Delete(null), o => o.IgnoreArguments());
	}
}