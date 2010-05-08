using System.Collections.Generic;
using System.Linq;

using NOS.Registration.Model;

namespace NOS.Registration.Queries
{
	public class ActiveUsers : IQuery<IEnumerable<User>>
	{
		public virtual IEnumerable<User> Apply(IEnumerable<User> data)
		{
			return data.Where(x => x.Active);
		}
	}
}