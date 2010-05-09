using System;

using Machine.Specifications;

using NOS.Registration.Abstractions;
using NOS.Registration.Commands;
using NOS.Registration.DataAccess;
using NOS.Registration.Model;
using NOS.Registration.Queries;
using NOS.Registration.UI;

using Rhino.Mocks;

namespace NOS.Registration.Tests.Commands
{
	[Subject(typeof(CreateUserCommand))]
	public class When_a_user_that_wants_to_register_is_created
	{
		static CreateUserCommand Command;
		static ReturnValue Result;
		static IRegistrationRepository Registrations;
		static IAutoRegistrationView View;

		Establish context = () =>
			{
				View = MockRepository.GenerateStub<IAutoRegistrationView>();
				View.Stub(x => x.AutoRegisterUser).Return(true);
				View.Stub(x => x.UserName).Return("user name");
				View.Stub(x => x.Xing).Return("xing");
				View.Stub(x => x.Twitter).Return("twitter");
				View.Stub(x => x.Name).Return("name");
				View.Stub(x => x.Email).Return("email");
				View.Stub(x => x.Blog).Return("blog");
				View.Stub(x => x.Picture).Return("picture");
				View.Stub(x => x.Sponsoring).Return(12.34m);

				Registrations = MockRepository.GenerateStub<IRegistrationRepository>();
				Registrations
					.Stub(x => x.Query(Arg<UserByUserName>.Is.TypeOf))
					.Return(new User("user"));

				Command = new CreateUserCommand(MockRepository.GenerateStub<ILogger>(), Registrations);
			};

		Because of = () => { Result = Command.Execute(new CreateUserMessage(View)); };

		It should_succeed =
			() => Result.Messages.ShouldBeEmpty();

		It should_save_the_user =
			() => Registrations.AssertWasCalled(x => x.Save(Arg<User>.Is.NotNull));

		It should_save_the_user_as_being_inactive =
			() => Registrations.AssertWasCalled(x => x.Save(Arg<User>.Matches(y => y.Active == false)));

		It should_save_the_user_as_preferring_to_attend =
			() =>
			Registrations.AssertWasCalled(x => x.Save(Arg<User>.Matches(y => y.Participation.Preference == Preference.Attend)));

		It should_save_the_user_as_being_refused =
			() => Registrations.AssertWasCalled(x => x.Save(Arg<User>.Matches(y => y.Participation.Result == Request.Refused)));

		It should_save_the_Wiki_user_name_from_the_view =
			() => Registrations.AssertWasCalled(x => x.Save(Arg<User>.Matches(y => y.UserName.Equals("user name"))));

		It should_save_the_Xing_user_name_from_the_view =
			() => Registrations.AssertWasCalled(x => x.Save(Arg<User>.Matches(y => y.Data.Xing.Equals("xing"))));

		It should_save_the_Twitter_user_name_from_the_view =
			() => Registrations.AssertWasCalled(x => x.Save(Arg<User>.Matches(y => y.Data.Twitter.Equals("twitter"))));

		It should_save_the_name_from_the_view =
			() => Registrations.AssertWasCalled(x => x.Save(Arg<User>.Matches(y => y.Data.Name.Equals("name"))));

		It should_save_the_email_address_from_the_view =
			() => Registrations.AssertWasCalled(x => x.Save(Arg<User>.Matches(y => y.Data.Email.Equals("email"))));

		It should_save_the_blog_URL_from_the_view =
			() => Registrations.AssertWasCalled(x => x.Save(Arg<User>.Matches(y => y.Data.Blog.Equals("blog"))));

		It should_save_the_picture_URL_from_the_view =
			() => Registrations.AssertWasCalled(x => x.Save(Arg<User>.Matches(y => y.Data.Picture.Equals("picture"))));

		It should_save_the_sponsoring_value_from_the_view =
			() => Registrations.AssertWasCalled(x => x.Save(Arg<User>.Matches(y => y.Data.Sponsoring.Equals(12.34m))));
	}

	[Subject(typeof(CreateUserCommand))]
	public class When_a_user_is_created_that_does_not_want_to_auto_register
	{
		static CreateUserCommand Command;
		static ReturnValue Result;
		static IRegistrationRepository Registrations;
		static IAutoRegistrationView View;
		static ILogger Logger;

		Establish context = () =>
			{
				View = MockRepository.GenerateStub<IAutoRegistrationView>();
				View.Stub(x => x.AutoRegisterUser).Return(false);
				View.Stub(x => x.UserName).Return("user name");

				Logger = MockRepository.GenerateStub<ILogger>();
				Registrations = MockRepository.GenerateStub<IRegistrationRepository>();

				Command = new CreateUserCommand(Logger, Registrations);
			};

		Because of = () => { Result = Command.Execute(new CreateUserMessage(View)); };

		It should_succeed =
			() => Result.Messages.ShouldBeEmpty();

		It should_not_save_the_user =
			() => Registrations.AssertWasNotCalled(x => x.Save(null), o => o.IgnoreArguments());

		It should_log_the_fact_that_the_user_does_not_want_to_be_registered_automatically =
			() => Logger.AssertWasCalled(x => x.Info(Arg<string>.Matches(y => y.Contains("opted out")),
			                                         Arg<string>.Is.Equal("user name")));
	}

	[Subject(typeof(CreateUserCommand))]
	public class When_creating_the_user_fails
	{
		static CreateUserCommand Command;
		static ReturnValue Result;
		static IRegistrationRepository Registrations;
		static IAutoRegistrationView View;
		static ILogger Logger;

		Establish context = () =>
			{
				View = MockRepository.GenerateStub<IAutoRegistrationView>();
				View.Stub(x => x.AutoRegisterUser).Return(true);
				View.Stub(x => x.UserName).Return("user name");

				Logger = MockRepository.GenerateStub<ILogger>();

				Registrations = MockRepository.GenerateStub<IRegistrationRepository>();
				Registrations
					.Stub(x => x.Save(Arg<User>.Is.Anything))
					.Throw(new Exception());

				Command = new CreateUserCommand(Logger, Registrations);
			};

		Because of = () => { Result = Command.Execute(new CreateUserMessage(View)); };

		It should_fail =
			() => Result.Messages.ShouldNotBeEmpty();

		It should_log_the_fact_that_saving_the_registration_data_failed =
			() => Logger.AssertWasCalled(x => x.Error(Arg<string>.Matches(y => y.Contains("failed")),
			                                          Arg<string>.Is.Equal("user name")));
	}
}