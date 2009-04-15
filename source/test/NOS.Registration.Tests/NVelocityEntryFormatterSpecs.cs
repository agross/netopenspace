using System;

using Machine.Specifications;

namespace NOS.Registration.Tests
{
	[Subject(typeof(NVelocityEntryFormatter))]
	public class When_the_entry_formatters_template_is_initialized
	{
		static IEntryFormatter Formatter;

		Establish context = () => { Formatter = new NVelocityEntryFormatter(); };

		Because of = () => { Formatter.EntryTemplate = "some template\\n\\n"; };

		It should_convert_escaped_newline_characters_to_newline_characters  = () => Formatter.EntryTemplate.ShouldEndWith("\n\n");
	}

	public class With_entry_formatter
	{
		protected static string Entry;
		protected static IEntryFormatter Formatter;
		protected static User User;

		Establish context = () =>
			{
				Formatter = new NVelocityEntryFormatter
				            {
				            	EntryTemplate = "$user.UserName"
				            };

				User = new User("user")
				       {
				       	Data =
				       		{
				       			Twitter = "twitter",
				       			Xing = "xing"
				       		}
				       };
			};

		Because of = () => { Entry = Formatter.FormatUserEntry(User); };
	}

	[Subject(typeof(NVelocityEntryFormatter))]
	public class When_a_simple_entry_is_formatted : With_entry_formatter
	{
		It should_fill_the_template_with_the_user_name = () => Entry.ShouldEqual("user");
	}

	[Subject(typeof(NVelocityEntryFormatter))]
	public class When_an_entry_with_conditional_elements_is_formatted : With_entry_formatter
	{
		Establish context = () =>
			{
				Formatter.EntryTemplate = "#if($user.Data.Twitter)" +
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

		It should_fill_the_template_with_satisfied_conditonals = () => Entry.ShouldContain("twitter was given");
		It should_turn_empty_strings_into_null_values = () => Entry.ShouldEqual("twitter was given");
	}

	[Subject(typeof(NVelocityEntryFormatter))]
	public class When_a_complex_entry_is_formatted : With_entry_formatter
	{
		Establish context = () =>
			{
				Formatter.EntryTemplate = @"# $user.Data.Name" +
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

		It should_fill_the_template_with_just_the_satisfied_conditonals =
			() =>
			Entry.ShouldStartWith(
				"# Peter Pan, [foo@example.com|E-Mail], [blog|Blog], [http://twitter.com/twitter/|Twitter], [http://xing.com/xing/|XING], [picture|Bild]");

		It should_replace_double_newline_at_the_end_with_a_single_newline =
			() => Entry.ShouldEndWith("]\n");
	}
}