using ScrewTurn.Wiki;

namespace NOS.Registration
{
	internal class DefaultFileReader : IFileReader
	{
		#region IFileReader Members
		public string Read(string path)
		{
			return Tools.LoadFile(path);
		}
		#endregion
	}
}