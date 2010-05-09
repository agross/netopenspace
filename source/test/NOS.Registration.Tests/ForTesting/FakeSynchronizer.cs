using System;

namespace NOS.Registration.Tests.ForTesting
{
	public class FakeSynchronizer : ISynchronizer
	{
		public void Lock(Action synchronizedAction)
		{
			Lock<object>(() =>
				{
					synchronizedAction();
					return null;
				});
		}

		public T Lock<T>(Func<T> synchronizedAction)
		{
			return synchronizedAction();
		}
	}
}