using System;

namespace NOS.Registration.EntryPositioning
{
	class AtListEndWhenSponsoring : IHasOpinionAboutEntryPosition
	{
		public int GetPosition(EvaluationContext context)
		{
			if (context.NumberOfAttendees >= context.Configuration.MaximumAttendees && context.User.Data.Sponsoring <= decimal.Zero)
			{
				context.Logger.Info(String.Format("User entry for '{0}' is on the waiting list, maximum attendee count of {1} is reached with {2} entries",
										   context.User.UserName,
										   context.Configuration.MaximumAttendees,
										   context.NumberOfAttendees),
				             "SYSTEM");

				return context.WaitingListEnd;
			}

			return int.MinValue;
		}
	}
}