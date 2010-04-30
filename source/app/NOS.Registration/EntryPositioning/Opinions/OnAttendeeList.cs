namespace NOS.Registration.EntryPositioning.Opinions
{
	class OnAttendeeList : IHaveOpinionAboutEntryPosition
	{
		public Opinion GetOpinionAboutPosition(EvaluationContext context)
		{
			return Opinion.IncludeInList;
		}
	}
}