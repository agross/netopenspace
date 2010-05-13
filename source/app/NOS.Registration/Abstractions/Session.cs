using System.Web;
using System.Web.Security;

namespace NOS.Registration.Abstractions
{
	public class Session : ISession
	{
		public string CsrfToken
		{
			get { return Get<string>("CsrfToken"); }
			set { Set("CsrfToken", value); }
		}

		public void EndSessionAndEnforceLogin()
		{
			if (HttpContext.Current.Session == null)
			{
				return;
			}

			FormsAuthentication.SignOut();
			HttpContext.Current.Session.Abandon();
		}

		T Get<T>(string keyName)
		{
			if (HttpContext.Current.Session == null)
			{
				return default(T);
			}

			var value = HttpContext.Current.Session[Key(keyName)];
			if (value == null)
			{
				return default(T);
			}

			return (T) value;
		}

		void Set<T>(string keyName, T value)
		{
			if (HttpContext.Current.Session == null)
			{
				return;
			}

			HttpContext.Current.Session[Key(keyName)] = value;
		}

		string Key(string keyName)
		{
			return GetType().Name + "." + keyName;
		}
	}
}