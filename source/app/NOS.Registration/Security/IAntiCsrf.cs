namespace NOS.Registration.Security
{
	public interface IAntiCsrf
	{
		string GenerateToken();
		void Verify(string token);
	}
}