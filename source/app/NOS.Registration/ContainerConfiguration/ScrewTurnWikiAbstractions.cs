using NOS.Registration.Abstractions;

using StructureMap.Configuration.DSL;

namespace NOS.Registration.ContainerConfiguration
{
	public class ScrewTurnWikiAbstractions : Registry
	{
		public ScrewTurnWikiAbstractions()
		{
			ForSingletonOf<ILogger>().Use<Logger>();

			ForSingletonOf<IFileReader>().Use<FileReader>();
			ForSingletonOf<IFileWriter>().Use<FileWriter>();

			ForSingletonOf<IWikiSettings>().Use<WikiSettings>();

			ForSingletonOf<INotificationSender>().Use<EmailNotificationSender>();

			ForSingletonOf<IPluginConfiguration>().Use<DefaultPluginConfiguration>();
		}
	}
}