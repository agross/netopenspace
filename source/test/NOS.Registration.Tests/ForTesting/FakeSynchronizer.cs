using System;

namespace NOS.Registration.Tests.ForTesting
{
	public class FakeSynchronizer:ISynchronizer
	{
		public void Lock(Action synchronizedAction)
		{
			synchronizedAction();
		}
	}
}