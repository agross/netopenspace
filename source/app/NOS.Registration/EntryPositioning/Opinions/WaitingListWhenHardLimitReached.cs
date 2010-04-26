using System;

namespace NOS.Registration.EntryPositioning.Opinions
{
	class WaitingListWhenHardLimitReached : IHaveOpinionAboutEntryPosition
	{
		public Opinion GetOpinionAboutPosition(EvaluationContext context)
		{
			if (context.NumberOfAttendees < context.Configuration.HardLimit)
			{
				return Opinion.NoOpinion;
			}

			context.Logger.Info(String.Format("User entry for '{0}' is on the waiting list, hard limit of {1} reached with {2} entries",
			                                  context.User.UserName,
			                                  context.Configuration.HardLimit,
			                                  context.NumberOfAttendees),
			                    "SYSTEM");

			return Opinion.IncludeInWaitingList;
		}
	}
}