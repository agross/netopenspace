using System.Linq;

namespace NOS.Registration.EntryPositioning
{
	public class DefaultOpinionEvaluator : IOpinionEvaluator
	{
		readonly IHasOpinionAboutEntryPosition[] _opinions;

		public DefaultOpinionEvaluator(IHasOpinionAboutEntryPosition[] opinions)
		{
			_opinions = opinions;
		}

		#region IOpinionEvaluator Members
		public int Evaluate(EvaluationContext context)
		{
			return _opinions
				.Select(x => x.GetPosition(context))
				.Where(x => x >= 0)
				.Last();
		}
		#endregion
	}
}