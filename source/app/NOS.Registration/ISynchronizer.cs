using System;

namespace NOS.Registration
{
	public interface ISynchronizer
	{
		void Lock(Action synchronizedAction);
	}
}