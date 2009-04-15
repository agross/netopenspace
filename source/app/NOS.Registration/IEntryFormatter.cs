namespace NOS.Registration
{
	public interface IEntryFormatter
	{
		string EntryTemplate
		{
			get;
			set;
		}

		string FormatUserEntry(User user);
	}
}