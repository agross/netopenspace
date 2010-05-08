using System.Collections.Generic;

using Machine.Specifications;

using NOS.Registration.Model;
using NOS.Registration.Queries;
using NOS.Registration.Tests.ForTesting;

namespace NOS.Registration.Tests.Queries
{
	[Subject(typeof(ActiveUsers))]
	public class When_active_users_are_queried
	{
		static IEnumerable<User> Result;

		static User[] Users;
		static ActiveUsers Query;
		static User Active2;
		static User Active1;

		Establish context = () =>
			{
				Active1 = New.User.Named("Alex").Active().PrefersTo(Preference.Attend);
				Active2 = New.User.Named("Torsten").Active().PrefersTo(Preference.InterestOnly);

				Users = new[]
				        {
				        	Active1,
				        	Active2,
				        	New.User.Named("Peter").Inactive().PrefersTo(Preference.InterestOnly),
				        	New.User.Named("Klaus").Inactive().PrefersTo(Preference.Withdraw)
				        };

				Query = new ActiveUsers();
			};

		Because of = () => { Result = Query.Apply(Users); };

		It should_return_active_users_only =
			() => Result.ShouldContainOnly(Active1, Active2);
	}
}