namespace NOS.Registration.Abstractions
{
	public interface ISettingsAccessor
	{
		string ContactEmail
		{
			get;
		}

		string SenderEmail
		{
			get;
		}

		string WikiTitle
		{
			get;
		}

		string MainUrl
		{
			get;
		}
	}
}