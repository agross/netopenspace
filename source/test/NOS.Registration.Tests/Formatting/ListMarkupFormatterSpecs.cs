using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

using Machine.Specifications;

using NOS.Registration.Abstractions;
using NOS.Registration.Formatting;
using NOS.Registration.Formatting.Lists;
using NOS.Registration.Model;

using Rhino.Mocks;

namespace NOS.Registration.Tests.Formatting
{
	public abstract class ListMarkupFormatterSpecs
	{
		static IMarkupScanner MarkupScanner;
		static IDataProvider<User> DataProvider;
		protected static IListFormatter<User> EmptyListFormatter;
		protected static IListFormatter<User> ListFormatter;

		protected static IMarkupFormatter CreateFormatter()
		{
			MarkupScanner = MockRepository.GenerateStub<IMarkupScanner>();
			DataProvider = MockRepository.GenerateStub<IDataProvider<User>>();
			EmptyListFormatter = MockRepository.GenerateStub<IListFormatter<User>>();
			ListFormatter = MockRepository.GenerateStub<IListFormatter<User>>();
			
			return new ListMarkupFormatter<User>(MockRepository.GenerateStub<ILogger>(),
			                               MarkupScanner,
			                               DataProvider,
			                               EmptyListFormatter,
			                               ListFormatter);
		}

		protected static void MatchExpressionOnce(string markup, Match match)
		{
			MarkupScanner
				.Stub(x => x.Match(markup))
				.Return(match)
				.Repeat.Once();
		}

		protected static void DataProviderReturns(IEnumerable<User> users)
		{
			DataProvider
				.Stub(x => x.GetItems())
				.Return(users);
		}
	}

	[Subject(typeof(ListMarkupFormatter<>))]
	public class When_no_list_markup_is_formatted : ListMarkupFormatterSpecs
	{
		static IMarkupFormatter Formatter;
		static string Html;
		static string Markup;

		Establish context = () =>
			{
				Formatter = CreateFormatter();
				Markup = "";

				MatchExpressionOnce(Markup, Match.Empty);
			};

		Because of = () => { Html = Formatter.Format(Markup); };

		It should_return_the_markup =
			() => Html.ShouldEqual(Markup);
	}

	[Subject(typeof(ListMarkupFormatter<>))]
	public class When_unknown_list_markup_is_formatted : ListMarkupFormatterSpecs
	{
		static string Html;
		static string Markup;
		static IMarkupFormatter Formatter;

		Establish context = () =>
			{
				Formatter = CreateFormatter();
				Markup = "some markup here";

				MatchExpressionOnce(Markup, Match.Empty);
			};

		Because of = () => { Html = Formatter.Format(Markup); };

		It should_return_the_markup =
			() => Html.ShouldEqual(Markup);
	}

	[Subject(typeof(ListMarkupFormatter<>))]
	public class When_a_list_without_items_is_formatted : ListMarkupFormatterSpecs
	{
		static string Html;
		static string Markup;
		static IMarkupFormatter Formatter;

		Establish context = () =>
			{
				Formatter = CreateFormatter();
				Markup = "<attendee-list empty-value=\"no entries\" />";

				MatchExpressionOnce(Markup, Regex.Match(Markup, ".*"));
				MatchExpressionOnce(Arg<string>.Is.Anything, Match.Empty);
				
				DataProviderReturns(new User[] { });

				EmptyListFormatter
					.Stub(x => x.FormatEmptyList(null))
					.IgnoreArguments()
					.Return(new StringBuilder("no entries"));
			};

		Because of = () => { Html = Formatter.Format(Markup); };

		It should_render_an_empty_list =
			() => Html.ShouldEqual("no entries");
	}

	[Subject(typeof(ListMarkupFormatter<>))]
	public class When_a_list_with_items_list_is_formatted : ListMarkupFormatterSpecs
	{
		static string Html;
		static string Markup;
		static IMarkupFormatter Formatter;

		Establish context = () =>
			{
				Formatter = CreateFormatter();
				Markup = "<attendee-list empty-value=\"no entries\" />";

				var users = new[]
				            {
				            	new User { UserName = "alex", Data = new UserData() },
				            	new User { UserName = "torsten", Data = new UserData() }
				            };

				MatchExpressionOnce(Markup, Regex.Match(Markup, ".*"));
				MatchExpressionOnce(Arg<string>.Is.Anything, Match.Empty);

				DataProviderReturns(users);

				ListFormatter
					.Stub(x => x.FormatList(users))
					.IgnoreArguments()
					.Return(new StringBuilder("list result"));
			};

		Because of = () => { Html = Formatter.Format(Markup); };

		It should_render_the_list_of_items =
			() => Html.ShouldEqual("list result");
	}
}