using System;
using System.Collections.Generic;
using System.Linq;

using NOS.Registration.Model;

namespace NOS.Registration.Queries
{
	public class UserByUserName : IQuery<User>
	{
		public UserByUserName(string userName)
		{
			UserName = userName;
		}

		public string UserName
		{
			get;
			private set;
		}

		public User Apply(IEnumerable<User> data)
		{
			return data.SingleOrDefault(x => x.UserName.Equals(UserName, StringComparison.OrdinalIgnoreCase));
		}
	}
}