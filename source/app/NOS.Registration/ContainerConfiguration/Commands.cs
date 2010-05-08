using NOS.Registration.Commands.Infrastructure;

using StructureMap;
using StructureMap.Configuration.DSL;
using StructureMap.Pipeline;

namespace NOS.Registration.ContainerConfiguration
{
	public class Commands : Registry
	{
		public Commands()
		{
			For<ICommandInvoker>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<CommandInvoker>();

			For<ICommandFactory>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<CommandFactory>();

			For<ISynchronizer>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<CrossContextSynchronizer>();
		}
	}
}