namespace NOS.Registration.Commands
{
	public interface ICommandMessageHandler<TCommand, TResult>
	{
		TResult Execute(TCommand message);
	}

	public interface ICommandMessageHandler : ICommandMessageHandler<object, ReturnValue>
	{
	}

	public abstract class Command<T> : ICommandMessageHandler
	{
		public ReturnValue Execute(object message)
		{
			return Execute((T) message);
		}

		protected abstract ReturnValue Execute(T message);
	}
}