using System;

using ScrewTurn.Wiki;
using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration
{
	internal class PageRepository : IPageRepository
	{
		readonly Pages _pages;

		public PageRepository()
		{
			_pages = new Pages();
		}

		#region IPageRepository Members
		public void Save(PageInfo page, string title, string userName, string comment, string content)
		{
			_pages.ModifyPage(page, title, userName, DateTime.Now, comment, content, true);
		}

		public PageInfo FindPage(string pageName)
		{
			return _pages.FindPage(pageName);
		}
		#endregion
	}
}