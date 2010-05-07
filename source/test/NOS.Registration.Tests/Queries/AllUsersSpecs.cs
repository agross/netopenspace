using System.Collections.Generic;

using Machine.Specifications;

using NOS.Registration.Model;
using NOS.Registration.Queries;

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
				Users = new[]
				        {
				        	new User { UserName = "Alex", Data = new UserData() },
				        	new User { UserName = "Torsten", Data = new UserData() }
				        };

				Query = new AllUsers();
			};

		Because of = () => { Result = Query.Apply(Users); };

		It should_return_the_user_collection =
			() => Result.ShouldEqual(Users);
	}
}