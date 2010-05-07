using System.Text.RegularExpressions;

namespace NOS.Registration.Formatting
{
	public interface IMarkupScanner
	{
		string Name
		{
			get;
		}

		Match Match(string str);
	}
}