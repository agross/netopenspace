using ScrewTurn.Wiki;

namespace NOS.Registration.Abstractions
{
	internal class SettingsAccessor : ISettingsAccessor
	{
		public string ContactEmail
		{
			get { return Settings.ContactEmail; }
		}

		public string SenderEmail
		{
			get { return Settings.SenderEmail; }
		}

		public string WikiTitle
		{
			get { return Settings.WikiTitle; }
		}

		public string MainUrl
		{
			get { return Settings.MainUrl; }
		}
	}
}