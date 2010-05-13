using System.Web;

namespace NOS.Registration.Abstractions
{
	public class HttpResponse : IHttpResponse
	{
		HttpContext _context;

		public void Forbidden()
		{
			_context.Response.StatusCode = 403;
			_context.Response.End();
		}

		public void Connect(HttpContext httpContext)
		{
			_context = httpContext;
		}
	}
}