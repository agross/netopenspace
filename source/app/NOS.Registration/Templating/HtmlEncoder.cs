using Microsoft.Security.Application;

namespace NOS.Registration.Templating
{
	public class HtmlEncoder
	{
		public static string Attr(string value)
		{
			return AntiXss.HtmlAttributeEncode(value);
		}
		
		public static string Html(string value)
		{
			return AntiXss.HtmlEncode(value);
		}
	}
}