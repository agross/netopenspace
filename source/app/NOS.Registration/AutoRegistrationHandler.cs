using System.Security;
using System.Web;

using NOS.Registration.Abstractions;
using NOS.Registration.Security;

namespace NOS.Registration
{
	public class AutoRegistrationHandler : IHttpHandler
	{
		readonly IAntiCsrf _antiCsrf;
		readonly IHttpRequest _request;
		readonly IHttpResponse _response;

		public AutoRegistrationHandler()
			: this(Container.GetInstance<IAntiCsrf>(),
			       Container.GetInstance<IHttpRequest>(),
			       Container.GetInstance<IHttpResponse>())
		{
		}

		public AutoRegistrationHandler(IAntiCsrf antiCsrf, IHttpRequest request, IHttpResponse response)
		{
			_antiCsrf = antiCsrf;
			_request = request;
			_response = response;
		}

		public void ProcessRequest(HttpContext context)
		{
			try
			{
				_antiCsrf.Verify(_request.GetFormValue("token"));
			}
			catch (SecurityException)
			{
				_response.Forbidden();
			}
		}

		public bool IsReusable
		{
			get { return false; }
		}
	}
}