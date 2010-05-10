using NOS.Registration.DataAccess;

using StructureMap.Configuration.DSL;

namespace NOS.Registration.ContainerConfiguration
{
	public class DataAccess : Registry
	{
		public DataAccess()
		{
			ForSingletonOf<IRegistrationRepository>()
				.Use<RegistrationRepository>()
				.Ctor<string>("file").Is(typeof(AutoRegistrationPlugin).FullName + ".Data");
		}
	}
}