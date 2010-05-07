using System;
using System.Globalization;
using System.Web.Script.Serialization;

namespace NOS.Registration.Model
{
	public class UserData
	{
		string _blog;
		string _email;
		string _name;
		string _picture;
		string _twitter;
		string _xing;

		public string Xing
		{
			get { return EmptyStringToNull(_xing); }
			set { _xing = value; }
		}

		public string Twitter
		{
			get { return EmptyStringToNull(_twitter); }
			set { _twitter = value; }
		}

		public string Blog
		{
			get { return EmptyStringToNull(_blog); }
			set { _blog = value; }
		}

		public string Email
		{
			get { return EmptyStringToNull(_email); }
			set { _email = value; }
		}

		public string Picture
		{
			get { return EmptyStringToNull(_picture); }
			set { _picture = value; }
		}

		public string Name
		{
			get { return EmptyStringToNull(_name); }
			set { _name = value; }
		}

		public decimal Sponsoring
		{
			get;
			set;
		}

		[ScriptIgnore]
		public string FormattedSponsoring
		{
			get
			{
				if (Sponsoring == decimal.Zero)
				{
					return String.Empty;
				}

				var culture = CultureInfo.GetCultureInfo("de-DE");

				if (decimal.Ceiling(Sponsoring) == Sponsoring)
				{
					return Sponsoring.ToString("0", culture);
				}

				return Sponsoring.ToString("0.00", culture);
			}
		}

		static string EmptyStringToNull(string value)
		{
			return String.IsNullOrEmpty(value) ? null : value;
		}
	}
}