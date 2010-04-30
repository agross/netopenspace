using System.IO;

using ScrewTurn.Wiki;

namespace NOS.Registration
{
	internal class DefaultFileWriter : IFileWriter
	{
		public void Write(string path, string content)
		{
			var provider = Collectors.FilesProviderCollector.GetProvider(Settings.DefaultFilesProvider);

			using (var stream = new MemoryStream())
			{
				var success = provider.StoreFile(path, stream, true);
				if (!success)
				{
					throw new ScrewTurnException("Could not write stream to {0}", path);
				}
			}
		}
	}
}