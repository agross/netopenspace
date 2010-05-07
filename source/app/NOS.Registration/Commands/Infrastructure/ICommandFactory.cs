using System.Collections.Generic;

namespace NOS.Registration.Commands.Infrastructure
{
	public interface ICommandFactory
	{
		IEnumerable<ICommandMessageHandler> GetCommands(object commandMessage);
	}
}