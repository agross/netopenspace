using ScrewTurn.Wiki;

namespace NOS.Registration
{
	internal class DefaultFileReader : IFileReader
	{
		public string Read(string path)
		{
			var provider = Collectors.SettingsProvider;

			return provider.GetPluginConfiguration(path);
		}
	}
}