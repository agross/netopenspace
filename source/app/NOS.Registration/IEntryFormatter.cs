namespace NOS.Registration
{
	public interface IEntryFormatter
	{
		string FormatUserEntry(User user, ISettings settings, string template);
	}
}