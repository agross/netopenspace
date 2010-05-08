using System;

namespace NOS.Registration.Tests
{
	public class FakeSynchronizer:ISynchronizer
	{
		public void Lock(Action synchronizedAction)
		{
			synchronizedAction();
		}
	}
}