using System;

using ScrewTurn.Wiki;
using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration.Abstractions
{
	internal class EmailNotificationSender : INotificationSender
	{
		readonly IFileReader _fileReader;
		IHostV30 _host;

		public EmailNotificationSender(IFileReader fileReader)
		{
			_fileReader = fileReader;
		}

		public void SendMessage(string userName, string recipient, string subject, bool failed)
		{
			string message = LoadTemplate(userName, failed);

			SendEmail(recipient, subject, message);
		}

		public void Configure(IHostV30 host)
		{
			_host = host;
		}

		string LoadTemplate(string userName, bool failed)
		{
			string file = "AutoRegistrationSuccessfulMessage.cs";

			if (failed)
			{
				file = "AutoRegistrationFailedMessage.cs";
			}

			var template = _fileReader.Read(Settings.PublicDirectory + file);

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