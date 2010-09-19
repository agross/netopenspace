using System;

using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration
{
	internal class EmailNotificationSender : INotificationSender
	{
		IHostV30 _host;
		ISettings _settings;

		public void SendMessage(string recipient, string subject, string message)
		{
			_host.SendEmail(recipient,
			                _settings.SenderEmail,
			                String.Format("{0} - {1}", _settings.WikiTitle, subject),
			                message,
			                false);
		}

		public void Configure(IHostV30 host, ISettings settings)
		{
			_host = host;
			_settings = settings;
		}
	}
}