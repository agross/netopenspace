namespace NOS.Registration.EntryPositioning.Opinions
{
	class ListEnd : IHaveOpinionAboutEntryPosition
	{
		public Opinion GetOpinionAboutPosition(EvaluationContext context)
		{
			return Opinion.IncludeInList;
		}
	}
}