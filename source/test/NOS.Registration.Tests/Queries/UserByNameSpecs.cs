using Machine.Specifications;

using NOS.Registration.Model;
using NOS.Registration.Queries;
using NOS.Registration.Tests.ForTesting;

namespace NOS.Registration.Tests.Queries
{
	[Subject(typeof(UserByUserName))]
	public class When_an_existing_user_is_queried_by_the_user_name
	{
		static User Result;
		static User[] Users;
		static UserByUserName Query;

		Establish context = () =>
			{
				Users = new User[]
				        {
				        	New.User.Named("Alex"),
				        	New.User.Named("Torsten")
				        };

				Query = new UserByUserName("torsten");
			};

		Because of = () => { Result = Query.Apply(Users); };

		It should_return_a_matching_user =
			() => Result.UserName.ShouldEqual("Torsten");
	}

	[Subject(typeof(UserByUserName))]
	public class When_a_user_cannot_be_found_by_the_user_name
	{
		static User Result;
		static User[] Users;
		static UserByUserName Query;

		Establish context = () =>
			{
				Users = new User[]
				        {
				        	New.User.Named("Alex"),
				        	New.User.Named("Torsten")
				        };

				Query = new UserByUserName("Peter");
			};

		Because of = () => { Result = Query.Apply(Users); };

		It should_return_null =
			() => Result.ShouldBeNull();
	}
}