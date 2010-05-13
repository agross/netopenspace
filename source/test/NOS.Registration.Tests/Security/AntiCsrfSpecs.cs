using System;
using System.Security;

using Machine.Specifications;

using NOS.Registration.Abstractions;
using NOS.Registration.Security;

using Rhino.Mocks;

namespace NOS.Registration.Tests.Security
{
	[Subject(typeof(AntiCsrf))]
	public class When_a_token_is_generated
	{
		static IAntiCsrf AntiCsrf;
		static string FirstToken;
		static string SecondToken;
		static ISession Session;

		Establish context = () =>
			{
				Session = MockRepository.GenerateStub<ISession>();
				AntiCsrf = new AntiCsrf(MockRepository.GenerateStub<ILogger>(), Session, MockRepository.GenerateStub<IUserContext>());
			};

		Because of = () =>
			{
				FirstToken = AntiCsrf.GenerateToken();
				SecondToken = AntiCsrf.GenerateToken();
			};

		It should_generate_a_random_token =
			() => FirstToken.ShouldNotBeEmpty();

		It should_generate_a_random_token_longer_than_10_characters =
			() => FirstToken.Length.ShouldBeGreaterThan(10);

		It should_generate_a_random_token_on_each_request =
			() => FirstToken.ShouldNotEqual(SecondToken);

		It should_store_the_newest_token_in_the_session =
			() => Session.CsrfToken.ShouldEqual(SecondToken);
	}

	[Subject(typeof(AntiCsrf))]
	public class When_a_valid_token_is_verified
	{
		static IAntiCsrf AntiCsrf;
		static ISession Session;
		static string Token;

		Establish context = () =>
			{
				Token = "the token";

				Session = MockRepository.GenerateStub<ISession>();
				Session.CsrfToken = Token;

				AntiCsrf = new AntiCsrf(MockRepository.GenerateStub<ILogger>(), Session, MockRepository.GenerateStub<IUserContext>());
			};

		Because of = () => AntiCsrf.Verify(Token);

		It should_accept_the_token =
			() => true.ShouldBeTrue();
	}

	[Subject(typeof(AntiCsrf))]
	public class When_an_invalid_token_is_verified
	{
		static IAntiCsrf AntiCsrf;
		static ISession Session;
		static string InvalidToken;
		static Exception Exception;
		static ILogger Logger;

		Establish context = () =>
			{
				InvalidToken = "the invalid token";

				Logger = MockRepository.GenerateStub<ILogger>();

				Session = MockRepository.GenerateStub<ISession>();
				Session.CsrfToken = "the valid token";

				var userContext = MockRepository.GenerateStub<IUserContext>();
				userContext
					.Stub(x => x.UserName)
					.Return("the user");

				AntiCsrf = new AntiCsrf(Logger, Session, userContext);
			};

		Because of = () => { Exception = Catch.Exception(() => AntiCsrf.Verify(InvalidToken)); };

		It should_refuse_the_token =
			() => Exception.ShouldBeOfType<SecurityException>();

		It should_end_the_session =
			() => Session.AssertWasCalled(x => x.EndSessionAndEnforceLogin());

		It should_log_that_token_verification_failed =
			() => Logger.AssertWasCalled(x => x.Warning(Arg<string>.Matches(y => y.StartsWith("CSRF token verification failed")),
			                                            Arg<string>.Is.Equal("the user")));
	}

	[Subject(typeof(AntiCsrf))]
	public class When_a_token_is_verified_and_the_session_token_is_empty
	{
		static IAntiCsrf AntiCsrf;
		static ISession Session;
		static Exception Exception;

		Establish context = () =>
			{
				Session = MockRepository.GenerateStub<ISession>();

				AntiCsrf = new AntiCsrf(MockRepository.GenerateStub<ILogger>(), Session, MockRepository.GenerateStub<IUserContext>());
			};

		Because of = () => { Exception = Catch.Exception(() => AntiCsrf.Verify("the token")); };

		It should_refuse_the_token =
			() => Exception.ShouldBeOfType<SecurityException>();
	}
	
	[Subject(typeof(AntiCsrf))]
	public class When_a_token_is_verified_and_the_submitted_token_is_empty
	{
		static IAntiCsrf AntiCsrf;
		static ISession Session;
		static Exception Exception;

		Establish context = () =>
			{
				Session = MockRepository.GenerateStub<ISession>();
				Session.CsrfToken = "the valid token";

				AntiCsrf = new AntiCsrf(MockRepository.GenerateStub<ILogger>(), Session, MockRepository.GenerateStub<IUserContext>());
			};

		Because of = () => { Exception = Catch.Exception(() => AntiCsrf.Verify(null)); };

		It should_refuse_the_token =
			() => Exception.ShouldBeOfType<SecurityException>();
	}
}