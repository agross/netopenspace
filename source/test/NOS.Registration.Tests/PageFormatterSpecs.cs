using System;

using Machine.Specifications;

using NOS.Registration.Abstractions;
using NOS.Registration.EntryPositioning;

using Rhino.Mocks;
using Rhino.Mocks.Constraints;

namespace NOS.Registration.Tests
{
	public abstract class PageFormatterSpecs
	{
		protected static IPluginConfiguration Configuration;
		protected static IOpinionEvaluator Evaluator;
		protected static ILogger Logger;
		protected static IPageFormatter PageFormatter;
		protected static User User;

		Establish context = () =>
			{
				Logger = MockRepository.GenerateStub<ILogger>();

				Configuration = MockRepository.GenerateStub<IPluginConfiguration>();
				Configuration.Stub(x => x.ListStartPattern).Return("^list start$");
				Configuration.Stub(x => x.ListEndPattern).Return("\nlist end$");
				Configuration.Stub(x => x.WaitingListEndPattern).Return("\nwaiting list end$");
				Configuration.Stub(x => x.EntryPattern).Return("^#.*$");

				User = new User("user");

				Evaluator = MockRepository.GenerateStub<IOpinionEvaluator>();
				Evaluator
					.Stub(x => x.Evaluate(null))
					.IgnoreArguments()
					.Return(Opinion.IncludeInList);

				PageFormatter = new PageFormatter(Logger, Evaluator);
			};
	}

	[Subject(typeof(PageFormatter))]
	public class When_content_is_formatted : PageFormatterSpecs
	{
		static string OldContent;
		static string NewContent;

		Establish context = () => { OldContent = "list start\n# Entry 1\nlist end\nwaiting list end"; };

		Because of =
			() => { NewContent = PageFormatter.AddEntry(OldContent, "\nentry", User, Configuration); };

		It should_ask_at_which_position_the_content_should_be_placed =
			() => Evaluator.AssertWasCalled(x => x.Evaluate(null), o => o.IgnoreArguments());

		It should_add_the_user_to_the_list_at_the_specified_position =
			() => NewContent.ShouldEqual("list start\n# Entry 1\nentry\nlist end\nwaiting list end");
	}

	[Subject(typeof(PageFormatter))]
	public class When_content_is_formatted_and_the_list_start_cannot_be_found : PageFormatterSpecs
	{
		static string OldContent;
		static Exception Exception;

		Establish context = () => { OldContent = String.Empty; };

		Because of =
			() => { Exception = Catch.Exception(() => PageFormatter.AddEntry(OldContent, "\nentry", User, Configuration)); };

		It should_log_that_the_list_start_could_not_be_found =
			() => Logger.AssertWasCalled(x => x.Error(null, null),
			                             o => o.Constraints(Text.StartsWith("The list start cannot be found"),
			                                                Is.Equal("SYSTEM")));

		It should_fail =
			() => Exception.ShouldNotBeNull();
	}

	[Subject(typeof(PageFormatter))]
	public class When_content_is_formatted_and_the_list_start_is_found_more_than_once : PageFormatterSpecs
	{
		static string OldContent;
		static Exception Exception;

		Establish context = () => { OldContent = "list start\nlist start"; };

		Because of =
			() => { Exception = Catch.Exception(() => PageFormatter.AddEntry(OldContent, "\nentry", User, Configuration)); };

		It should_log_that_the_list_start_is_found_more_than_once =
			() => Logger.AssertWasCalled(x => x.Error(null, null),
			                             o => o.Constraints(Text.StartsWith("The list start was found 2 times"),
			                                                Is.Equal("SYSTEM")));

		It should_fail =
			() => Exception.ShouldNotBeNull();
	}

	[Subject(typeof(PageFormatter))]
	public class When_content_is_formatted_and_the_list_end_cannot_be_found : PageFormatterSpecs
	{
		static string OldContent;
		static Exception Exception;

		Establish context = () => { OldContent = "list start\nlist start"; };

		Because of =
			() => { Exception = Catch.Exception(() => PageFormatter.AddEntry(OldContent, "\nentry", User, Configuration)); };

