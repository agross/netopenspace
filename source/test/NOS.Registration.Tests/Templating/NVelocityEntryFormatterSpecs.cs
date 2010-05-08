using System;

using Machine.Specifications;

using NOS.Registration.Model;
using NOS.Registration.Templating;

namespace NOS.Registration.Tests.Templating
{
	public abstract class EntryFormatterSpecs
	{
		protected static string Entry;
		protected static IEntryFormatter Formatter;
		protected static User User;

		Establish context = () =>
			{
				Formatter = new NVelocityEntryFormatter();

				User = new User("user")
				       {
				       	Data =
				       		{
				       			Twitter = "twitter",
				       			Xing = "xing"
				       		}
				       };
			};
	}

	[Subject(typeof(NVelocityEntryFormatter))]
	public class When_a_simple_entry_with_escaped_newlines_in_the_template_is_formatted
		: EntryFormatterSpecs
	{
		Because of = () => { Entry = Formatter.FormatUserEntry(User, "some template\\n\\n"); };

		It should_convert_escaped_newline_characters_to_newline_characters =
			() => Entry.ShouldEndWith("\n\n");
	}

	[Subject(typeof(NVelocityEntryFormatter))]
	public class When_a_simple_entry_with_a_placeholder_is_formatted : EntryFormatterSpecs
	{
		Because of = () => { Entry = Formatter.FormatUserEntry(User, "$user.UserName"); };

		It should_fill_the_template_with_the_user_name =
			() => Entry.ShouldEqual("user");
	}

	[Subject(typeof(NVelocityEntryFormatter))]
	public class When_an_entry_with_conditional_placeholders_is_formatted : EntryFormatterSpecs
	{
		static string EntryTemplate;

		Establish context = () =>
			{
				EntryTemplate = "#if($user.Data.Twitter)" +
				                "$user.Data.Twitter was given" +
				                "#end" +
				                "#if($user.Data.Xing)" +
				                "$user.Data.Xing was given" +
				                "#end";

				User = new User("user")
				       {
				       	Data =
				       		{
				       			Twitter = "twitter",
				       			Xing = String.Empty
				       		}
				       };
			};

		Because of = () => { Entry = Formatter.FormatUserEntry(User, EntryTemplate); };

		It should_fill_the_template_with_satisfied_conditonals =
			() => Entry.ShouldContain("twitter was given");

		It should_turn_empty_strings_into_null_values =
			() => Entry.ShouldEqual("twitter was given");
	}

	[Subject(typeof(NVelocityEntryFormatter))]
	public class When_an_entry_with_conditional_decimal_placeholders_is_formatted : EntryFormatterSpecs
	{
		static string EntryTemplate;

		Establish context = () =>
			{
				EntryTemplate = "#if($user.Data.Sponsoring > 0)" +
				                "$user.Data.Sponsoring was given" +
				                "#end";

				User = new User("user")
				       {
				       	Data =
				       		{
				       			Sponsoring = 0.01m
				       		}
				       };
			};

		Because of = () => { Entry = Formatter.FormatUserEntry(User, EntryTemplate); };

		It should_fill_the_template_with_satisfied_conditonals =
			() => Entry.ShouldContain("was given");
	}

	[Subject(typeof(NVelocityEntryFormatter))]
	public class When_a_complex_entry_is_formatted : EntryFormatterSpecs
	{
		static string EntryTemplate;

		Establish context = () =>
			{
				EntryTemplate = @"# $user.Data.Name" +
				                "#if($user.Data.Email)" +
				                ", [$user.Data.Email|E-Mail]" +
				                "#end" +
				                "#if($user.Data.Blog)" +
				                ", [$user.Data.Blog|Blog]" +
				                "#end" +
				                "#if($user.Data.Twitter)" +
				                ", [http://twitter.com/$user.Data.Twitter/|Twitter]" +
				                "#end" +
				                "#if($user.Data.Xing)" +
				                ", [http://xing.com/$user.Data.Xing/|XING]" +
				                "#end" +
				                "#if($user.Data.Picture)" +
				                ", [$user.Data.Picture|Bild]" +
				                "#end\n\n";

				User = new User("user")
				       {
				       	Data =
				       		{
				       			Name = "Peter Pan",
				       			Blog = "blog",
				       			Email = "foo@example.com",
				       			Picture = "picture",
				       			Twitter = "twitter",
				       			Xing = "xing"
				       		}
				       };
			};

		Because of = () => { Entry = Formatter.FormatUserEntry(User, EntryTemplate); };

		It should_fill_the_template_with_just_the_satisfied_conditonals =
			() =>
			Entry.ShouldStartWith(
				"# Peter Pan, [foo@example.com|E-Mail], [blog|Blog], [http://twitter.com/twitter/|Twitter], [http://xing.com/xing/|XING], [picture|Bild]");

		It should_replace_double_newline_at_the_end_with_a_single_newline =
			() => Entry.ShouldEndWith("]\n");
	}
}