using System.Linq;

namespace NOS.Registration.EntryPositioning
{
	public class DefaultOpinionEvaluator : IOpinionEvaluator
	{
		readonly IHaveOpinionAboutEntryPosition[] _opinions;

		public DefaultOpinionEvaluator(IHaveOpinionAboutEntryPosition[] opinions)
		{
			_opinions = opinions;
		}

		public IHaveOpinionAboutEntryPosition[] Opinions
		{
			get { return _opinions; }
		}

		public Opinion Evaluate(EvaluationContext context)
		{
			return Opinions
				.Select(x => x.GetOpinionAboutPosition(context))
				.Where(x => x != Opinion.NoOpinion)
				.Last();
		}
	}
}