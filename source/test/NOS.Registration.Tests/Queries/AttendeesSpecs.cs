using System.Collections.Generic;

using Machine.Specifications;

using NOS.Registration.Model;
using NOS.Registration.Queries;
using NOS.Registration.Tests.ForTesting;

namespace NOS.Registration.Tests.Queries
{
	[Subject(typeof(Attendees))]
	public class When_attendees_are_queried
	{
		static IEnumerable<User> Result;

		static User[] Users;
		static Attendees Query;
		static User Attendee;

		Establish context = () =>
			{
				Attendee = New.User.Named("Alex").Active().PrefersTo(Preference.Attend).WhichIs(Request.Accepted);

				Users = new[]
				        {
				        	Attendee,
				        	New.User.Named("Torsten").Active().PrefersTo(Preference.Attend).WhichIs(Request.Refused),
				        	New.User.Named("Hans").Inactive().PrefersTo(Preference.Attend).WhichIs(Request.Accepted),
				        	New.User.Named("Peter").Active().PrefersTo(Preference.InterestOnly),
				        	New.User.Named("Klaus").Active().PrefersTo(Preference.Withdraw)
				        };

				Query = new Attendees();
			};

		Because of = () => { Result = Query.Apply(Users); };

		It should_return_active_attendees_preferring_to_attend =
			() => Result.ShouldContainOnly(Attendee);
	}
}