using System.Collections.Generic;

using NOS.Registration.Model;

namespace NOS.Registration.Queries
{
	public class AllUsers : IQuery<IEnumerable<User>>
	{
		public IEnumerable<User> Apply(IEnumerable<User> data)
		{
			return data;
		}
	}
}