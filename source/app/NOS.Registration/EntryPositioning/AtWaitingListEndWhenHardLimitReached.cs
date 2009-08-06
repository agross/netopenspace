using System;

namespace NOS.Registration.EntryPositioning
{
	class AtWaitingListEndWhenHardLimitReached : IHasOpinionAboutEntryPosition
	{
		public int GetPosition(EvaluationContext context)
		{
			if (context.NumberOfAttendees >= context.Configuration.HardLimit)
			{
				context.Logger.Info(String.Format("User entry for '{0}' is on the waiting list, hard limit of {1} reached with {2} entries",
										   context.User.UserName,
										   context.Configuration.HardLimit,
										   context.NumberOfAttendees),
							 "SYSTEM");

				return context.WaitingListEnd;
			}

			return int.MinValue;
		}
	}
}