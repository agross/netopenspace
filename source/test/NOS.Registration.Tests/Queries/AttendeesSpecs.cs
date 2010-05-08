using System.Collections.Generic;

using Machine.Specifications;

using NOS.Registration.Model;
using NOS.Registration.Queries;

namespace NOS.Registration.Tests.Queries
{
	[Subject(typeof(Attendees))]
	public class When_attendees_are_queried
	{
		static IEnumerable<User> Result;

		static User[] Users;
		static Attendees Query;
		static User ActiveAttendee;

		Establish context = () =>
			{
				ActiveAttendee = new User("Alex")
				            {
								Active = true,
								Participation = new ParticipationData { Preference = ParticipationPreference.Attending }
				            };

				Users = new[]
				        {
				        	ActiveAttendee,
				        	new User("Torsten")
				        	{
				        		Active = false,
				        		Participation = new ParticipationData { Preference = ParticipationPreference.Attending }
				        	},
				        	new User("Peter")
				        	{
				        		Active = true,
								Participation = new ParticipationData { Preference = ParticipationPreference.InterestOnly }
				        	},
				        	new User("Klaus")
				        	{
				        		Active = true,
								Participation = new ParticipationData { Preference = ParticipationPreference.Withdrawal }
				        	}
				        };

				Query = new Attendees();
			};

		Because of = () => { Result = Query.Apply(Users); };

		It should_return_active_attendees_only =
			() => Result.ShouldContainOnly(ActiveAttendee);
	}
}