using System.Collections.Generic;

namespace NOS.Registration
{
	public interface IQuery<T>
	{
		T Apply(IEnumerable<User> data);
	}
}