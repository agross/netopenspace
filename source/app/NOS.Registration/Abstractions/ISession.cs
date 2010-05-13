namespace NOS.Registration.Abstractions
{
	public interface ISession
	{
		string CsrfToken
		{
			get;
			set;
		}

		void EndSessionAndEnforceLogin();
	}
}