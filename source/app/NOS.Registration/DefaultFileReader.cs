using ScrewTurn.Wiki;

namespace NOS.Registration
{
	internal class DefaultFileReader : IFileReader
	{
		#region IFileReader Members
		public string Read(string path)
		{
			var provider = Collectors.SettingsProvider;

			return provider.GetPluginConfiguration(path);
		}
		#endregion
	}
}