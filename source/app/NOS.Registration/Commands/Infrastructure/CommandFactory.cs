using System;
using System.Collections.Generic;
using System.Linq;

using StructureMap;

namespace NOS.Registration.Commands.Infrastructure
{
	public class CommandFactory : ICommandFactory
	{
		static readonly Type GenericHandler = typeof(ICommandMessageHandler<>);
		readonly IContainer _container;

		public CommandFactory(IContainer container)
		{
			_container = container;
		}

		public IEnumerable<ICommandMessageHandler> GetCommands(object commandMessage)
		{
			var commandType = GenericHandler.MakeGenericType(commandMessage.GetType());
			var commands = _container.GetAllInstances(commandType);
			
			return commands.Cast<ICommandMessageHandler>();
		}
	}
}