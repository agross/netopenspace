namespace NOS.Registration
{
	public interface IPageFormatter
	{
		string ListStartPattern
		{
			get;
			set;
		}

		string ListEndPattern
		{
			get;
			set;
		}

		string WaitingListEndPattern
		{
			get;
			set;
		}

		int MaximumAttendees
		{
			get;
			set;
		}

		string EntryPattern
		{
			get;
			set;
		}

		string AddEntry(string content, string entry);
	}
}