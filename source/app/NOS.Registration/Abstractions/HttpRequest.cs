using System.Web;

namespace NOS.Registration.Abstractions
{
	public class HttpRequest : IHttpRequest
	{
		HttpContext _context;

		public string GetFormValue(string key)
		{
			return _context.Request.Form[key];
		}

		public void Connect(HttpContext httpContext)
		{
			_context = httpContext;
		}
	}
}