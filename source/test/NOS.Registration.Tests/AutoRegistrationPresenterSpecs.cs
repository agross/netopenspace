using System;

using Machine.Specifications;

using Rhino.Mocks;

namespace NOS.Registration.Tests
{
	public class With_auto_registration_view
	{
		protected static ILogger Logger;
		protected static IRegistrationRepository Repository;
		protected static IAutoRegistrationView View;

		Establish context = () =>
			{
				View = MockRepository.GenerateStub<IAutoRegistrationView>();
				Repository = MockRepository.GenerateStub<IRegistrationRepository>();
				Logger = MockRepository.GenerateStub<ILogger>();
			};
	}

	[Subject(typeof(AutoRegistrationPresenter))]
	public class When_the_auto_registration_presenter_is_created : With_auto_registration_view
	{
		static AutoRegistrationPresenter Presenter;

		Because of = () => { new AutoRegistrationPresenter(View, Repository, Logger); };

		It should_subscribe_to_user_creation_event =
			() => View.AssertWasCalled(x => x.UserCreated += Arg<EventHandler<EventArgs>>.Is.NotNull);
	}

	[Subject(typeof(AutoRegistrationPresenter))]
	public class When_a_user_is_created : With_auto_registration_view
	{
		Establish context = () =>
			{
				View.Stub(x => x.AutoRegisterUser).Return(true);
				View.Stub(x => x.UserName).Return("username");
				View.Stub(x => x.Xing).Return("xing");
				View.Stub(x => x.Twitter).Return("twitter");
				View.Stub(x => x.Name).Return("name");
				View.Stub(x => x.Email).Return("email");
				View.Stub(x => x.Blog).Return("blog");
				View.Stub(x => x.Picture).Return("picture");
				View.Stub(x => x.Sponsoring).Return(12.34m);

				new AutoRegistrationPresenter(View, Repository, Logger);
			};

		Because of = () => View.Raise(x => x.UserCreated += null, null, EventArgs.Empty);

		It should_save_the_user =
			() => Repository.AssertWasCalled(x => x.Save(Arg<User>.Is.NotNull));

		It should_save_the_Wiki_user_name_from_the_view =
			() => Repository.AssertWasCalled(x => x.Save(Arg<User>.Matches(y => y.UserName.Equals("username"))));

		It should_save_the_Xing_user_name_from_the_view =
			() => Repository.AssertWasCalled(x => x.Save(Arg<User>.Matches(y => y.Data.Xing.Equals("xing"))));

		It should_save_the_Twitter_user_name_from_the_view =
			() => Repository.AssertWasCalled(x => x.Save(Arg<User>.Matches(y => y.Data.Twitter.Equals("twitter"))));
	
		It should_save_the_name_from_the_view =
			() => Repository.AssertWasCalled(x => x.Save(Arg<User>.Matches(y => y.Data.Name.Equals("name"))));
	
		It should_save_the_email_address_from_the_view =
			() => Repository.AssertWasCalled(x => x.Save(Arg<User>.Matches(y => y.Data.Email.Equals("email"))));
	
		It should_save_the_blog_URL_from_the_view =
			() => Repository.AssertWasCalled(x => x.Save(Arg<User>.Matches(y => y.Data.Blog.Equals("blog"))));
	
		It should_save_the_picture_URL_from_the_view =
			() => Repository.AssertWasCalled(x => x.Save(Arg<User>.Matches(y => y.Data.Picture.Equals("picture"))));
	
		It should_save_the_sponsoring_value_from_the_view =
			() => Repository.AssertWasCalled(x => x.Save(Arg<User>.Matches(y => y.Data.Sponsoring.Equals(12.34m))));
	}

	[Subject(typeof(AutoRegistrationPresenter))]
	public class When_a_user_is_created_and_saving_the_registration_data_fails : With_auto_registration_view
	{
		static Exception Exception;

		Establish context = () =>
			{
				View.Stub(x => x.AutoRegisterUser).Return(true);
				View.Stub(x => x.UserName).Return("username");

				Repository.Stub(x => x.Save(Arg<User>.Is.Anything)).Throw(new Exception());

				new AutoRegistrationPresenter(View, Repository, Logger);
			};

		Because of =
			() => { Exception = Catch.Exception(() => View.Raise(x => x.UserCreated += null, null, EventArgs.Empty)); };

		It should_log_the_fact_that_saving_the_registration_data_failed =
			() => Logger.AssertWasCalled(x => x.Error(Arg<string>.Matches(y => y.Contains("failed")),
			                                          Arg<string>.Is.Equal("username")));

		It should_swallow_the_error = () => Exception.ShouldBeNull();
	}

	[Subject(typeof(AutoRegistrationPresenter))]
	public class When_a_user_is_created_that_does_not_want_to_auto_register : With_auto_registration_view
	{
		Establish context = () =>
			{
				View.Stub(x => x.AutoRegisterUser).Return(false);
				View.Stub(x => x.UserName).Return("username");

				new AutoRegistrationPresenter(View, Repository, Logger);
			};

		Because of = () => View.Raise(x => x.UserCreated += null, null, EventArgs.Empty);

		It should_not_save_the_user =
			() => Repository.AssertWasNotCalled(x => x.Save(Arg<User>.Is.Anything));

		It should_log_the_fact_that_the_user_does_not_want_to_be_registered_automatically =
			() =>
			Logger.AssertWasCalled(
				x => x.Info(Arg<string>.Matches(y => y.Contains("opted-out")), Arg<string>.Is.Equal("username")));
	}
}