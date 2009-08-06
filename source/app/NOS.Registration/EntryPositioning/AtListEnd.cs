namespace NOS.Registration.EntryPositioning
{
	class AtListEnd : IHasOpinionAboutEntryPosition
	{
		public int GetPosition(EvaluationContext context)
		{
			return context.ListEnd;
		}
	}
}