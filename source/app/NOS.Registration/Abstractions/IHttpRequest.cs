namespace NOS.Registration.Abstractions
{
	public interface IHttpRequest
	{
		string GetFormValue(string key);
	}
}