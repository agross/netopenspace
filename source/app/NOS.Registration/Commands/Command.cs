namespace NOS.Registration.Commands
{
	public interface ICommandMessageHandler
	{
		ReturnValue Execute(object message);
	}

	public interface ICommandMessageHandler<T> : ICommandMessageHandler
	{
	}

	public abstract class Command<T> : ICommandMessageHandler<T>
	{
		public ReturnValue Execute(object message)
		{
			return Execute((T) message);
		}

		protected abstract ReturnValue Execute(T message);
	}
}