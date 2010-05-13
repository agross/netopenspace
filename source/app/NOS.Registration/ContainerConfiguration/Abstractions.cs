using System.Web;

using NOS.Registration.Abstractions;

using StructureMap.Configuration.DSL;

using HttpRequest = NOS.Registration.Abstractions.HttpRequest;

namespace NOS.Registration.ContainerConfiguration
{
	public class Abstractions : Registry
	{
		public Abstractions()
		{
			ForSingletonOf<ILogger>().Use<Logger>();

			ForSingletonOf<IFileReader>().Use<FileReader>();
			ForSingletonOf<IFileWriter>().Use<FileWriter>();

			ForSingletonOf<IWikiSettings>().Use<WikiSettings>();

			ForSingletonOf<INotificationSender>().Use<EmailNotificationSender>();

			ForSingletonOf<IPluginConfiguration>().Use<DefaultPluginConfiguration>();

			For<IHttpRequest>()
				.HybridHttpOrThreadLocalScoped()
				.Use<HttpRequest>()
				.OnCreation(x => x.Connect(HttpContext.Current));
			
			For<ISession>()
				.HybridHttpOrThreadLocalScoped()
				.Use<Session>();
			
			For<IUserContext>()
				.HybridHttpOrThreadLocalScoped()
				.Use<UserContext>();
		}
	}
}