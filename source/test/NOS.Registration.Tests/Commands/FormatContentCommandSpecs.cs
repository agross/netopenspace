using System.Linq;

using Machine.Specifications;

using NOS.Registration.Commands;
using NOS.Registration.Formatting;

using Rhino.Mocks;

namespace NOS.Registration.Tests.Commands
{
	[Subject(typeof(FormatContentCommand))]
	public class When_page_content_is_formatted
	{
		static IMarkupFormatter[] MarkupFormatters;
		static FormatContentCommand Command;
		static ReturnValue Result;

		Establish context = () =>
			{
				MarkupFormatters = new[]
				                   {
				                   	MockRepository.GenerateStub<IMarkupFormatter>(),
				                   	MockRepository.GenerateStub<IMarkupFormatter>()
				                   };

				MarkupFormatters.Last()
					.Stub(x => x.Format(null))
					.Return("formatted");

				Command = new FormatContentCommand(MarkupFormatters);
			};

		Because of = () => { Result = Command.Execute(new FormatContentMessage("raw")); };

		It should_succeed =
			() => Result.Messages.ShouldBeEmpty();
		
		It should_return_the_formatted_result_of_the_last_formatter =
			() => Result.Value.ShouldEqual("formatted");

		It should_format_the_content_with_all_known_formatters =
			() => MarkupFormatters.Each(x => x.AssertWasCalled(y => y.Format(Arg<string>.Is.Anything)));
	}
}