using System.Collections.Generic;

namespace NOS.Registration
{
	public interface IPluginConfiguration
	{
		string EntryTemplate
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

		IEnumerable<string> Parse(string configString);
	}
}