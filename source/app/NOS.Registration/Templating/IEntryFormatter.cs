using NOS.Registration.Model;

namespace NOS.Registration.Templating
{
	public interface IEntryFormatter
	{
		string FormatUserEntry(User user, string entryTemplate);
	}
}