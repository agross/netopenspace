using System;

using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration.Abstractions
{
	public class EmailNotificationSender : INotificationSender
	{
		readonly IFileReader _fileReader;
		readonly ISettingsAccessor _settingsAccessor;
		IHostV30 _host;

		public EmailNotificationSender(IFileReader fileReader, ISettingsAccessor settingsAccessor)
		{
			_fileReader = fileReader;
			_settingsAccessor = settingsAccessor;
		}

		public void SendMessage(string userName, string recipient, string subject, string templateFileName)
		{
			string message = LoadTemplate(userName, templateFileName);

			SendEmail(recipient, subject, message);
		}

		public void Configure(IHostV30 host)
		{
			_host = host;
		}

		string LoadTemplate(string userName, string templateFileName)
		{
			var template = _fileReader.Read(templateFileName);

			return template
				.Replace("##WIKITITLE##", _settingsAccessor.WikiTitle)
				.Replace("##USERNAME##", userName)
				.Replace("##WIKIURL##", _settingsAccessor.MainUrl);
		}

		void SendEmail(string userEmail, string subject, string message)
		{
			_host.SendEmail(userEmail,
			                _settingsAccessor.SenderEmail,
			                String.Format("{0} - {1}", subject, _settingsAccessor.WikiTitle),
			                message,
			                false);
		}
	}
}