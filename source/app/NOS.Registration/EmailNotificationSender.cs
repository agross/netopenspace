using System;

using ScrewTurn.Wiki;
using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration
{
	internal class EmailNotificationSender : INotificationSender
	{
		IHost _host;

		#region INotificationSender Members
		public void SendMessage(string userName, string recipient, string subject, bool failed)
		{
			string message = LoadTemplate(userName, failed);

			SendEmail(recipient, subject, message);
		}

		public void Configure(IHost host)
		{
			_host = host;
		}
		#endregion

		string LoadTemplate(string userName, bool failed)
		{
			string file = "AutoRegistrationSuccessfulMessage.cs";

			if (failed)
			{
				file = "AutoRegistrationFailedMessage.cs";
			}

			var template = _host.ReadFile(Settings.PublicDirectory + file);

			return template
				.Replace("##WIKITITLE##", Settings.WikiTitle)
				.Replace("##USERNAME##", userName)
				.Replace("##WIKIURL##", Settings.MainUrl);
		}

		void SendEmail(string userEmail, string subject, string message)
		{
			_host.SendEmail(userEmail,
			                Settings.SenderEmail,
			                String.Format("{0} - {1}", subject, Settings.WikiTitle),
			                message,
			                false);
		}
	}
}