using NOS.Registration.EntryPositioning;
using NOS.Registration.EntryPositioning.Opinions;

using StructureMap.Configuration.DSL;

namespace NOS.Registration.ContainerConfiguration
{
	public class EntryPositioning : Registry
	{
		public EntryPositioning()
		{
			ForSingletonOf<IHaveOpinionAboutEntryPosition>().Add<OnAttendeeList>();
			ForSingletonOf<IHaveOpinionAboutEntryPosition>().Add<OnWaitingListIfNotSponsoring>();
			ForSingletonOf<IHaveOpinionAboutEntryPosition>().Add<OnWaitingListIfHardLimitIsReached>();
			ForSingletonOf<IOpinionEvaluator>().Use<DefaultOpinionEvaluator>();
		}
	}
}