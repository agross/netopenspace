using System;

using Machine.Specifications;

using Rhino.Mocks;
using Rhino.Mocks.Constraints;

namespace NOS.Registration.Tests
{
	public class With_formatter
	{
		protected static Exception Exception;
		protected static ILogger Logger;
		protected static string NewContent;
		protected static string OldContent;
		protected static User User;
		static IPageFormatter PageFormatter;

		Establish context = () =>
			{
				Logger = MockRepository.GenerateStub<ILogger>();
				PageFormatter = new PageFormatter(Logger)
				                {
				                	ListStartPattern = "^list start$",
				                	ListEndPattern = "\nlist end$",
				                	WaitingListEndPattern = "\nwaiting list end$",
				                	EntryPattern = "^#.*$",
				                	MaximumAttendees = 2
				                };

				OldContent = String.Empty;

				User = new User("user");
			};

		Because of = () => { Exception = Catch.Exception(() => NewContent = PageFormatter.AddEntry(OldContent, "\nentry", User)); };
	}

	[Subject(typeof(PageFormatter))]
	public class When_content_is_formatted_and_the_list_start_cannot_be_found : With_formatter
	{
		It should_log_that_the_list_start_could_not_be_found =
			() => Logger.AssertWasCalled(x => x.Error(null, null),
			                             o => o.Constraints(Text.StartsWith("The list start cannot be found"),
			                                                Is.Equal("SYSTEM")));

		It should_fail = () => Exception.ShouldNotBeNull();
	}

	[Subject(typeof(PageFormatter))]
	public class When_content_is_formatted_and_the_list_start_is_found_more_than_once : With_formatter
	{
		Establish context = () => { OldContent = "list start\nlist start"; };

		It should_log_that_the_list_start_is_found_more_than_once =
			() => Logger.AssertWasCalled(x => x.Error(null, null),
			                             o => o.Constraints(Text.StartsWith("The list start was found 2 times"),
			                                                Is.Equal("SYSTEM")));

		It should_fail = () => Exception.ShouldNotBeNull();
	}

	[Subject(typeof(PageFormatter))]
	public class When_content_is_formatted_and_the_list_end_cannot_be_found : With_formatter
	{
		Establish context = () => { OldContent = "list start foo"; };

		It should_log_that_the_list_start_could_not_be_found =
			() => Logger.AssertWasCalled(x => x.Error(null, null),
			                             o => o.Constraints(Text.StartsWith("The list end cannot be found"),
			                                                Is.Equal("SYSTEM")));

		It should_fail = () => Exception.ShouldNotBeNull();
	}

	[Subject(typeof(PageFormatter))]
	public class When_content_is_formatted_and_the_list_end_is_found_more_than_once : With_formatter
	{
		Establish context = () => { OldContent = "list start\nlist end\nlist end"; };

		It should_log_that_the_list_end_is_found_more_than_once =
			() => Logger.AssertWasCalled(x => x.Error(null, null),
			                             o => o.Constraints(Text.StartsWith("The list end was found 2 times"),
			                                                Is.Equal("SYSTEM")));

		It should_fail = () => Exception.ShouldNotBeNull();
	}

	[Subject(typeof(PageFormatter))]
	public class When_content_is_formatted_and_the_waiting_list_end_cannot_be_found : With_formatter
	{
		Establish context = () => { OldContent = "list start\nfoo\nlist end"; };

		It should_log_that_the_waiting_list_end_could_not_be_found =
			() => Logger.AssertWasCalled(x => x.Error(null, null),
			                             o => o.Constraints(Text.StartsWith("The waiting list end cannot be found"),
			                                                Is.Equal("SYSTEM")));

		It should_fail = () => Exception.ShouldNotBeNull();
	}

	[Subject(typeof(PageFormatter))]
	public class When_content_is_formatted_and_the_waiting_list_end_is_found_more_than_once : With_formatter
	{
		Establish context = () => { OldContent = "list start\nlist end\nwaiting list end\nwaiting list end"; };

		It should_log_that_the_waiting_list_end_is_found_more_than_once =
			() => Logger.AssertWasCalled(x => x.Error(null, null),
			                             o => o.Constraints(Text.StartsWith("The waiting list end was found 2 times"),
			                                                Is.Equal("SYSTEM")));

		It should_fail = () => Exception.ShouldNotBeNull();
	}

	[Subject(typeof(PageFormatter))]
	public class When_content_is_formatted_and_the_list_end_comes_before_the_start : With_formatter
	{
		Establish context = () => { OldContent = "\nlist end\nlist start\nwaiting list end"; };

		It should_log_that_the_waiting_list_end_is_invalid =
			() => Logger.AssertWasCalled(x => x.Error("The list end position (0) is before the list start position (10)",
			                                          "SYSTEM"));

		It should_fail = () => Exception.ShouldNotBeNull();
	}

	[Subject(typeof(PageFormatter))]
	public class When_content_is_formatted : With_formatter
	{
		Establish context = () => { OldContent = "list start\n# Entry 1\nlist end\nwaiting list end"; };

		It should_add_the_user_to_the_list =
			() => NewContent.ShouldEqual("list start\n# Entry 1\nentry\nlist end\nwaiting list end");
	}

	[Subject(typeof(PageFormatter))]
	public class When_long_content_is_formatted : With_formatter
	{
		Establish context =
			() => { OldContent = new string(' ', 1000) + "\nlist start\n# Entry 1\nlist end\nwaiting list end"; };

		It should_succeed =
			() => NewContent.ShouldContain("list start\n# Entry 1\nentry\nlist end\nwaiting list end");
	}

	[Subject(typeof(PageFormatter))]
	public class When_content_is_formatted_and_the_attendee_list_is_full : With_formatter
	{
		Establish context = () => { OldContent = "list start\n# Entry 1\n# Entry 2\nlist end\nwaiting list end"; };

		It should_log_that_new_entry_will_be_put_on_the_waiting_list =
			() => Logger.AssertWasCalled(x => x.Info(null, null),
			                             o => o.Constraints(Text.StartsWith("User entry '\nentry...' is on the waiting list"),
			                                                Is.Equal("SYSTEM")));

		It should_add_the_user_to_the_waiting_list =
			() => NewContent.ShouldEqual("list start\n# Entry 1\n# Entry 2\nlist end\nentry\nwaiting list end");
	}

	[Subject(typeof(PageFormatter))]
	public class When_content_is_formatted_and_the_attendee_list_is_full_but_the_user_sponsored_some_amount_of_money : With_formatter
	{
		Establish context = () =>
			{
				OldContent = "list start\n# Entry 1\n# Entry 2\nlist end\nwaiting list end";

				User.Data.Sponsoring = 0.1m;
			};

		It should_add_the_user_to_the_attendee_list =
			() => NewContent.ShouldEqual("list start\n# Entry 1\n# Entry 2\nentry\nlist end\nwaiting list end");
	}
}