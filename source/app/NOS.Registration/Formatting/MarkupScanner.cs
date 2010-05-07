using System.Text.RegularExpressions;

namespace NOS.Registration.Formatting
{
	public class MarkupScanner : IMarkupScanner
	{
		readonly Regex _expression;
		readonly string _name;

		public MarkupScanner(string name, string expression)
		{
			_name = name;
			_expression = new Regex(expression,
			                        RegexOptions.CultureInvariant |
			                        RegexOptions.Singleline |
			                        RegexOptions.Compiled |
			                        RegexOptions.IgnoreCase);
		}

		public Match Match(string str)
		{
			return _expression.Match(str);
		}

		public string Name
		{
			get { return _name; }
		}
	}
}