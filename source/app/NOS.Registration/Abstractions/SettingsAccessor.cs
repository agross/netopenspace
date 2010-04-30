using ScrewTurn.Wiki;

namespace NOS.Registration.Abstractions
{
	class SettingsAccessor : ISettingsAccessor
	{
		public string ContactEmail
		{
			get { return Settings.ContactEmail; }
		}
	}
}