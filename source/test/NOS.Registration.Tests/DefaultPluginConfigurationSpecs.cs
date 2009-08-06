using System;
using System.Collections.Generic;
using System.Linq;

using Machine.Specifications;

using Rhino.Mocks;

using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration.Tests
{
	[Subject(typeof(DefaultPluginConfiguration))]
	public class When_the_plugin_configuration_is_created
	{
		static DefaultPluginConfiguration Configuration;

		Because of = () => { Configuration = new DefaultPluginConfiguration(); };

		It should_set_the_default_comment = () => Configuration.Comment.ShouldEqual("AutoRegistration");
		It should_set_the_default_entry_template = () => Configuration.EntryTemplate.ShouldEqual("# $user.UserName");
	}

	[Subject(typeof(DefaultPluginConfiguration))]
	public class When_the_plugin_configuration_is_parsed
	{
		static DefaultPluginConfiguration Configuration;
		static string ConfigString;
		static IEnumerable<string> Errors;
		static IPageRepository PageRepository;

		Establish context = () =>
			{
				Configuration = new DefaultPluginConfiguration();

				ConfigString = String.Join("\n",
				                           new[]
				                           {
				                           	"PageName=page",
				                           	"EntryTemplate=EntryTemplate",
				                           	"EntryPattern=Entry",
				                           	"ListStartPattern=ListStart",
				                           	"ListEndPattern=ListEnd",
				                           	"WaitingListEndPattern=WaitingListEnd",
				                           	"MaximumAttendees=10",
				                           	"HardLimit=15"
				                           });

				PageRepository = MockRepository.GenerateStub<IPageRepository>();
				PageRepository
					.Stub(x => x.FindPage("page"))
					.Return(new PageInfo("page", null, PageStatus.Normal, DateTime.Now));
			};

		Because of = () => { Errors = Configuration.Parse(ConfigString, PageRepository); };

		It should_check_if_the_configured_page_exists = () => { PageRepository.AssertWasCalled(x => x.FindPage("page")); };

		It should_have_no_errors = () => Errors.ShouldBeEmpty();
		It should_set_the_page_name = () => Configuration.PageName.ShouldEqual("page");
		It should_set_the_entry_template = () => Configuration.EntryTemplate.ShouldEqual("EntryTemplate");
		It should_set_the_entry_pattern = () => Configuration.EntryPattern.ShouldEqual("Entry");
		It should_set_the_list_start_pattern = () => Configuration.ListStartPattern.ShouldEqual("ListStart");
		It should_set_the_list_end_pattern = () => Configuration.ListEndPattern.ShouldEqual("ListEnd");
		It should_set_the_waiting_list_end_pattern = () => Configuration.WaitingListEndPattern.ShouldEqual("WaitingListEnd");
		It should_set_the_maximum_attendee_number = () => Configuration.MaximumAttendees.ShouldEqual(10);
		It should_set_the_hard_limit = () => Configuration.HardLimit.ShouldEqual(15);
	}

	[Subject(typeof(DefaultPluginConfiguration))]
	public class When_the_plugin_configuration_is_parsed_with_invalid_configuration_data
	{
		static DefaultPluginConfiguration Configuration;
		static string ConfigString;
		static IEnumerable<string> Errors;
		static IPageRepository PageRepository;

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

				PageRepository = MockRepository.GenerateStub<IPageRepository>();
			};

		Because of = () => { Errors = Configuration.Parse(ConfigString, PageRepository); };

		It should_report_unknown_entries = () => Errors.Where(x => x.Contains("foo")).ShouldNotBeNull();

		It should_report_the_invalid_maximum_attendee_count =
			() => Errors.Where(x => x.Contains("MaximumAttendees")).ShouldNotBeNull();

		It should_report_the_invalid_hard_limit =
			() => Errors.Where(x => x.Contains("HardLimit")).ShouldNotBeNull();
	}

	[Subject(typeof(DefaultPluginConfiguration))]
	public class When_the_plugin_configuration_is_parsed_without_required_options_being_configured
	{
		static IEnumerable<string> Errors;
		static DefaultPluginConfiguration Configuration;
		static IPageRepository PageRepository;

		Establish context = () =>
			{
				Configuration = new DefaultPluginConfiguration();
				PageRepository = MockRepository.GenerateStub<IPageRepository>();
			};

		Because of = () => { Errors = Configuration.Parse(String.Empty, PageRepository); };

		It should_report_the_missing_page_name =
			() => Errors.Where(x => x.Contains("The page name for the attendee page is missing")).ShouldNotBeNull();

		It should_report_the_missing_entry_pattern =
			() => Errors.Where(x => x.Contains("The entry pattern is missing")).ShouldNotBeNull();

		It should_report_the_missing_list_start_pattern =
			() => Errors.Where(x => x.Contains("The attendee list start pattern is missing")).ShouldNotBeNull();

		It should_report_the_missing_list_end_pattern =
			() => Errors.Where(x => x.Contains("The attendee list end pattern is missing")).ShouldNotBeNull();

		It should_report_the_missing_waiting_list_end_pattern =
			() => Errors.Where(x => x.Contains("The attendee waiting list end pattern is missing")).ShouldNotBeNull();

		It should_report_the_missing_maximum_attendee_number =
			() => Errors.Where(x => x.Contains("The maximum attendee number is missing")).ShouldNotBeNull();
	}

	[Subject(typeof(DefaultPluginConfiguration))]
	public class When_the_plugin_configuration_is_parsed_with_a_page_that_dues_not_exist
	{
		static DefaultPluginConfiguration Configuration;
		static string ConfigString;
		static IEnumerable<string> Errors;
		static IPageRepository PageRepository;

		Establish context = () =>
		{
			Configuration = new DefaultPluginConfiguration();

			ConfigString = String.Join("\n",
									   new[]
				                           {
				                           	"Page=does not exist"
				                           });

			PageRepository = MockRepository.GenerateStub<IPageRepository>();
		};

		Because of = () => { Errors = Configuration.Parse(ConfigString, PageRepository); };

		It should_report_that_the_page_does_not_exits =
			() =>
			Errors.Where(x => x.Contains("The attendee page 'does not exist' does not exist.")).
				ShouldNotBeNull();
	}

	[Subject(typeof(DefaultPluginConfiguration))]
	public class When_the_plugin_configuration_is_parsed_with_a_hard_limit_lower_than_the_maximum_attendee_number
	{
		static DefaultPluginConfiguration Configuration;
		static string ConfigString;
		static IEnumerable<string> Errors;
		static IPageRepository PageRepository;

		Establish context = () =>
			{
				Configuration = new DefaultPluginConfiguration();

				ConfigString = String.Join("\n",
				                           new[]
				                           {
				                           	"MaximumAttendees=10",
				                           	"HardLimit=9"
				                           });

				PageRepository = MockRepository.GenerateStub<IPageRepository>();
			};

		Because of = () => { Errors = Configuration.Parse(ConfigString, PageRepository); };

		It should_report_the_that_the_attendee_count_must_be_less_than_or_equal_to_the_hard_limit =
			() =>
			Errors.Where(x => x.Contains("The maximum attendee count must be less than or equal to the hard limit")).
				ShouldNotBeNull();
	}
}