using NOS.Registration.Model;

namespace NOS.Registration
{
	public interface IPageFormatter
	{
		string AddEntry(string content, string entry, User user, IPluginConfiguration configuration);
	}
}