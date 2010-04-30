using System.Collections.Generic;

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