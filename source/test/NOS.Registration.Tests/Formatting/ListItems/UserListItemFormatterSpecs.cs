using Machine.Specifications;

using NOS.Registration.Abstractions;
using NOS.Registration.Formatting.ListItems;
using NOS.Registration.Model;
using NOS.Registration.Templating;

using Rhino.Mocks;

namespace NOS.Registration.Tests.Formatting.ListItems
{
	[Subject(typeof(UserListItemFormatter))]
	public class When_a_user_list_item_is_formatted
	{
		static UserListItemFormatter Formatter;
		static User User;
		static string Formatted;

		Establish context = () =>
			{
				User = new User("Alex");

				var configuration = MockRepository.GenerateStub<IPluginConfiguration>();
				configuration
					.Stub(x => x.EntryTemplate)
					.Return("template");

				var entryFormatter = MockRepository.GenerateStub<IEntryFormatter>();
				entryFormatter
					.Stub(x => x.FormatUserEntry(User, "template"))
					.Return("formatted template");

				Formatter = new UserListItemFormatter(entryFormatter,
				                                      configuration);
			};

		Because of = () => { Formatted = Formatter.FormatItem(User); };

		It should_format_the_item =
			() => Formatted.ShouldNotBeEmpty();

		It should_format_the_item_according_to_the_template_from_the_plugin_configuration =
			() => Formatted.ShouldEqual("formatted template");
	}
}