using System.Collections.Generic;
using System.Linq;

using NOS.Registration.Model;

namespace NOS.Registration.Queries
{
	public class Attendees : IQuery<IEnumerable<User>>
	{
		public IEnumerable<User> Apply(IEnumerable<User> data)
		{
			return data.Where(x => x.Participation.Preference == ParticipationPreference.Attending);
		}
	}
}