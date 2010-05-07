using System.Collections.Generic;

using Machine.Specifications;

using NOS.Registration.Abstractions;
using NOS.Registration.Formatting;
using NOS.Registration.Queries;

using Rhino.Mocks;

namespace NOS.Registration.Tests.Formatting
{
	public abstract class AttendeeListFormatterSpecs
	{
		protected static IRegistrationRepository Registrations;

		protected static IFormatter CreateFormatter()
		{
			Registrations = MockRepository.GenerateStub<IRegistrationRepository>();

			return new AttendeeListFormatter(MockRepository.GenerateStub<ILogger>(),
			                                 Registrations);
		}

		protected static void SetupResultFor<T, TResult>(TResult result) where T : IQuery<TResult>
		{
			Registrations
				.Stub(x => x.Query(Arg<T>.Is.TypeOf))
				.Return(result);
		}
	}

	[Subject(typeof(AttendeeListFormatterSpecs))]
	public class When_no_markup_is_formatted : AttendeeListFormatterSpecs
	{
		static IFormatter Formatter;
		static string Html;
		static string Markup;

		Establish context = () =>
			{
				Formatter = CreateFormatter();
				Markup = "";
			};

		Because of = () => { Html = Formatter.Format(Markup); };

		It should_return_the_markup =
			() => Html.ShouldEqual(Markup);
	}

	[Subject(typeof(AttendeeListFormatter))]
	public class When_unknown_markup_is_formatted : AttendeeListFormatterSpecs
	{
		static string Html;
		static string Markup;
		static IFormatter Formatter;

		Establish context = () =>
			{
				Formatter = CreateFormatter();
				Markup = "some markup here";
			};

		Because of = () => { Html = Formatter.Format(Markup); };

		It should_return_the_markup =
			() => Html.ShouldEqual(Markup);
	}

	[Subject(typeof(AttendeeListFormatter))]
	public class When_a_list_without_users_list_is_formatted : AttendeeListFormatterSpecs
	{
		static string Html;
		static string Markup;
		static IFormatter Formatter;

		Establish context = () =>
			{
				Formatter = CreateFormatter();
				SetupResultFor<Attendees, IEnumerable<User>>(new User[] { });

				Markup = "<attendee-list empty-value=\"no entries\" />";
			};

		Because of = () => { Html = Formatter.Format(Markup); };

		It should_load_all_active_attendees =
			() => Registrations.AssertWasCalled(x => x.Query(Arg<Attendees>.Is.TypeOf));

		It should_render_an_empty_list =
			() => Html.ShouldEqual("<ul><li>no entries</li></ul>");
	}

	[Subject(typeof(AttendeeListFormatter))]
	public class When_a_list_with_users_list_is_formatted : AttendeeListFormatterSpecs
	{
		static string Html;
		static string Markup;
		static IFormatter Formatter;

		Establish context = () =>
			{
				Formatter = CreateFormatter();

				var users = new[]
				            {
				            	new User { UserName = "alex", Data = new UserData() },
				            	new User { UserName = "torsten", Data = new UserData() }
				            };
				SetupResultFor<Attendees, IEnumerable<User>>(users);

				Markup = "<attendee-list empty-value=\"no entries\" />";
			};

		Because of = () => { Html = Formatter.Format(Markup); };

		It should_load_all_active_attendees =
			() => Registrations.AssertWasCalled(x => x.Query(Arg<Attendees>.Is.TypeOf));

		It should_render_the_list_of_users =
			() => Html.ShouldEqual("<ol><li>alex</li><li>torsten</li></ol>");
	}
}