using Machine.Specifications;

using NOS.Registration.Commands;
using NOS.Registration.DataAccess;
using NOS.Registration.Model;
using NOS.Registration.Queries;
using NOS.Registration.Tests.ForTesting;

using Rhino.Mocks;

namespace NOS.Registration.Tests.Commands
{
	[Subject(typeof(DeactivateUserCommand))]
	public class When_a_user_is_deactivated
	{
		static DeactivateUserCommand Command;
		static ReturnValue Result;
		static IRegistrationRepository Registrations;

		Establish context = () =>
			{
				Registrations = MockRepository.GenerateStub<IRegistrationRepository>();
				Registrations
					.Stub(x => x.Query(Arg<UserByUserName>.Is.TypeOf))
					.Return(New.User.Named("user").Active());

				Command = new DeactivateUserCommand(Registrations,
				                                    new FakeSynchronizer());
			};

		Because of = () => { Result = Command.Execute(new DeactivateUserMessage("user")); };

		It should_succeed =
			() => Result.Messages.ShouldBeEmpty();

		It should_save_the_user =
			() => Registrations.AssertWasCalled(x => x.Save(Arg<User>.Matches(y => y.Active == false)));
	}
	
	[Subject(typeof(DeactivateUserCommand))]
	public class When_a_user_is_deactivated_for_the_second_time
	{
		static DeactivateUserCommand Command;
		static ReturnValue Result;
		static IRegistrationRepository Registrations;

		Establish context = () =>
			{
				Registrations = MockRepository.GenerateStub<IRegistrationRepository>();
				Registrations
					.Stub(x => x.Query(Arg<UserByUserName>.Is.TypeOf))
					.Return(New.User.Named("user").Inactive());

				Command = new DeactivateUserCommand(Registrations,
				                                    new FakeSynchronizer());
			};

		Because of = () => { Result = Command.Execute(new DeactivateUserMessage("user")); };

		It should_succeed =
			() => Result.Messages.ShouldBeEmpty();

		It should_not_save_the_user =
			() => Registrations.AssertWasNotCalled(x => x.Save(Arg<User>.Is.NotNull));
	}

	[Subject(typeof(DeactivateUserCommand))]
	public class When_a_user_without_registration_data_is_deactivated
	{
		static DeactivateUserCommand Command;
		static ReturnValue Result;
		static IRegistrationRepository Registrations;

		Establish context = () =>
			{
				Registrations = MockRepository.GenerateStub<IRegistrationRepository>();

				Command = new DeactivateUserCommand(Registrations,
				                                    new FakeSynchronizer());
			};

		Because of = () => { Result = Command.Execute(new DeactivateUserMessage("user")); };

		It should_succeed =
			() => Result.Messages.ShouldBeEmpty();

		It should_not_save_the_user =
			() => Registrations.AssertWasNotCalled(x => x.Save(null), o => o.IgnoreArguments());
	}
}