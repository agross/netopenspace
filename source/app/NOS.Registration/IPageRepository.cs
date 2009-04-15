using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration
{
	public interface IPageRepository
	{
		void Save(PageInfo page, string title, string username, string comment, string content);
		PageInfo FindPage(string pageName);
	}
}