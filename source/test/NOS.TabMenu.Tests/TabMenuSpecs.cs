using Machine.Specifications;

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
}