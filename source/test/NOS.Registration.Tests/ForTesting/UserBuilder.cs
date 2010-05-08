using NOS.Registration.Model;

namespace NOS.Registration.Tests.ForTesting
{
	public class UserBuilder
	{
		bool _active;
		Request _calculation;
		string _name;
		Preference _preference;

		public UserBuilder Named(string name)
		{
			_name = name;
			return this;
		}

		public UserBuilder Active()
		{
			_active = true;
			return this;
		}

		public UserBuilder Inactive()
		{
			_active = false;
			return this;
		}

		public UserBuilder PrefersTo(Preference preference)
		{
			_preference = preference;
			return this;
		}

		public UserBuilder WhichIs(Request calculation)
		{
			_calculation = calculation;
			return this;
		}

		public static implicit operator User(UserBuilder builder)
		{
			return new User(builder._name)
			       {
			       	Active = builder._active,
			       	Participation = new ParticipationData
			       	                {
			       	                	Preference = builder._preference,
			       	                	Result = builder._calculation
			       	                }
			       };
		}
	}
}