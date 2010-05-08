using System.Collections.Generic;

using Machine.Specifications;

using NOS.Registration.Model;
using NOS.Registration.Queries;

namespace NOS.Registration.Tests.Queries
{
	[Subject(typeof(ActiveUsers))]
	public class When_active_users_are_queried
	{
		static IEnumerable<User> Result;

		static User[] Users;
		static ActiveUsers Query;
		static User Active2;
		static User Active1;

		Establish context = () =>
			{
				Active1 = new User("Alex")
				            {
								Active = true,
				            	Participation = new ParticipationData { Preference = ParticipationPreference.Attending }
				            };
				Active2 = new User("Torsten")
				            {
								Active = true,
				            	Participation = new ParticipationData { Preference = ParticipationPreference.Attending }
				            };

				Users = new[]
				        {
				        	Active1,
				        	Active2,
				        	new User("Peter")
				        	{
				        		Participation = new ParticipationData { Preference = ParticipationPreference.InterestOnly }
				        	},
				        	new User("Klaus")
				        	{
				        		Participation = new ParticipationData { Preference = ParticipationPreference.Withdrawal }
				        	}
				        };

				Query = new ActiveUsers();
			};

		Because of = () => { Result = Query.Apply(Users); };

		It should_return_active_users_only =
			() => Result.ShouldContainOnly(Active1, Active2);
	}
}