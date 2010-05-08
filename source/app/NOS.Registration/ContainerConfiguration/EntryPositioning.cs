using NOS.Registration.EntryPositioning;
using NOS.Registration.EntryPositioning.Opinions;

using StructureMap;
using StructureMap.Configuration.DSL;
using StructureMap.Pipeline;

namespace NOS.Registration.ContainerConfiguration
{
	public class EntryPositioning : Registry
	{
		public EntryPositioning()
		{
			For<IHaveOpinionAboutEntryPosition>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Add<OnAttendeeList>();

			For<IHaveOpinionAboutEntryPosition>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Add<OnWaitingListIfNotSponsoring>();

			For<IHaveOpinionAboutEntryPosition>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Add<OnWaitingListIfHardLimitIsReached>();

			For<IOpinionEvaluator>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<DefaultOpinionEvaluator>();
		}
	}
}