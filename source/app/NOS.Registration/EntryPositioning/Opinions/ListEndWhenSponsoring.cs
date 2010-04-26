using System;

namespace NOS.Registration.EntryPositioning.Opinions
{
	class ListEndWhenSponsoring : IHaveOpinionAboutEntryPosition
	{
		public Opinion GetOpinionAboutPosition(EvaluationContext context)
		{
			if (context.NumberOfAttendees < context.Configuration.MaximumAttendees)
			{
				return Opinion.NoOpinion;
			}

			if (context.User.Data.Sponsoring > decimal.Zero)
			{
				return Opinion.NoOpinion;
			}

			context.Logger.Info(String.Format("User entry for '{0}' is on the waiting list, maximum attendee count of {1} is reached with {2} entries",
			                                  context.User.UserName,
			                                  context.Configuration.MaximumAttendees,
			                                  context.NumberOfAttendees),
			                    "SYSTEM");

			return Opinion.IncludeInWaitingList;
		}
	}
}