namespace NOS.Registration.Abstractions
{
	public interface IWikiSettings
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