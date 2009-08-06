using System.Collections.Generic;

namespace NOS.Registration
{
	public interface IPluginConfiguration
	{
		string PageName
		{
			get;
		}

		string ListStartPattern
		{
			get;
		}

		string ListEndPattern
		{
			get;
		}

		string WaitingListEndPattern
		{
			get;
		}

		string EntryPattern
		{
			get;
		}

		string EntryTemplate
		{
			get;
		}

		string Comment
		{
			get;
		}

		int MaximumAttendees
		{
			get;
		}

		int HardLimit
		{
			get;
		}

		IEnumerable<string> Parse(string configString, IPageRepository pageRepository);
	}
}