using System;
using System.Web.UI;
using System.Web.UI.WebControls;

using NOS.Registration;

namespace NOS
{
	public partial class AutoRegistration : UserControl, IAutoRegistrationView
	{
		public AutoRegistration()
		{
			new AutoRegistrationPresenter(this);
		}

		public string UserName
		{
			get { return ((TextBox) FindControlRecursive(Page, "txtUsername")).Text.Trim(); }
		}

		public string Xing
		{
			get { return txtXingUserName.Text.Trim(); }
		}

		public string Twitter
		{
			get { return txtTwitterUserName.Text.Trim(); }
		}

		public bool AutoRegisterUser
		{
			get { return chkAutoRegister.Checked; }
		}

		public string Name
		{
			get { return txtName.Text.Trim(); }
		}

		public string Blog
		{
			get { return txtBlog.Text.Trim(); }
		}

		public string Email
		{
			get
			{
				if (!chkPublishEmail.Checked)
				{
					return null;
				}

				return ((TextBox) FindControlRecursive(Page, "txtEmail1")).Text.Trim();
			}
		}

		public string Picture
		{
			get { return txtPicture.Text.Trim(); }
		}

		public decimal Sponsoring
		{
			get
			{
				decimal value;
				if (decimal.TryParse(txtSponsoring.Text, out value))
				{
					return value;
				}
				return 0;
			}
		}

		public event EventHandler<EventArgs> UserCreated;

		protected override void OnLoad(EventArgs e)
		{
			base.OnLoad(e);

			chkAutoRegister_CheckedChanged(this, EventArgs.Empty);

			if (IsPostBack)
			{
				Page.Validate();
				if (!Page.IsValid)
				{
					return;
				}

				OnUserCreated();
			}
		}

		void OnUserCreated()
		{
			var temp = UserCreated;
			if (temp != null)
			{
				temp(this, EventArgs.Empty);
			}
		}

		static Control FindControlRecursive(Control root, string id)
		{
			if (root.ID == id)
			{
				return root;
			}

			foreach (Control c in root.Controls)
			{
				Control t = FindControlRecursive(c, id);
				if (t != null)
				{
					return t;
				}
			}

			return null;
		}

		void chkAutoRegister_CheckedChanged(object sender, EventArgs e)
		{
			rfvName.Enabled =
				revPicture.Enabled =
				revBlog.Enabled = chkAutoRegister.Checked;
		}

		protected void rfvInvoiceAddress_ServerValidate(object source, ServerValidateEventArgs args)
		{
		}
	}
}