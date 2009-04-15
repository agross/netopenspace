namespace NOS.Registration
{
	public interface IFileWriter
	{
		void Write(string path, string content);
	}
}