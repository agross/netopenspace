using System.Collections.Generic;
using System.Linq;

using NOS.Registration.Model;

namespace NOS.Registration.Queries
{
	public class Attendees : ActiveUsers
	{
		public override IEnumerable<User> Apply(IEnumerable<User> data)
		{
			return base
				.Apply(data)
				.Where(x => x.Participation.Preference == ParticipationPreference.Attending);
		}
	}
}