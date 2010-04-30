using Machine.Specifications;

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

		It should_have_a_valid_configuration =
			ObjectFactory.AssertConfigurationIsValid;

		It should_be_able_to_create_an_instance_of_the_auto_registration_plugin =
			() => Plugin.ShouldNotBeNull();
	}
}