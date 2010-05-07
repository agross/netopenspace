using System.Collections.Generic;

using Machine.Specifications;

using NOS.Registration.Model;
using NOS.Registration.Queries;

namespace NOS.Registration.Tests.Queries
{
	[Subject(typeof(Attendees))]
	public class When_attendees_users_are_queried
	{
		static IEnumerable<User> Result;

		static User[] Users;
		static Attendees Query;
		static User Attendee2;
		static User Attendee1;

		Establish context = () =>
			{
				Attendee1 = new User("Alex")
				            {
				            	Participation = new ParticipationData { Preference = ParticipationPreference.Attending }
				            };
				Attendee2 = new User("Torsten")
				            {
				            	Participation = new ParticipationData { Preference = ParticipationPreference.Attending }
				            };

				Users = new[]
				        {
				        	Attendee1,
				        	Attendee2,
				        	new User("Peter")
				        	{
				        		Participation = new ParticipationData { Preference = ParticipationPreference.InterestOnly }
				        	},
				        	new User("Klaus")
				        	{
				        		Participation = new ParticipationData { Preference = ParticipationPreference.Withdrawal }
				        	}
				        };

				Query = new Attendees();
			};

		Because of = () => { Result = Query.Apply(Users); };

		It should_retun_attendees_only =
			() => Result.ShouldContainOnly(Attendee1, Attendee2);
	}
}