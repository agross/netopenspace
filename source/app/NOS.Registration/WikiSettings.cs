using System;

using ScrewTurn.Wiki;

namespace NOS.Registration
{
	internal class WikiSettings : ISettings
	{
		public string ContactEmail
		{
			get { return Settings.ContactEmail; }
		}

		public string WikiTitle
		{
			get { return Settings.WikiTitle; }
		}

		public string MainUrl
		{
			get { return Settings.MainUrl; }
		}

		public string SenderEmail
		{
			get { return Settings.SenderEmail; }
		}

		public string DataDirectory
		{
			get { return Settings.PublicDirectory; }
		}
	}
}