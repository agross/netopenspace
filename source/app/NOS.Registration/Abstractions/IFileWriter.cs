namespace NOS.Registration.Abstractions
{
	public interface IFileWriter
	{
		void Write(string path, string content);
	}
}