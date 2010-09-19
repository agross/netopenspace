using System.Collections.Generic;

namespace NOS.Registration
{
	public interface IRegistrationRepository
	{
		void Save(User user);
		IEnumerable<User> GetAll();
		User FindByUserName(string userName);
	}
}