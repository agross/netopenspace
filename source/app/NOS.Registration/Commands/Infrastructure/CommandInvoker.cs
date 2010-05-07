using System.Linq;

namespace NOS.Registration.Commands.Infrastructure
{
	public class CommandInvoker : ICommandInvoker
	{
		readonly ICommandFactory _handerFactory;

		public CommandInvoker(ICommandFactory handerFactory)
		{
			_handerFactory = handerFactory;
		}

		public ExecutionResult Process(object commandMessage)
		{
			var executionResult = new ExecutionResult();

			var handlers = _handerFactory.GetCommands(commandMessage);
			handlers
				.Select(x => x.Execute(commandMessage))
				.Where(x => x != null)
				.Each(executionResult.Merge);

			return executionResult;
		}
	}
}