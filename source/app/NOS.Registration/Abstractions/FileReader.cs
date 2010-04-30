using System.IO;

using ScrewTurn.Wiki;

namespace NOS.Registration.Abstractions
{
	internal class FileReader : IFileReader
	{
		public string Read(string path)
		{
			var provider = Collectors.FilesProviderCollector.GetProvider(Settings.DefaultFilesProvider);

			using (var stream = new MemoryStream())
			{
				var success = provider.RetrieveFile(path, stream, false);
				if (!success)
				{
					throw new ScrewTurnException("Could not read stream from {0}", path);
				}

				return new StreamReader(stream).ReadToEnd();
			}
		}
	}
}