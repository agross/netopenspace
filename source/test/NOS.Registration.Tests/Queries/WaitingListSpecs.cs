using System.Collections.Generic;

using Machine.Specifications;

using NOS.Registration.Model;
using NOS.Registration.Queries;
using NOS.Registration.Tests.ForTesting;

namespace NOS.Registration.Tests.Queries
{
	[Subject(typeof(WaitingList))]
	public class When_the_waiting_list_is_queried
	{
		static IEnumerable<User> Result;

		static User[] Users;
		static WaitingList Query;
		static User Waiting;

		Establish context = () =>
			{
				Waiting = New.User.Named("Torsten").Active().PrefersTo(Preference.Attend).WhichIs(Request.Refused);

				Users = new[]
				        {
				        	Waiting,
				        	New.User.Named("Alex").Active().PrefersTo(Preference.Attend).WhichIs(Request.Accepted),
							New.User.Named("Hans").Inactive().PrefersTo(Preference.Attend).WhichIs(Request.Refused),
				        	New.User.Named("Peter").Active().PrefersTo(Preference.InterestOnly),
				        	New.User.Named("Klaus").Active().PrefersTo(Preference.Withdraw)
				        };

				Query = new WaitingList();
			};

		Because of = () => { Result = Query.Apply(Users); };

		It should_return_active_waiting_list_members =
			() => Result.ShouldContainOnly(Waiting);
	}
}