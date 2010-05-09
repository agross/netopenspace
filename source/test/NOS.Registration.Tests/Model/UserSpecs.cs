using Machine.Specifications;

using NOS.Registration.Model;

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
}