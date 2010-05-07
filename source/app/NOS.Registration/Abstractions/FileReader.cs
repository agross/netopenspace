using ScrewTurn.Wiki;

namespace NOS.Registration.Abstractions
{
	internal class FileReader : IFileReader
	{
		public string Read(string path)
		{
			var provider = Collectors.SettingsProvider;

			return provider.GetPluginConfiguration(path);
		}
	}
}