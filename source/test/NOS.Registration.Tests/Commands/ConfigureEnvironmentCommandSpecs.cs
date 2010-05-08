using Machine.Specifications;

using NOS.Registration.Commands;

using Rhino.Mocks;

using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration.Tests.Commands
{
	public abstract class ConfigureEnvironmentCommandSpecs
	{
		protected static IHostV30 Host;
		protected static INotificationSender NotificationSender;
		protected static IPluginConfiguration PluginConfiguration;

		protected static ConfigureEnvironmentCommand CreateCommand()
		{
			PluginConfiguration = MockRepository.GenerateStub<IPluginConfiguration>();
			NotificationSender = MockRepository.GenerateStub<INotificationSender>();
			Host = MockRepository.GenerateStub<IHostV30>();

			return new ConfigureEnvironmentCommand(PluginConfiguration, NotificationSender);
		}
	}

	[Subject(typeof(ConfigureEnvironmentCommand))]
	public class When_the_environment_is_configured : ConfigureEnvironmentCommandSpecs
	{
		static ConfigureEnvironmentCommand Command;
		static ReturnValue Result;

		Establish context = () => { Command = CreateCommand(); };

		Because of = () => { Result = Command.Execute(new ConfigureEnvironmentMessage("config string", Host)); };

		It should_parse_the_plugin_configuration =
			() => PluginConfiguration.AssertWasCalled(x => x.Parse("config string"));

		It should_configure_the_notification_sender =
			() => NotificationSender.AssertWasCalled(x => x.Configure(Host));

		It should_return_the_plugin_configuration =
			() => Result.Value.ShouldEqual(PluginConfiguration);

		It should_succeed =
			() => Result.Messages.ShouldBeEmpty();
	}

	[Subject(typeof(ConfigureEnvironmentCommand))]
	public class When_the_environment_configuration_fails : ConfigureEnvironmentCommandSpecs
	{
		static ConfigureEnvironmentCommand Command;
		static ReturnValue Result;

		Establish context = () =>
			{
				Command = CreateCommand();

				PluginConfiguration
					.Stub(x => x.Parse("config string"))
					.Return(new[] { "error 1", "error 2" });
			};

		Because of = () => { Result = Command.Execute(new ConfigureEnvironmentMessage("config string", Host)); };

		It should_parse_the_plugin_configuration =
			() => PluginConfiguration.AssertWasCalled(x => x.Parse("config string"));

		It should_not_configure_the_notification_sender =
			() => NotificationSender.AssertWasNotCalled(x => x.Configure(Host));

		It should_fail =
			() => Result.Messages.ShouldNotBeEmpty();

		It should_report_errors_from_the_configuration =
			() => Result.Messages.ShouldContainOnly("error 1", "error 2");
	}
}