		It should_log_that_the_list_start_could_not_be_found =
			() => Logger.AssertWasCalled(x => x.Error(null, null),
			                             o => o.Constraints(Text.StartsWith("The list end cannot be found"),
			                                                Is.Equal("SYSTEM")));

		It should_fail =
			() => Exception.ShouldNotBeNull();
	}

	[Subject(typeof(PageFormatter))]
	public class When_content_is_formatted_and_the_list_end_is_found_more_than_once : PageFormatterSpecs
	{
		static string OldContent;
		static Exception Exception;

		Establish context = () => { OldContent = "list start\nlist end\nlist end"; };

		Because of =
			() => { Exception = Catch.Exception(() => PageFormatter.AddEntry(OldContent, "\nentry", User, Configuration)); };

		It should_log_that_the_list_end_is_found_more_than_once =
			() => Logger.AssertWasCalled(x => x.Error(null, null),
			                             o => o.Constraints(Text.StartsWith("The list end was found 2 times"),
			                                                Is.Equal("SYSTEM")));

		It should_fail = 
			() => Exception.ShouldNotBeNull();
	}

	[Subject(typeof(PageFormatter))]
	public class When_content_is_formatted_and_the_waiting_list_end_cannot_be_found : PageFormatterSpecs
	{
		static string OldContent;
		static Exception Exception;

		Establish context = () => { OldContent = "list start\nlist end"; };

		Because of =
			() => { Exception = Catch.Exception(() => PageFormatter.AddEntry(OldContent, "\nentry", User, Configuration)); };

		It should_log_that_the_waiting_list_end_could_not_be_found =
			() => Logger.AssertWasCalled(x => x.Error(null, null),
			                             o => o.Constraints(Text.StartsWith("The waiting list end cannot be found"),
			                                                Is.Equal("SYSTEM")));

		It should_fail = 
			() => Exception.ShouldNotBeNull();
	}

	[Subject(typeof(PageFormatter))]
	public class When_content_is_formatted_and_the_waiting_list_end_is_found_more_than_once
		: PageFormatterSpecs
	{
		static string OldContent;
		static Exception Exception;

		Establish context = () => { OldContent = "list start\nlist end\nwaiting list end\nwaiting list end"; };

		Because of =
			() => { Exception = Catch.Exception(() => PageFormatter.AddEntry(OldContent, "\nentry", User, Configuration)); };

		It should_log_that_the_waiting_list_end_is_found_more_than_once =
			() => Logger.AssertWasCalled(x => x.Error(null, null),
			                             o => o.Constraints(Text.StartsWith("The waiting list end was found 2 times"),
			                                                Is.Equal("SYSTEM")));

		It should_fail =
			() => Exception.ShouldNotBeNull();
	}

	[Subject(typeof(PageFormatter))]
	public class When_content_is_formatted_and_the_list_end_comes_before_the_start : PageFormatterSpecs
	{
		static string OldContent;
		static Exception Exception;

		Establish context = () => { OldContent = "\nlist end\nlist start\nwaiting list end"; };

		Because of =
			() => { Exception = Catch.Exception(() => PageFormatter.AddEntry(OldContent, "\nentry", User, Configuration)); };

		It should_log_that_the_waiting_list_end_is_invalid =
			() => Logger.AssertWasCalled(x => x.Error("The list end position (0) is before the list start position (10)",
			                                          "SYSTEM"));

		It should_fail =
			() => Exception.ShouldNotBeNull();
	}

	[Subject(typeof(PageFormatter))]
	public class When_long_content_is_formatted : PageFormatterSpecs
	{
		static string OldContent;
		static string NewContent;
		
		Establish context =
			() => { OldContent = new string(' ', 1000) + "\nlist start\n# Entry 1\nlist end\nwaiting list end"; };

		Because of =
			() => { NewContent = PageFormatter.AddEntry(OldContent, "\nentry", User, Configuration); };

		It should_succeed =
			() => NewContent.ShouldContain("\nlist start\n# Entry 1\nentry");
	}
}