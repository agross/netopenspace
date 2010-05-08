using System.Collections.Generic;

using Machine.Specifications;

using NOS.Registration.Commands;
using NOS.Registration.Commands.Infrastructure;

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
		static IEnumerable<ICommandMessageHandler> ActivateUserHandlers;

		Establish context = () =>
			{
				Container.BootstrapStructureMap();
				Factory = Container.GetInstance<ICommandFactory>();
			};

		Because of = () =>
			{
				ConfigureHandlers = Factory.GetCommands(new ConfigureEnvironmentMessage("", null));
				FormatHandlers = Factory.GetCommands(new FormatContentMessage(""));
				ActivateUserHandlers = Factory.GetCommands(new ActivateUserMessage(null));
			};

		Cleanup after = Container.Release;

		It should_be_able_to_resolve_configure_handlers =
			() => ConfigureHandlers.ShouldNotBeEmpty();

		It should_be_able_to_resolve_format_content_handlers =
			() => FormatHandlers.ShouldNotBeEmpty();

		It should_be_able_to_resolve_user_activation_handlers =
			() => ActivateUserHandlers.ShouldNotBeEmpty();
	}
}