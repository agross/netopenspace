using System.Collections.Generic;

using NOS.Registration.Model;

namespace NOS.Registration.Queries
{
	public interface IQuery<T>
	{
		T Apply(IEnumerable<User> data);
	}
}