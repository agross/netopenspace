namespace NOS.Registration
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
	}
}