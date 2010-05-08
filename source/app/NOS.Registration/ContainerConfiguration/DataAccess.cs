using NOS.Registration.DataAccess;

using StructureMap;
using StructureMap.Configuration.DSL;
using StructureMap.Pipeline;

namespace NOS.Registration.ContainerConfiguration
{
	public class DataAccess : Registry
	{
		public DataAccess()
		{
			For<IRegistrationRepository>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<RegistrationRepository>()
				.Ctor<string>("file").Is(typeof(AutoRegistrationPlugin).FullName + ".Data");
		}
	}
}