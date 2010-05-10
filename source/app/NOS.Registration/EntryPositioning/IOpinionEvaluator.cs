namespace NOS.Registration.EntryPositioning
{
	public interface IOpinionEvaluator
	{
		Opinion Evaluate(EvaluationContext context);

		IHaveOpinionAboutEntryPosition[] Opinions
		{
			get;
		}
	}
}