using NOS.Registration.Security;

using StructureMap.Configuration.DSL;

namespace NOS.Registration.ContainerConfiguration
{
	public class Security : Registry
	{
		public Security()
		{
			ForSingletonOf<IAntiCsrf>()
				.Use<AntiCsrf>();
		}
	}
}