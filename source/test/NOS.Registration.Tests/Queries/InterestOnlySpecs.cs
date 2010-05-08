using System.Collections.Generic;

using Machine.Specifications;

using NOS.Registration.Model;
using NOS.Registration.Queries;
using NOS.Registration.Tests.ForTesting;

namespace NOS.Registration.Tests.Queries
{
	[Subject(typeof(InterestOnly))]
	public class When_the_users_showing_interest_are_queried
	{
		static IEnumerable<User> Result;

		static User[] Users;
		static InterestOnly Query;
		static User InterestOnly;

		Establish context = () =>
			{
				InterestOnly = New.User.Named("Torsten").Active().PrefersTo(Preference.InterestOnly);

				Users = new[]
				        {
				        	InterestOnly,
				        	New.User.Named("Alex").Active().PrefersTo(Preference.Attend).WhichIs(Request.Accepted),
				        	New.User.Named("Hans").Inactive().PrefersTo(Preference.Attend),
				        	New.User.Named("Peter").Inactive().PrefersTo(Preference.InterestOnly),
				        	New.User.Named("Klaus").Active().PrefersTo(Preference.Withdraw)
				        };

				Query = new InterestOnly();
			};

		Because of = () => { Result = Query.Apply(Users); };

		It should_return_active_users_showing_interest =
			() => Result.ShouldContainOnly(InterestOnly);
	}
}