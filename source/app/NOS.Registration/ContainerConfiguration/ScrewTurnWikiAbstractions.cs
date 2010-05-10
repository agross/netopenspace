using NOS.Registration.Abstractions;

using StructureMap;
using StructureMap.Configuration.DSL;
using StructureMap.Pipeline;

namespace NOS.Registration.ContainerConfiguration
{
	public class ScrewTurnWikiAbstractions : Registry
	{
		public ScrewTurnWikiAbstractions()
		{
			For<ILogger>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<Logger>();

			For<IFileReader>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<FileReader>();

			For<IFileWriter>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<FileWriter>();

			For<IWikiSettings>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<WikiSettings>();

			For<INotificationSender>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<EmailNotificationSender>();

			For<IPluginConfiguration>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<DefaultPluginConfiguration>();
		}
	}
}