using System;
using System.Threading;

namespace NOS.Registration
{
	internal class CrossContextSynchronizer : ISynchronizer, IDisposable
	{
		readonly Mutex _lock = new Mutex(false, "ScrewTurn Wiki AutoRegistration Synchronization");
		bool _disposed;

		#region IDisposable Members
		public void Dispose()
		{
			Dispose(true);
			GC.SuppressFinalize(this);
		}
		#endregion

		#region ISynchronizer Members
		public void Lock(Action synchronizedAction)
		{
			try
			{
				_lock.WaitOne();
				synchronizedAction();
			}
			finally
			{
				_lock.ReleaseMutex();
			}
		}
		#endregion

		~CrossContextSynchronizer()
		{
			Dispose(false);
		}

		protected virtual void Dispose(bool disposing)
		{
			if (_disposed)
			{
				return;
			}

			if (disposing)
			{
				// Dispose managed resources.
				_lock.Close();
			}

			// Dispose unmanaged resources.
			_disposed = true;
		}
	}
}