using System;

using Machine.Specifications;

using NOS.Registration.Commands;
using NOS.Registration.DataAccess;
using NOS.Registration.Model;
using NOS.Registration.Queries;

using Rhino.Mocks;

using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration.Tests.Commands
{
	[Subject(typeof(DeactivateUserCommand))]
	public class When_a_user_is_deactivated
	{
		static DeactivateUserCommand Command;
		static UserInfo UserInfo;
		static ReturnValue Result;
		static IRegistrationRepository Registrations;

		Establish context = () =>
			{
				UserInfo = new UserInfo("user",
				                        "The User",
				                        "email@example.com",
				                        true,
				                        DateTime.Now,
				                        MockRepository.GenerateStub<IUsersStorageProviderV30>());

				Registrations = MockRepository.GenerateStub<IRegistrationRepository>();
				Registrations
					.Stub(x => x.Query(Arg<UserByUserName>.Is.TypeOf))
					.Return(new User("user"));

				Command = new DeactivateUserCommand(Registrations,
				                                    new FakeSynchronizer());
			};

		Because of = () => { Result = Command.Execute(new DeactivateUserMessage(UserInfo)); };

		It should_succeed =
			() => Result.Messages.ShouldBeEmpty();

		It should_save_the_user =
			() => Registrations.AssertWasCalled(x => x.Save(Arg<User>.Matches(y => y.Active == false)));
	}

	[Subject(typeof(DeactivateUserCommand))]
	public class When_a_user_without_registration_data_is_deactivated
	{
		static DeactivateUserCommand Command;
		static UserInfo UserInfo;
		static ReturnValue Result;
		static IRegistrationRepository Registrations;

		Establish context = () =>
			{
				UserInfo = new UserInfo("user",
				                        "The User",
				                        "email@example.com",
				                        true,
				                        DateTime.Now,
				                        MockRepository.GenerateStub<IUsersStorageProviderV30>());

				Registrations = MockRepository.GenerateStub<IRegistrationRepository>();

				Command = new DeactivateUserCommand(Registrations,
				                                    new FakeSynchronizer());
			};

		Because of = () => { Result = Command.Execute(new DeactivateUserMessage(UserInfo)); };

		It should_succeed =
			() => Result.Messages.ShouldBeEmpty();

		It should_not_save_the_user =
			() => Registrations.AssertWasNotCalled(x => x.Save(null), o => o.IgnoreArguments());
	}
}