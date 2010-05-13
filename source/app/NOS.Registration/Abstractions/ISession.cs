using System.Web;

namespace NOS.Registration.Abstractions
{
	public interface ISession
	{
		string CsrfToken
		{
			get;
			set;
		}

		void EndSession();
	}

	public class Session : ISession
	{
		public string CsrfToken
		{
			get { return Get<string>("CsrfToken"); }
			set { Set("CsrfToken", value); }
		}

		public void EndSession()
		{
			HttpContext.Current.Session.Abandon();
		}

		T Get<T>(string keyName)
		{
			return (T) HttpContext.Current.Session[Key(keyName)];
		}

		void Set<T>(string keyName, T value)
		{
			HttpContext.Current.Session[Key(keyName)] = value;
		}

		string Key(string keyName)
		{
			return GetType().Name + "." + keyName;
		}
	}
}