using System;

namespace NOS.Registration
{
	public interface IAutoRegistrationView
	{
		string UserName
		{
			get;
		}

		string Xing
		{
			get;
		}

		string Twitter
		{
			get;
		}

		bool AutoRegisterUser
		{
			get;
		}

		string Name
		{
			get;
		}

		string Blog
		{
			get;
		}

		string Email
		{
			get;
		}

		string Picture
		{
			get;
		}

		event EventHandler<EventArgs> UserCreated;
	}
}