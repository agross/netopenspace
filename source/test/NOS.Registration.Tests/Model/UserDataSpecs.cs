using Machine.Specifications;

using NOS.Registration.Model;

namespace NOS.Registration.Tests.Model
{
	[Subject(typeof(UserData))]
	public class When_the_formatted_sponsoring_for_zero_euros_is_created : With_user
	{
		Because of = () => { Formatted = User.FormattedSponsoring; };

		It should_return_an_empty_string = () => Formatted.ShouldBeEmpty();
	}

	[Subject(typeof(UserData))]
	public class When_the_formatted_sponsoring_for_integer_euros_is_created : With_user
	{
		Establish context = () => { User.Sponsoring = 42; };

		Because of = () => { Formatted = User.FormattedSponsoring; };

		It should_return_the_integer_part = () => Formatted.ShouldEqual("42");
	}

	[Subject(typeof(UserData))]
	public class When_the_formatted_sponsoring_for_fractional_euros_is_created : With_user
	{
		Establish context = () => { User.Sponsoring = 0.1m; };

		Because of = () => { Formatted = User.FormattedSponsoring; };

		It should_return_the_fractional_part_padded_with_zero = () => Formatted.ShouldEqual("0,10");
	}
	
	[Subject(typeof(UserData))]
	public class When_the_formatted_sponsoring_for_fractional_euros_larger_than_one_is_created : With_user
	{
		Establish context = () => { User.Sponsoring = 42.1m; };

		Because of = () => { Formatted = User.FormattedSponsoring; };

		It should_return_the_fractional_part_padded_with_zero = () => Formatted.ShouldEqual("42,10");
	}

	public class With_user
	{
		protected static string Formatted;
		protected static UserData User;

		Establish context = () => { User = new UserData { Sponsoring = 0 }; };
	}
}