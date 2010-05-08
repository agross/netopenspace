using System.Collections.Generic;
using System.Linq;

using NOS.Registration.Formatting;

namespace NOS.Registration.Commands
{
	internal class FormatContentCommand : Command<FormatContentMessage>
	{
		readonly IList<IMarkupFormatter> _formatters;

		public FormatContentCommand(IList<IMarkupFormatter> formatters)
		{
			_formatters = formatters;
		}

		protected override ReturnValue Execute(FormatContentMessage message)
		{
			var formatted = _formatters.Aggregate(message.RawContent, (partial, formatter) => formatter.Format(partial));

			return ReturnValue.Success().SetValue(formatted);
		}
	}

	public class FormatContentMessage
	{
		public FormatContentMessage(string rawContent)
		{
			RawContent = rawContent;
		}

		public string RawContent
		{
			get;
			private set;
		}
	}
}