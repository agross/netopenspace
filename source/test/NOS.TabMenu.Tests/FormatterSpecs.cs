using Machine.Specifications;

using Rhino.Mocks;

namespace NOS.TabMenu.Tests
{
	public class FormatterSpecs
	{
		protected static Formatter CreateFormatter()
		{
			return new Formatter(MockRepository.GenerateStub<ILogger>());
		}
	}

	[Subject(typeof(Formatter))]
	public class When_no_markup_is_formatted : FormatterSpecs
	{
		static Formatter Formatter;
		static string Html;
		static string Markup;

		Establish context = () =>
			{
				Formatter = CreateFormatter();
				Markup = "";
			};

		Because of = () => { Html = Formatter.FormatMenu(Markup, null); };

		It should_return_no_menu =
			() => Html.ShouldBeEmpty();
	}

	[Subject(typeof(Formatter))]
	public class When_an_empty_menu_is_formatted : FormatterSpecs
	{
		static Formatter Formatter;
		static string Html;
		static string Markup;

		Establish context = () =>
			{
				Formatter = CreateFormatter();
				Markup = "<tab-menu item-selector=\"//ul/li\" selected-attr=\"class\" selected-value=\"selected\"></tab-menu>";
			};

		Because of = () => { Html = Formatter.FormatMenu(Markup, null); };

		It should_return_no_menu =
			() => Html.ShouldBeEmpty();
	}

	[Subject(typeof(Formatter))]
	public class When_a_menu_with_an_unselected_item_is_formatted : FormatterSpecs
	{
		static Formatter Formatter;
		static string Html;
		static string Markup;
		static string Menu;

		Establish context = () =>
			{
				Formatter = CreateFormatter();

				Menu = "<ul>" +
				       "	<li>" +
				       "		<a href='Selected.ashx'>Selected</a>" +
				       "	</li>" +
				       "</ul>";

				Markup = "<tab-menu item-selector=\"//ul/li\" selected-attr=\"class\" selected-value=\"selected\">" +
				         Menu +
				         "</tab-menu>";
			};

		Because of = () => { Html = Formatter.FormatMenu(Markup, "SomeOtherPage.ashx"); };

		It should_return_the_menu_without_selection =
			() => Html.ShouldContain("<li>");
	}

	[Subject(typeof(Formatter))]
	public class When_a_menu_with_a_selected_item_is_formatted : FormatterSpecs
	{
		static Formatter Formatter;
		static string Html;
		static string Markup;
		static string Menu;

		Establish context = () =>
			{
				Formatter = CreateFormatter();

				Menu = "<ul>" +
				       "	<li>" +
					   "		<a href='Selected.ashx'>Selected</a>" +
				       "	</li>" +
				       "</ul>";

				Markup = "<tab-menu item-selector=\"//ul/li\" selected-attr=\"class\" selected-value=\"selected\">" +
				         Menu +
				         "</tab-menu>";
			};

		Because of = () => { Html = Formatter.FormatMenu(Markup, "Selected.ashx"); };

		It should_return_the_menu_with_the_selected_item =
			() => Html.ShouldContain("<li class=\"selected\">");
	}
	
	[Subject(typeof(Formatter))]
	public class When_a_menu_with_a_selected_item_is_formatted_that_already_has_the_selected_attribute_value : FormatterSpecs
	{
		static Formatter Formatter;
		static string Html;
		static string Markup;
		static string Menu;

		Establish context = () =>
			{
				Formatter = CreateFormatter();

				Menu = "<ul>" +
				       "	<li class=\"foo\">" +
					   "		<a href='Selected.ashx'>Selected</a>" +
				       "	</li>" +
				       "</ul>";

				Markup = "<tab-menu item-selector=\"//ul/li\" selected-attr=\"class\" selected-value=\"selected\">" +
				         Menu +
				         "</tab-menu>";
			};

		Because of = () => { Html = Formatter.FormatMenu(Markup, "Selected.ashx"); };

		It should_add_the_selected_value_attribute_to_the_existing_attribute =
			() => Html.ShouldContain("<li class=\"foo selected\">");
	}
	
	[Subject(typeof(Formatter))]
	public class When_a_menu_with_a_nested_selected_item_is_formatted : FormatterSpecs
	{
		static Formatter Formatter;
		static string Html;
		static string Markup;
		static string Menu;

		Establish context = () =>
			{
				Formatter = CreateFormatter();

				Menu = "<ul>" +
				       "	<li>" +
					   "		<a href='Selected.ashx'>Outer</a>" +
				       "		<ul>"+
					   "			<li>" +
					   "				<a href='Selected.ashx'>Inner</a>" +
					   "			</li>" +
					   "		</ul>" +
				       "	</li>" +
				       "</ul>";

				Markup = "<tab-menu item-selector=\"//ul/li\" selected-attr=\"class\" selected-value=\"selected\">" +
				         Menu +
				         "</tab-menu>";
			};

		Because of = () => { Html = Formatter.FormatMenu(Markup, "Selected.ashx"); };

		It should_return_the_menu_with_the_outer_selected_item =
			() => Html.ShouldContain("<li class=\"selected\"><a href=\"Selected.ashx\">Outer</a>");
		
		It should_return_the_menu_with_the_inner_selected_item =
			() => Html.ShouldContain("<li class=\"selected\"><a href=\"Selected.ashx\">Inner</a>");
	}
}