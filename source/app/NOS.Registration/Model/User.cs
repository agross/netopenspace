using System;

namespace NOS.Registration.Model
{
	public class User : IEquatable<User>
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

		public bool Active
		{
			get;
			set;
		}

		public bool Equals(User other)
		{
			if (ReferenceEquals(null, other))
			{
				return false;
			}
			if (ReferenceEquals(this, other))
			{
				return true;
			}
			return StringComparer.OrdinalIgnoreCase.Equals(other.UserName, UserName);
		}

		public override string ToString()
		{
			return string.Format("UserName: {0}", UserName);
		}

		public override bool Equals(object obj)
		{
			if (ReferenceEquals(null, obj))
			{
				return false;
			}
			if (ReferenceEquals(this, obj))
			{
				return true;
			}
			if (obj.GetType() != typeof(User))
			{
				return false;
			}
			return Equals((User) obj);
		}

		public override int GetHashCode()
		{
			return UserName.GetHashCode();
		}

		public static bool operator ==(User left, User right)
		{
			return Equals(left, right);
		}

		public static bool operator !=(User left, User right)
		{
			return !Equals(left, right);
		}
	}
}