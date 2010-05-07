namespace NOS.Registration.Commands.Infrastructure
{
	public interface ICommandInvoker
	{
		ExecutionResult Process(object commandMessage);
	}
}