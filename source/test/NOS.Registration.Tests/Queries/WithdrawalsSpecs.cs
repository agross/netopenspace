using System.Collections.Generic;

using Machine.Specifications;

using NOS.Registration.Model;
using NOS.Registration.Queries;
using NOS.Registration.Tests.ForTesting;

namespace NOS.Registration.Tests.Queries
{
	[Subject(typeof(Withdrawals))]
	public class When_the_withdrawals_are_queried
	{
		static IEnumerable<User> Result;

		static User[] Users;
		static Withdrawals Query;
		static User Withdrawing;

		Establish context = () =>
			{
				Withdrawing = New.User.Named("Torsten").Active().PrefersTo(Preference.Withdraw);

				Users = new[]
				        {
				        	Withdrawing,
				        	New.User.Named("Alex").Active().PrefersTo(Preference.Attend).WhichIs(Request.Accepted),
				        	New.User.Named("Hans").Inactive().PrefersTo(Preference.Attend),
				        	New.User.Named("Peter").Active().PrefersTo(Preference.InterestOnly),
				        	New.User.Named("Klaus").Inactive().PrefersTo(Preference.Withdraw)
				        };

				Query = new Withdrawals();
			};

		Because of = () => { Result = Query.Apply(Users); };

		It should_return_active_withdrawals =
			() => Result.ShouldContainOnly(Withdrawing);
	}
}