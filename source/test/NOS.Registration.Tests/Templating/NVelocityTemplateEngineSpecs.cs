using System;

using Machine.Specifications;

using NOS.Registration.Model;
using NOS.Registration.Templating;

namespace NOS.Registration.Tests.Templating
{
	public abstract class NVelocityTemplateEngineSpecs
	{
		protected static string Entry;
		protected static ITemplateEngine Formatter;
		protected static User User;

		Establish context = () =>
			{
				Formatter = new NVelocityTemplateEngine();

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

	[Subject(typeof(NVelocityTemplateEngine))]
	public class When_a_simple_entry_with_a_placeholder_is_formatted : NVelocityTemplateEngineSpecs
	{
		Because of = () => { Entry = Formatter.Format(User, "$item.UserName"); };

		It should_fill_the_template_with_the_user_name =
			() => Entry.ShouldEqual("user");
	}

	[Subject(typeof(NVelocityTemplateEngine))]
	public class When_an_entry_with_conditional_placeholders_is_formatted : NVelocityTemplateEngineSpecs
	{
		static string EntryTemplate;

		Establish context = () =>
			{
				EntryTemplate = "#if($item.Data.Twitter)" +
				                "$item.Data.Twitter was given" +
				                "#end" +
				                "#if($item.Data.Xing)" +
				                "$item.Data.Xing was given" +
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

		Because of = () => { Entry = Formatter.Format(User, EntryTemplate); };

		It should_fill_the_template_with_satisfied_conditonals =
			() => Entry.ShouldContain("twitter was given");

		It should_turn_empty_strings_into_null_values =
			() => Entry.ShouldEqual("twitter was given");
	}

	[Subject(typeof(NVelocityTemplateEngine))]
	public class When_an_entry_with_conditional_decimal_placeholders_is_formatted : NVelocityTemplateEngineSpecs
	{
		static string EntryTemplate;

		Establish context = () =>
			{
				EntryTemplate = "#if($item.Data.Sponsoring > 0)" +
				                "$item.Data.Sponsoring was given" +
				                "#end";

				User = new User("user")
				       {
				       	Data =
				       		{
				       			Sponsoring = 0.01m
				       		}
				       };
			};

		Because of = () => { Entry = Formatter.Format(User, EntryTemplate); };

		It should_fill_the_template_with_satisfied_conditonals =
			() => Entry.ShouldContain("was given");
	}

	[Subject(typeof(NVelocityTemplateEngine))]
	public class When_a_complex_entry_is_formatted : NVelocityTemplateEngineSpecs
	{
		static string EntryTemplate;

		Establish context = () =>
			{
				EntryTemplate = @"# $item.Data.Name" +
				                "#if($item.Data.Email)" +
				                ", [$item.Data.Email|E-Mail]" +
				                "#end" +
				                "#if($item.Data.Blog)" +
				                ", [$item.Data.Blog|Blog]" +
				                "#end" +
				                "#if($item.Data.Twitter)" +
				                ", [http://twitter.com/$item.Data.Twitter/|Twitter]" +
				                "#end" +
				                "#if($item.Data.Xing)" +
				                ", [http://xing.com/$item.Data.Xing/|XING]" +
				                "#end" +
				                "#if($item.Data.Picture)" +
				                ", [$item.Data.Picture|Bild]" +
				                "#end";

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

		Because of = () => { Entry = Formatter.Format(User, EntryTemplate); };

		It should_fill_the_template_with_just_the_satisfied_conditonals =
			() => Entry.ShouldEqual("# Peter Pan, [foo@example.com|E-Mail], [blog|Blog], " +
			                        "[http://twitter.com/twitter/|Twitter], [http://xing.com/xing/|XING], "+
									"[picture|Bild]");
	}
}