namespace NOS.Registration
{
	public interface ISettings
	{
		string ContactEmail
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

		string SenderEmail
		{
			get;
		}

		string DataDirectory
		{
			get;
		}
	}
}