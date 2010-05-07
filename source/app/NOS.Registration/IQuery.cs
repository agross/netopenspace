using System.Collections.Generic;

using NOS.Registration.Model;

namespace NOS.Registration
{
	public interface IQuery<T>
	{
		T Apply(IEnumerable<User> data);
	}
}