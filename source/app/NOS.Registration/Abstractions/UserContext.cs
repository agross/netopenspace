using ScrewTurn.Wiki;

namespace NOS.Registration.Abstractions
{
	public class UserContext : IUserContext
	{
		public string UserName
		{
			get { return SessionFacade.CurrentUsername; }
		}
	}
}