using System.IO;
using System.Security;
using System.Web;

using Machine.Specifications;

using NOS.Registration.Abstractions;
using NOS.Registration.Security;

using Rhino.Mocks;

using HttpRequest = System.Web.HttpRequest;
using HttpResponse = System.Web.HttpResponse;

namespace NOS.Registration.Tests
{
	public abstract class AutoRegistrationHandlerSpecs
	{
		protected static IAntiCsrf AntiCsrf;
		protected static IHttpRequest Request;
		protected static IHttpResponse Response;

		protected static AutoRegistrationHandler CreateHandler()
		{
			AntiCsrf = MockRepository.GenerateStub<IAntiCsrf>();

			Request = MockRepository.GenerateStub<IHttpRequest>();
			Response = MockRepository.GenerateStub<IHttpResponse>();

			return new AutoRegistrationHandler(AntiCsrf,
			                                   Request,
			                                   Response);
		}

		protected static HttpContext CreateContext()
		{
			var request = new HttpRequest("foo", "http://example.com/the/url", "query");
			var response = new HttpResponse(new StringWriter());
			return new HttpContext(request, response);
		}
	}

	[Subject(typeof(AutoRegistrationHandler))]
	public class When_a_command_is_received : AutoRegistrationHandlerSpecs
	{
		static AutoRegistrationHandler Handler;

		Establish context = () =>
			{
				Handler = CreateHandler();

				Request
					.Stub(x => x.GetFormValue("token"))
					.Return("the token");
			};

		Because of = () => Handler.ProcessRequest(CreateContext());

		It should_verify_the_CSRF_token =
			() => AntiCsrf.AssertWasCalled(x => x.Verify("the token"));

		It should_not_use_the_handler_again =
			() => Handler.IsReusable.ShouldBeFalse();
	}

	[Subject(typeof(AutoRegistrationHandler))]
	public class When_a_command_causes_a_security_problem : AutoRegistrationHandlerSpecs
	{
		static AutoRegistrationHandler Handler;

		Establish context = () =>
			{
				Handler = CreateHandler();

				AntiCsrf
					.Stub(x => x.Verify(null))
					.IgnoreArguments()
					.Throw(new SecurityException());
			};

		Because of = () => Handler.ProcessRequest(CreateContext());

		It should_refuse_the_request =
			() => Response.AssertWasCalled(x => x.Forbidden());
	}
}