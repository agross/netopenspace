using System.Web;

namespace NOS.Registration.Abstractions
{
	public class UserContext : IUserContext
	{
		public string UserName
		{
			get { return HttpContext.Current.User.Identity.Name; }
		}
	}
}