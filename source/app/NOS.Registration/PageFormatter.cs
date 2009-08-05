using System;
using System.Text.RegularExpressions;

namespace NOS.Registration
{
	internal class PageFormatter : IPageFormatter
	{
		readonly ILogger _logger;

		public PageFormatter(ILogger logger)
		{
			_logger = logger;
			EntryPattern = String.Empty;
			ListStartPattern = String.Empty;
			ListEndPattern = String.Empty;
			WaitingListEndPattern = String.Empty;
		}

		Regex EntryMatcher
		{
			get;
			set;
		}

		Regex ListStartMatcher
		{
			get;
			set;
		}

		Regex ListEndMatcher
		{
			get;
			set;
		}

		Regex WaitingListEndMatcher
		{
			get;
			set;
		}

		#region IPageFormatter Members
		public string EntryPattern
		{
			get { return EntryMatcher.ToString(); }
			set { EntryMatcher = NewRegex(value); }
		}

		public string ListStartPattern
		{
			get { return ListStartMatcher.ToString(); }
			set { ListStartMatcher = NewRegex(value); }
		}

		public string ListEndPattern
		{
			get { return ListEndMatcher.ToString(); }
			set { ListEndMatcher = NewRegex(value); }
		}

		public string WaitingListEndPattern
		{
			get { return WaitingListEndMatcher.ToString(); }
			set { WaitingListEndMatcher = NewRegex(value); }
		}

		public int MaximumAttendees
		{
			get;
			set;
		}

		public string AddEntry(string content, string entry, User user)
		{
			int listStart = AssertMatchesOnce(content, ListStartMatcher, "list start");
			int listEnd = AssertMatchesOnce(content, ListEndMatcher, "list end");
			int waitingListEnd = AssertMatchesOnce(content, WaitingListEndMatcher, "waiting list end");
			if (listEnd == -1 || listEnd == -1 || waitingListEnd == -1)
			{
				throw new InvalidOperationException("The list and/or waiting list regular expressions did not match once. See previous errors.");
			}

			if (listEnd < listStart)
			{
				_logger.Error(String.Format("The list end position ({0}) is before the list start position ({1})",
				                            listEnd,
				                            listStart),
				              "SYSTEM");
				throw new InvalidOperationException("The list start and end positions are not sanitized. See previous error.");
			}

			int addAtIndex = listEnd;

			int numberOfAttendees = CountNumberOfEntries(content.Substring(listStart, listEnd - listStart), EntryMatcher);
			if (numberOfAttendees >= MaximumAttendees && user.Data.Sponsoring <= decimal.Zero)
			{
				_logger.Info(String.Format("User entry '{0}' is on the waiting list, attendee list is full with {1} entries",
				                           entry.Substring(0, entry.Length > 20 ? 19 : entry.Length) + "...",
				                           numberOfAttendees),
				             "SYSTEM");

				addAtIndex = waitingListEnd;
			}

			return content.Insert(addAtIndex, entry);
		}
		#endregion

		int AssertMatchesOnce(string content, Regex matcher, string matchType)
		{
			MatchCollection matches = matcher.Matches(content);
			if (matches.Count == 0)
			{
				_logger.Error(String.Format("The {0} cannot be found: {1}", matchType, matcher), "SYSTEM");
				return -1;
			}

			if (matches.Count > 1)
			{
				_logger.Error(String.Format("The {0} was found {1} times: {2}", matchType, matches.Count, matcher),
				              "SYSTEM");
				return -1;
			}

			return matches[0].Captures[0].Index;
		}

		static Regex NewRegex(string value)
		{
			return new Regex(value, RegexOptions.Compiled | RegexOptions.IgnoreCase | RegexOptions.Multiline);
		}

		static int CountNumberOfEntries(string content, Regex matcher)
		{
			return matcher.Matches(content).Count;
		}
	}
}