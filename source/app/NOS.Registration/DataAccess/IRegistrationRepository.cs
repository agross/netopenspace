using NOS.Registration.Model;
using NOS.Registration.Queries;

namespace NOS.Registration.DataAccess
{
	public interface IRegistrationRepository
	{
		void Save(User user);
		void Delete(User user);
		T Query<T>(IQuery<T> query);
	}
}