using System;
using System.Collections.Generic;
using System.Linq;

using Machine.Specifications;

using NOS.Registration.Abstractions;

namespace NOS.Registration.Tests.Abstractions
{
	[Subject(typeof(DefaultPluginConfiguration))]
	public class When_the_plugin_configuration_is_created
	{
		static DefaultPluginConfiguration Configuration;

		Because of = () => { Configuration = new DefaultPluginConfiguration(); };

		It should_set_the_default_entry_template =
			() => Configuration.EntryTemplate.ShouldEqual("$user.UserName");
	}

	[Subject(typeof(DefaultPluginConfiguration))]
	public class When_the_plugin_configuration_is_parsed
	{
		static DefaultPluginConfiguration Configuration;
		static string ConfigString;
		static IEnumerable<string> Errors;

		Establish context = () =>
			{
				Configuration = new DefaultPluginConfiguration();

				ConfigString = String.Join("\n",
				                           new[]
				                           {
				                           	"EntryTemplate=EntryTemplate",
				                           	"MaximumAttendees=10",
				                           	"HardLimit=15"
				                           });
			};

		Because of = () => { Errors = Configuration.Parse(ConfigString); };

		It should_have_no_errors =
			() => Errors.ShouldBeEmpty();

		It should_set_the_entry_template =
			() => Configuration.EntryTemplate.ShouldEqual("EntryTemplate");

		It should_set_the_maximum_attendee_number =
			() => Configuration.MaximumAttendees.ShouldEqual(10);

		It should_set_the_hard_limit =
			() => Configuration.HardLimit.ShouldEqual(15);
	}

	[Subject(typeof(DefaultPluginConfiguration))]
	public class When_the_plugin_configuration_is_parsed_with_invalid_configuration_data
	{
		static DefaultPluginConfiguration Configuration;
		static string ConfigString;
		static IEnumerable<string> Errors;

		Establish context = () =>
			{
				Configuration = new DefaultPluginConfiguration();

				ConfigString = String.Join("\n",
				                           new[]
				                           {
				                           	"foo=bar",
				                           	"MaximumAttendees=not an int",
				                           	"HardLimit=not an int"
				                           });
			};

		Because of = () => { Errors = Configuration.Parse(ConfigString); };

		It should_report_unknown_entries =
			() => Errors.FirstOrDefault(x => x.Contains("foo")).ShouldNotBeNull();

		It should_report_the_invalid_maximum_attendee_count =
			() => Errors.FirstOrDefault(x => x.StartsWith("The maximum attendee count is missing")).ShouldNotBeNull();

		It should_report_the_invalid_hard_limit =
			() => Errors.FirstOrDefault(x => x.Contains("Key='hardlimit' Value='not an int'")).ShouldNotBeNull();
	}

	[Subject(typeof(DefaultPluginConfiguration))]
	public class When_the_plugin_configuration_is_parsed_without_required_options_being_configured
	{
		static IEnumerable<string> Errors;
		static DefaultPluginConfiguration Configuration;

		Establish context = () => { Configuration = new DefaultPluginConfiguration(); };

		Because of = () => { Errors = Configuration.Parse(String.Empty); };

		It should_report_the_missing_maximum_attendee_number =
			() => Errors.FirstOrDefault(x => x.StartsWith("The maximum attendee count is missing")).ShouldNotBeNull();
	}

	[Subject(typeof(DefaultPluginConfiguration))]
	public class When_the_plugin_configuration_is_parsed_with_a_hard_limit_lower_than_the_maximum_attendee_number
	{
		static DefaultPluginConfiguration Configuration;
		static string ConfigString;
		static IEnumerable<string> Errors;

		Establish context = () =>
			{
				Configuration = new DefaultPluginConfiguration();

				ConfigString = String.Join("\n",
				                           new[]
				                           {
				                           	"MaximumAttendees=10",
				                           	"HardLimit=9"
				                           });
			};

		Because of = () => { Errors = Configuration.Parse(ConfigString); };

		It should_report_the_that_the_attendee_count_must_be_less_than_or_equal_to_the_hard_limit =
			() =>
			Errors.FirstOrDefault(x => x.StartsWith("The maximum attendee count must be less than or equal to the hard limit"))
				.ShouldNotBeNull();
	}
}