using System;
using System.Collections.Generic;

using NOS.Registration.Model;

namespace NOS.Registration.Queries
{
	public class Attendees : IQuery<IEnumerable<User>>
	{
		public IEnumerable<User> Apply(IEnumerable<User> data)
		{
			throw new NotImplementedException();
		}
	}
}