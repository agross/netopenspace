using Machine.Specifications;

using NOS.Registration.Commands;
using NOS.Registration.DataAccess;
using NOS.Registration.Model;
using NOS.Registration.Queries;
using NOS.Registration.Tests.ForTesting;

using Rhino.Mocks;

namespace NOS.Registration.Tests.Commands
{
	[Subject(typeof(DeleteUserCommand))]
	public class When_a_user_is_deleted
	{
		static DeleteUserCommand Command;
		static ReturnValue Result;
		static IRegistrationRepository Registrations;

		Establish context = () =>
			{
				Registrations = MockRepository.GenerateStub<IRegistrationRepository>();
				Registrations
					.Stub(x => x.Query(Arg<UserByUserName>.Is.TypeOf))
					.Return(New.User.Named("user"));

				Command = new DeleteUserCommand(Registrations,
				                                new FakeSynchronizer());
			};

		Because of = () => { Result = Command.Execute(new DeleteUserMessage("user")); };

		It should_succeed =
			() => Result.Messages.ShouldBeEmpty();

		It should_delete_the_user =
			() => Registrations.AssertWasCalled(x => x.Delete(Arg<User>.Matches(y => y.UserName == "user")));
	}

	[Subject(typeof(DeleteUserCommand))]
	public class When_a_user_without_registration_data_is_deleted
	{
		static DeleteUserCommand Command;
		static ReturnValue Result;
		static IRegistrationRepository Registrations;

		Establish context = () =>
			{
				Registrations = MockRepository.GenerateStub<IRegistrationRepository>();

				Command = new DeleteUserCommand(Registrations,
				                                new FakeSynchronizer());
			};

		Because of = () => { Result = Command.Execute(new DeleteUserMessage("user")); };

		It should_succeed =
			() => Result.Messages.ShouldBeEmpty();

		It should_not_delete_the_user =
			() => Registrations.AssertWasNotCalled(x => x.Delete(null), o => o.IgnoreArguments());
	}
}