using System.Text;
using System.Xml;

using Machine.Specifications;

using NOS.Registration.Formatting.ListItems;
using NOS.Registration.Formatting.Lists;
using NOS.Registration.Model;

using Rhino.Mocks;

namespace NOS.Registration.Tests.Formatting.Lists
{
	public abstract class UnorderedListFormatterSpecs
	{
		protected static IListItemFormatter<User> ItemFormatter;

		protected static UnorderedListFormatter<User> CreateFormatter()
		{
			ItemFormatter = MockRepository.GenerateStub<IListItemFormatter<User>>();
			return new UnorderedListFormatter<User>(ItemFormatter);
		}
	}

	[Subject(typeof(UnorderedListFormatter<>))]
	public class When_an_unordered_list_is_formatted : UnorderedListFormatterSpecs
	{
		static UnorderedListFormatter<User> Formatter;
		static StringBuilder Formatted;
		static User[] Users;

		Establish context = () =>
			{
				Users = new[]
				        {
				        	new User("Alex"),
				        	new User("Torsten")
				        };

				Formatter = CreateFormatter();
			};

		Because of = () => { Formatted = Formatter.FormatList(Users); };

		It should_create_an_unordered_list =
			() => Formatted.ToString().ShouldContain("<ul>");

		It should_create_a_list_element_for_each_data_item =
			() => ItemFormatter.AssertWasCalled(x => x.FormatItem(Arg<User>.Is.NotNull), o => o.Repeat.Twice());
	}

	[Subject(typeof(UnorderedListFormatter<>))]
	public class When_an_empty_unordered_list_is_formatted : UnorderedListFormatterSpecs
	{
		static UnorderedListFormatter<User> Formatter;
		static StringBuilder Formatted;
		static XmlDocument Document;

		Establish context = () =>
			{
				Document = new XmlDocument();
				Document.LoadXml("<foo empty-value=\"the empty value\" />");

				Formatter = CreateFormatter();
			};

		Because of = () => { Formatted = Formatter.FormatEmptyList(Document); };

		It should_create_an_unordered_list_with_one_element_containing_the_empty_value =
			() => Formatted.ToString().ShouldEqual("<ul><li>the empty value</li></ul>");
	}

	[Subject(typeof(UnorderedListFormatter<>))]
	public class When_an_empty_unordered_list_is_formatted_and_the_markup_does_not_contain_an_empty_value
		: UnorderedListFormatterSpecs
	{
		static UnorderedListFormatter<User> Formatter;
		static StringBuilder Formatted;
		static XmlDocument Document;

		Establish context = () =>
			{
				Document = new XmlDocument();
				Document.LoadXml("<foo />");

				Formatter = CreateFormatter();
			};

		Because of = () => { Formatted = Formatter.FormatEmptyList(Document); };

		It should_return_nothing =
			() => Formatted.ToString().ShouldBeEmpty();
	}
}