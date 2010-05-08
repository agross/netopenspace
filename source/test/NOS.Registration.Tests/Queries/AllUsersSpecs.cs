using System.Collections.Generic;

using Machine.Specifications;

using NOS.Registration.Model;
using NOS.Registration.Queries;
using NOS.Registration.Tests.ForTesting;

namespace NOS.Registration.Tests.Queries
{
	[Subject(typeof(AllUsers))]
	public class When_all_users_are_queried
	{
		static IEnumerable<User> Result;

		static User[] Users;
		static AllUsers Query;

		Establish context = () =>
			{
				Users = new User[]
				        {
				        	New.User.Named("Alex").Active(),
				        	New.User.Named("Torsten").Inactive()
				        };

				Query = new AllUsers();
			};

		Because of = () => { Result = Query.Apply(Users); };

		It should_return_all_users =
			() => Result.ShouldEqual(Users);
	}
}