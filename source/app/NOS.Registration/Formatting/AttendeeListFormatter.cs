using System;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml;

using NOS.Registration.Abstractions;
using NOS.Registration.Queries;

namespace NOS.Registration.Formatting
{
	public class AttendeeListFormatter : IFormatter
	{
		static readonly Regex AttendeeList = new Regex(@"<attendee-list(.+?)/>",
		                                               RegexOptions.CultureInvariant |
													   RegexOptions.Singleline |
		                                               RegexOptions.Compiled |
		                                               RegexOptions.IgnoreCase);

		readonly ILogger _logger;
		readonly IRegistrationRepository _registrations;

		public AttendeeListFormatter(ILogger logger, IRegistrationRepository registrations)
		{
			_logger = logger;
			_registrations = registrations;
		}

		public string Format(string raw)
		{
			StringBuilder markup = new StringBuilder(raw);

			Match match = AttendeeList.Match(markup.ToString());
			while (match.Success)
			{
				markup.Remove(match.Index, match.Length);
				var list = RenderList(match.Value);
				markup.Insert(match.Index, list);

				match = AttendeeList.Match(markup.ToString());
			}

			return markup.ToString();
		}

		string RenderList(string markup)
		{
			try
			{
				XmlDocument doc = new XmlDocument();
				doc.LoadXml(markup);

				if (doc.DocumentElement == null)
				{
					throw new FormatException("Attendee list does not contain a document element.");
				}

				var emptyText = doc.DocumentElement.GetAttribute("empty-value");
				var attendees = _registrations.Query(new Attendees());
				if (!attendees.Any())
				{
					return String.Format("<ul><li>{0}</li></ul>", emptyText);
				}

				StringBuilder result = new StringBuilder("<ol>");

				attendees
					.Each(x => result.AppendFormat("<li>{0}</li>", x.Data.Name ?? x.UserName));

				result.Append("</ol>");
				return result.ToString();
			}
			catch (Exception ex)
			{
				_logger.Error("Error formatting Attendee List:" + ex, "SYSTEM");
				return String.Format("<b>FORMATTER ERROR (Malformed Attendee List: {0})</b>", ex);
			}
		}
	}
}