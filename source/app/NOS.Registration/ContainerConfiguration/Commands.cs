using NOS.Registration.Commands;
using NOS.Registration.Commands.Infrastructure;

using StructureMap.Configuration.DSL;

namespace NOS.Registration.ContainerConfiguration
{
	public class Commands : Registry
	{
		public Commands()
		{
			ForSingletonOf<ICommandInvoker>().Use<CommandInvoker>();
			ForSingletonOf<ICommandFactory>().Use<CommandFactory>();
			ForSingletonOf<ISynchronizer>().Use<CrossContextSynchronizer>();

			Scan(x =>
				{
					x.TheCallingAssembly();
					x.AddAllTypesOf(typeof(Command<>));
					x.WithDefaultConventions();
				});
		}
	}
}