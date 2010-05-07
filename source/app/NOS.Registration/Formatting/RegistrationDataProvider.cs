using System.Collections.Generic;

using NOS.Registration.Model;

namespace NOS.Registration.Formatting
{
	internal class RegistrationDataProvider<T> : IDataProvider<User> where T : IQuery<IEnumerable<User>>, new()
	{
		readonly IRegistrationRepository _repository;

		public RegistrationDataProvider(IRegistrationRepository repository)
		{
			_repository = repository;
		}

		public IEnumerable<User> GetItems()
		{
			var query = new T();
			return _repository.Query(query);
		}
	}
}