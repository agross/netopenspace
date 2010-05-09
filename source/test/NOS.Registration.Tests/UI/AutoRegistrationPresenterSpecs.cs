using System;

using Machine.Specifications;

using NOS.Registration.Commands;
using NOS.Registration.Commands.Infrastructure;
using NOS.Registration.UI;

using Rhino.Mocks;

namespace NOS.Registration.Tests.UI
{
	[Subject(typeof(AutoRegistrationPresenter))]
	public class When_the_auto_registration_presenter_is_created
	{
		static AutoRegistrationPresenter Presenter;
		static IAutoRegistrationView View;
		static ICommandInvoker CommandInvoker;

		Establish context = () =>
			{
				View = MockRepository.GenerateStub<IAutoRegistrationView>();
				CommandInvoker = MockRepository.GenerateStub<ICommandInvoker>();
			};

		Because of = () => { new AutoRegistrationPresenter(View, CommandInvoker); };

		It should_subscribe_to_user_creation_event =
			() => View.AssertWasCalled(x => x.UserCreated += Arg<EventHandler<EventArgs>>.Is.NotNull);
	}

	[Subject(typeof(AutoRegistrationPresenter))]
	public class When_a_user_is_created
	{
		static AutoRegistrationPresenter Presenter;
		static IAutoRegistrationView View;
		static ICommandInvoker CommandInvoker;

		Establish context = () =>
			{
				View = MockRepository.GenerateStub<IAutoRegistrationView>();
				CommandInvoker = MockRepository.GenerateStub<ICommandInvoker>();
				new AutoRegistrationPresenter(View, CommandInvoker);
			};

		Because of = () => View.Raise(x => x.UserCreated += null, null, EventArgs.Empty);

		It should_process_the_user_creation_message =
			() => CommandInvoker.AssertWasCalled(x => x.Process(Arg<CreateUserMessage>.Matches(y => y.View == View)));
	}
}