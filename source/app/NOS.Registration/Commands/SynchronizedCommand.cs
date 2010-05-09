namespace NOS.Registration.Commands
{
	public abstract class SynchronizedCommand<T> : Command<T>
	{
		readonly ISynchronizer _synchronizer;

		protected SynchronizedCommand(ISynchronizer synchronizer)
		{
			_synchronizer = synchronizer;
		}

		protected override ReturnValue Execute(T message)
		{
			return _synchronizer.Lock(() => ExecuteSynchronized(message));
		}

		protected abstract ReturnValue ExecuteSynchronized(T message);
	}
}