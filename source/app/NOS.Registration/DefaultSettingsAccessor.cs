using ScrewTurn.Wiki;

namespace NOS.Registration
{
	class DefaultSettingsAccessor : ISettingsAccessor
	{
		public string ContactEmail
		{
			get { return Settings.ContactEmail; }
		}
	}
}