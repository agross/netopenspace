using System;
using System.Collections.Generic;
using System.Linq;

using Machine.Specifications;

using NOS.Registration.Commands;
using NOS.Registration.Commands.Infrastructure;
using NOS.Registration.ContainerConfiguration;
using NOS.Registration.EntryPositioning;
using NOS.Registration.EntryPositioning.Opinions;

using Rhino.Mocks;

using StructureMap;

namespace NOS.Registration.Tests
{
	[Subject(typeof(Container))]
	public class When_the_container_is_initialized
	{
		static AutoRegistrationPlugin Plugin;

		Because of = () =>
			{
				Container.BootstrapStructureMap();
				Plugin = new AutoRegistrationPlugin();
			};

		Cleanup after = Container.Release;

		It should_have_a_valid_configuration =
			ObjectFactory.AssertConfigurationIsValid;

		It should_be_able_to_create_an_instance_of_the_auto_registration_plugin =
			() => Plugin.ShouldNotBeNull();
	}

	[Subject(typeof(Container))]
	public class When_the_container_has_not_been_initialized
	{
		static AutoRegistrationPlugin Plugin;

		Establish context = Container.Release;

		Because of = () => { Plugin = new AutoRegistrationPlugin(); };

		Cleanup after = Container.Release;

		It should_have_a_valid_configuration =
			ObjectFactory.AssertConfigurationIsValid;

		It should_be_able_to_create_an_instance_of_the_auto_registration_plugin =
			() => Plugin.ShouldNotBeNull();
	}

	[Subject(typeof(Container))]
	public class When_command_handlers_are_resolved
	{
		static ICommandFactory Factory;
		static IEnumerable<ICommandMessageHandler> ConfigureHandlers;
		static IEnumerable<ICommandMessageHandler> FormatHandlers;
		static IEnumerable<ICommandMessageHandler> CreateUserHandlers;
		static IEnumerable<ICommandMessageHandler> ActivateUserHandlers;
		static IEnumerable<ICommandMessageHandler> DeleteUserHandlers;
		static IEnumerable<ICommandMessageHandler> DeactivateUserHandlers;

		Establish context = () =>
			{
				Container.BootstrapStructureMap();
				Factory = Container.GetInstance<ICommandFactory>();
			};

		Because of = () =>
			{
				ConfigureHandlers = Factory.GetCommands(new ConfigureEnvironmentMessage("", null));
				FormatHandlers = Factory.GetCommands(new FormatContentMessage(""));
				CreateUserHandlers = Factory.GetCommands(new CreateUserMessage(null));
				ActivateUserHandlers = Factory.GetCommands(new ActivateUserMessage(null, null));
				DeactivateUserHandlers = Factory.GetCommands(new DeactivateUserMessage(null));
				DeleteUserHandlers = Factory.GetCommands(new DeleteUserMessage(null));
			};

		Cleanup after = Container.Release;

		It should_be_able_to_resolve_configure_handlers =
			() => ConfigureHandlers.ShouldNotBeEmpty();

		It should_be_able_to_resolve_format_content_handlers =
			() => FormatHandlers.ShouldNotBeEmpty();

		It should_be_able_to_resolve_user_creation_handlers =
			() => CreateUserHandlers.ShouldNotBeEmpty();

		It should_be_able_to_resolve_user_activation_handlers =
			() => ActivateUserHandlers.ShouldNotBeEmpty();

		It should_be_able_to_resolve_user_deactivation_handlers =
			() => DeactivateUserHandlers.ShouldNotBeEmpty();

		It should_be_able_to_resolve_user_deletion_handlers =
			() => DeleteUserHandlers.ShouldNotBeEmpty();

		It should_not_execute_formatting_commands_sychronized =
			() => FormatHandlers.First().ShouldBeOfType<Command<FormatContentMessage>>();
	}

	[Subject(typeof(Container))]
	public class When_positioning_opinions_are_resolved
	{
		static IOpinionEvaluator OpinionEvaluator;

		Establish context = Container.BootstrapStructureMap;

		Because of = () => { OpinionEvaluator = Container.GetInstance<IOpinionEvaluator>(); };

		Cleanup after = Container.Release;

		It should_be_able_to_resolve_opinions =
			() => OpinionEvaluator.Opinions.ShouldNotBeEmpty();

		It should_evaluate_attendees_first =
			() => OpinionEvaluator.Opinions.First().ShouldBeOfType<OnAttendeeList>();

		It should_evaluate_waiting_list_second =
			() => OpinionEvaluator.Opinions.Skip(1).First().ShouldBeOfType<OnWaitingListIfNotSponsoring>();

		It should_evaluate_the_hard_limit_last =
			() => OpinionEvaluator.Opinions.Skip(2).First().ShouldBeOfType<OnWaitingListIfHardLimitIsReached>();
	}

	[Subject(typeof(Container))]
	public class When_synchronized_handlers_for_a_message_are_resolved
	{
		static IEnumerable<ICommandMessageHandler> Handlers;
		static ActivateUserMessage Message;
		static ICommandFactory Factory;
		static ISynchronizer Synchronizer;

		Establish context = () =>
			{
				Container.BootstrapStructureMap();

				Synchronizer = MockRepository.GenerateStub<ISynchronizer>();
				ObjectFactory.Inject(Synchronizer);

				Factory = Container.GetInstance<ICommandFactory>();

				Message = new ActivateUserMessage(null, null);
			};

		Because of = () => { Handlers = Factory.GetCommands(Message); };

		Cleanup after = Container.Release;

		It should_be_able_to_resolve_the_handlers =
			() => Handlers.ShouldNotBeEmpty();
	}

	[Subject(typeof(Container))]
	public class When_the_synchronized_handler_for_a_message_is_invoked
	{
		static ICommandMessageHandler Handler;
		static ICommandFactory Factory;
		static IContainer Container;
		static ISynchronizer Synchronizer;
		static ReturnValue Result;
		static Message Message;

		Establish context = () =>
			{
				Synchronizer = MockRepository.GenerateStub<ISynchronizer>();
				Synchronizer
					.Stub(x => x.Lock(null))
					.IgnoreArguments()
					.WhenCalled(x => ((Action) x.Arguments[0]).Invoke());

				Container = new StructureMap.Container(x =>
					{
						x.For<ISynchronizer>().Use(Synchronizer);

						x.Scan(scanner =>
							{
								scanner.AssemblyContainingType(typeof(Message));
								scanner.Convention<CommandConvention>();
							});
					});

				Factory = new CommandFactory(Container);
				Message = new Message();

				Handler = Factory.GetCommands(Message).First();
			};

		Because of = () => { Result = Handler.Execute(Message); };

		It should_invoke_the_synchronizer =
			() => Synchronizer.AssertWasCalled(x => x.Lock(Arg<Action>.Is.TypeOf));

		It should_return_the_result_from_the_handler =
			() => Result.Messages.ShouldContain("some message");
	}

	public class Message
	{
	}

	public class MessageHandler : Command<Message>, IAmSynchronized
	{
		protected override ReturnValue Execute(Message message)
		{
			return ReturnValue.Fail("some message");
		}
	}
}