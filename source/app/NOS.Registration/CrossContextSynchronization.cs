using System;
using System.Threading;

namespace NOS.Registration
{
	internal class CrossContextSynchronizer : ISynchronizer, IDisposable
	{
		readonly Mutex _lock = new Mutex(false, "ScrewTurn Wiki AutoRegistration Synchronization");
		bool _disposed;

		public void Dispose()
		{
			Dispose(true);
			GC.SuppressFinalize(this);
		}

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
			try
			{
				_lock.WaitOne();
				return synchronizedAction();
			}
			finally
			{
				_lock.ReleaseMutex();
			}
		}

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