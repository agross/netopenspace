using Machine.Specifications;

using NOS.Registration.Model;
using NOS.Registration.Tests.ForTesting;

namespace NOS.Registration.Tests.Model
{
	[Subject(typeof(User))]
	public class When_a_user_is_created
	{
		static User User;

		Because of = () => { User = new User("Alex"); };

		It should_have_a_user_name =
			() => User.UserName.ShouldEqual("Alex");

		It should_be_inactive =
			() => User.Active.ShouldBeFalse();

		It should_have_user_data =
			() => User.Data.ShouldNotBeNull();

		It should_request_to_attend =
			() => User.Participation.Preference.ShouldEqual(Preference.Attend);

		It should_refuse_the_request =
			() => User.Participation.Result.ShouldEqual(Request.Refused);
	}

	[Subject(typeof(User))]
	public class When_two_users_with_the_same_user_name_but_different_data_are_compared
	{
		static User User1;
		static User User2;
		static bool Equal;

		Establish context = () =>
			{
				User1 = New.User.Named("Alex").Active();
				User2 = New.User.Named("alex").Inactive();
			};

		Because of = () => { Equal = User1.Equals(User2); };

		It should_be_considered_equal =
			() => Equal.ShouldBeTrue();
	}
}