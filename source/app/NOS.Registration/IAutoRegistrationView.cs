using System;
using System.Web.UI.WebControls;

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

		decimal Sponsoring
		{
			get;
		}

		string InvoiceAddress
		{
			get;
		}

		event EventHandler<EventArgs> UserCreated;
		event EventHandler<ServerValidateEventArgs> ValidateInvoiceAddress;
	}
}