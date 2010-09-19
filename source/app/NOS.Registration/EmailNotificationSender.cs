using System;

using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration
{
	internal class EmailNotificationSender : INotificationSender
	{
		IHostV30 _host;
		IFileReader _fileReader;
		ISettings _settings;

		public void SendMessage(string userName, string recipient, string subject, bool failed)
		{
			string message = LoadTemplate(userName, failed);

			SendEmail(recipient, subject, message);
		}

		public void Configure(IHostV30 host, IFileReader fileReader, ISettings settings)
		{
			_host = host;
			_fileReader = fileReader;
			_settings = settings;
		}

		string LoadTemplate(string userName, bool failed)
		{
			string file = typeof(AutoRegistrationPlugin).FullName + ".SuccessMessage";

			if (failed)
			{
				file = typeof(AutoRegistrationPlugin).FullName + ".FailureMessage";
			}

			var template = _fileReader.Read(file);

			return template
				.Replace("##WIKITITLE##", _settings.WikiTitle)
				.Replace("##USERNAME##", userName)
				.Replace("##WIKIURL##", _settings.MainUrl);
		}

		void SendEmail(string userEmail, string subject, string message)
		{
			_host.SendEmail(userEmail,
							_settings.SenderEmail,
							String.Format("{0} - {1}", _settings.WikiTitle, subject),
			                message,
			                false);
		}
	}
}