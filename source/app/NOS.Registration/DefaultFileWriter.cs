using ScrewTurn.Wiki;

namespace NOS.Registration
{
	internal class DefaultFileWriter : IFileWriter
	{
		#region IFileWriter Members
		public void Write(string path, string content)
		{
			var provider = Collectors.SettingsProvider;

			provider.SetPluginConfiguration(path, content);
		}
		#endregion
	}
}