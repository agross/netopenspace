using Machine.Specifications;

using Rhino.Mocks;

using ScrewTurn.Wiki.PluginFramework;

namespace NOS.TabMenu.Tests
{
	[Subject(typeof(TabMenu))]
	public class When_the_tab_menu_is_active
	{
		static TabMenu TabMenu;

		Because of = () => { TabMenu = new TabMenu(); };

		It should_render_on_each_request_regardless_of_the_cache =
			() => TabMenu.PerformPhase3.ShouldBeTrue();
	}

	[Subject(typeof(TabMenu))]
	public class When_the_tab_menu_is_formatted_for_a_non_content_page
	{
		static TabMenu TabMenu;

		Establish context = () =>
			{
				Host = MockRepository.GenerateStub<IHostV30>();
				Host
					.Stub(x => x.GetSettingValue(SettingName.RootNamespaceDefaultPage))
					.Return("the default page");

				TabMenu = new TabMenu();
				TabMenu.Init(Host, null);
			};

		Because of = () => TabMenu.Format("raw",
		                                  new ContextInformation(false,
		                                                         false,
		                                                         FormattingContext.PageContent,
		                                                         null,
		                                                         "en-US",
		                                                         null,
		                                                         null,
		                                                         new string[] { }),
		                                  FormattingPhase.Phase3);

		It should_render_on_each_request_regardless_of_the_cache =
			() => TabMenu.PerformPhase3.ShouldBeTrue();

		static IHostV30 Host;
	}
}