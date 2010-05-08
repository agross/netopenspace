using System;
using System.Linq;

using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration.Commands
{
	public class ConfigureEnvironmentCommand : Command<ConfigureEnvironmentMessage>
	{
		readonly IPluginConfiguration _configuration;
		readonly INotificationSender _notificationSender;

		public ConfigureEnvironmentCommand(IPluginConfiguration configuration, INotificationSender notificationSender)
		{
			_configuration = configuration;
			_notificationSender = notificationSender;
		}

		protected override ReturnValue Execute(ConfigureEnvironmentMessage message)
		{
			var errors = _configuration.Parse(message.ConfigurationString);
			if (errors != null && errors.Any())
			{
				return ReturnValue.Fail(errors);
			}

			_notificationSender.Configure(message.Host);

			return ReturnValue.Success().SetValue(_configuration);
		}
	}

	public class ConfigureEnvironmentMessage
	{
		public ConfigureEnvironmentMessage(string configurationString, IHostV30 host)
		{
			Host = host;
			ConfigurationString = configurationString ?? String.Empty;
		}

		public string ConfigurationString
		{
			get;
			private set;
		}

		public IHostV30 Host
		{
			get;
			private set;
		}
	}
}