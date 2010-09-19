using ScrewTurn.Wiki;

namespace NOS.Registration
{
	internal class DefaultFileWriter : IFileWriter
	{
		public void Write(string path, string content)
		{
			var provider = Collectors.SettingsProvider;

			provider.SetPluginConfiguration(path, content);
		}
	}
}