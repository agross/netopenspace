using NOS.Registration.Model;

namespace NOS.Registration
{
	public interface IRegistrationRepository
	{
		void Save(User user);
		void Delete(string userName);
		T Query<T>(IQuery<T> query);
	}
}