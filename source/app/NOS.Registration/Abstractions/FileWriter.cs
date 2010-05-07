using ScrewTurn.Wiki;

namespace NOS.Registration.Abstractions
{
	internal class FileWriter : IFileWriter
	{
		public void Write(string path, string content)
		{
			var provider = Collectors.SettingsProvider;

			provider.SetPluginConfiguration(path, content);
		}
	}
}