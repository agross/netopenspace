using System;

using Machine.Specifications;

using NOS.Registration.Commands;

namespace NOS.Registration.Tests.Commands
{
	[Subject(typeof(ActivateUserCommand))]
	public class When_a_user_account_is_activated
	{
		/*Establish context = () => {  };

		Because of = () => { };

		It should_ = () => { };
		 
		 
		 * static IPagesStorageProviderV30 Provider;
		static UserAccountActivityEventArgs EventArgs;
		protected static UserInfo UserInfo;
		static User User;
		protected static PageInfo PageInfo;

		Establish context = () =>
			{
				UserInfo = new UserInfo("user",
				                        "The User",
				                        "email@example.com",
				                        true,
				                        DateTime.Now,
				                        MockRepository.GenerateStub<IUsersStorageProviderV30>());
				EventArgs = new UserAccountActivityEventArgs(UserInfo, UserAccountActivity.AccountActivated);

				User = new User("user");
				RegistrationRepository
					.Stub(x => x.Query(Arg<UserByUserName>.Matches(y => y.UserName == "user")))
					.Return(User);

				Configuration
					.Stub(x => x.Parse(null))
					.IgnoreArguments()
					.Return(new List<string>());

				Host
					.Stub(x => x.SendEmail(null, null, null, null, false))
					.IgnoreArguments()
					.Return(true);

				Plugin.Init(Host, String.Empty);

				EntryFormatter
					.Stub(x => x.FormatUserEntry(User, Configuration.EntryTemplate))
					.Return(Configuration.EntryTemplate);
			};

		Because of = () => Host.Raise(x => x.UserAccountActivity += null, null, EventArgs);

		It should_try_to_find_the_user_in_the_user_list =
			() =>
			RegistrationRepository.AssertWasCalled(x => x.Query(Arg<UserByUserName>.Matches(y => y.UserName == User.UserName)));

		It should_notify_the_user_about_the_activation =
			() => NotificationSender.AssertWasCalled(x => x.SendMessage(Arg<string>.Is.Equal(UserInfo.Username),
			                                                            Arg<string>.Is.Equal(UserInfo.Email),
			                                                            Arg<string>.Is.Equal("AutoRegistration"),
			                                                            Arg<bool>.Is.Equal(false)));

		It should_not_delete_the_user = () => RegistrationRepository.AssertWasNotCalled(x => x.Delete("user"));
		 * 
		 * 	[Behaviors]
	public class FailureNotificationBehavior
	{
		protected static INotificationSender NotificationSender;
		protected static UserInfo UserInfo;

		It should_notify_the_administrator_about_the_failure =
			() => NotificationSender.AssertWasCalled(x => x.SendMessage(Arg<string>.Is.NotNull,
			                                                            Arg<string>.Is.NotEqual(UserInfo.Email),
			                                                            Arg<string>.Is.NotNull,
			                                                            Arg<bool>.Is.Equal(true)));

		It should_notify_the_user_about_the_failure =
			() => NotificationSender.AssertWasCalled(x => x.SendMessage(Arg<string>.Is.NotNull,
			                                                            Arg<string>.Is.Equal(UserInfo.Email),
			                                                            Arg<string>.Is.NotNull,
			                                                            Arg<bool>.Is.Equal(true)));
	}
		 */
	}
}