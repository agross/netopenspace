using System.Collections.Generic;
using System.Linq;

using Machine.Specifications;

using NOS.Registration.Commands;
using NOS.Registration.Commands.Infrastructure;
using NOS.Registration.EntryPositioning;
using NOS.Registration.EntryPositioning.Opinions;

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
}