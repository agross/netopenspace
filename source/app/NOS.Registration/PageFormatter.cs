using System;
using System.Text.RegularExpressions;

using NOS.Registration.EntryPositioning;

namespace NOS.Registration
{
	internal class PageFormatter : IPageFormatter
	{
		readonly ILogger _logger;
		readonly IOpinionEvaluator _opinionEvaluator;

		public PageFormatter(ILogger logger, IOpinionEvaluator opinionEvaluator)
		{
			_logger = logger;
			_opinionEvaluator = opinionEvaluator;
		}

		public string AddEntry(string content, string entry, User user, IPluginConfiguration configuration)
		{
			var entryMatcher = NewRegex(configuration.EntryPattern);
			var listStartMatcher = NewRegex(configuration.ListStartPattern);
			var listEndMatcher = NewRegex(configuration.ListEndPattern);
			var waitingListEndMatcher = NewRegex(configuration.WaitingListEndPattern);

			int listStart = AssertMatchesOnce(content, listStartMatcher, "list start");
			int listEnd = AssertMatchesOnce(content, listEndMatcher, "list end");
			int waitingListEnd = AssertMatchesOnce(content, waitingListEndMatcher, "waiting list end");
			if (listEnd == -1 || listEnd == -1 || waitingListEnd == -1)
			{
				throw new InvalidOperationException(
					"The list and/or waiting list regular expressions did not match once. See previous errors.");
			}

			if (listEnd < listStart)
			{
				_logger.Error(String.Format("The list end position ({0}) is before the list start position ({1})",
				                            listEnd,
				                            listStart),
				              "SYSTEM");
				throw new InvalidOperationException("The list start and end positions are not sanitized. See previous error.");
			}

			int numberOfAttendees = CountNumberOfEntries(content.Substring(listStart, listEnd - listStart), entryMatcher);

			Opinion opinion = _opinionEvaluator.Evaluate(new EvaluationContext
				                           {
				                           	NumberOfAttendees = numberOfAttendees,
				                           	Configuration = configuration,
				                           	User = user,
				                           	Logger = _logger
				                           });

			int index = MapOpinionToIndexInDocument(opinion, listEnd, waitingListEnd);

			return content.Insert(index, entry);
		}

		static int MapOpinionToIndexInDocument(Opinion opinion, int listEnd, int waitingListEnd)
		{
			switch (opinion)
			{
				case Opinion.IncludeInList:
					return listEnd;
				case Opinion.IncludeInWaitingList:
					return waitingListEnd;
			}

			throw new ArgumentException(String.Format("The opinion {0} is not supported", opinion), "opinion");
		}

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