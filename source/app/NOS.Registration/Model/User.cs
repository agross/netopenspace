namespace NOS.Registration.Model
{
	public class User
	{
		public User() : this(null)
		{
		}

		public User(string userName)
		{
			UserName = userName;
			Data = new UserData();
			Participation = new ParticipationData();
		}

		public string UserName
		{
			get;
			set;
		}

		public UserData Data
		{
			get;
			set;
		}

		public ParticipationData Participation
		{
			get;
			set;
		}

		public override string ToString()
		{
			return string.Format("UserName: {0}", UserName);
		}
	}
}