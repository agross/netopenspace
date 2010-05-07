using System.Text.RegularExpressions;

using Machine.Specifications;

using NOS.Registration.Formatting;

namespace NOS.Registration.Tests.Formatting
{
	[Subject(typeof(MarkupScanner))]
	public class When_a_markup_scanner_is_created
	{
		static MarkupScanner Scanner;

		Because of = () => { Scanner = new MarkupScanner("the name", "foo"); };

		It should_have_a_name =
			() => Scanner.Name.ShouldEqual("the name");
	}

	[Subject(typeof(MarkupScanner))]
	public class When_a_string_is_recognized_by_the_scanner
	{
		static MarkupScanner Scanner;
		static Match Match;

		Establish context = () => { Scanner = new MarkupScanner("the name", "test"); };

		Because of = () => { Match = Scanner.Match("TEST"); };

		It should_match_with_the_case_being_ignored =
			() => Match.Success.ShouldBeTrue();
	}

	[Subject(typeof(MarkupScanner))]
	public class When_a_string_is_not_recognized_by_the_scanner
	{
		static MarkupScanner Scanner;
		static Match Match;

		Establish context = () => { Scanner = new MarkupScanner("the name", "test"); };

		Because of = () => { Match = Scanner.Match("42"); };

		It should_not_match =
			() => Match.Success.ShouldBeFalse();
	}
}