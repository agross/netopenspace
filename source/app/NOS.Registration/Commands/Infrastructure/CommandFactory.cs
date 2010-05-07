using System;
using System.Collections.Generic;
using System.Linq;

using StructureMap;

namespace NOS.Registration.Commands.Infrastructure
{
	public class CommandFactory : ICommandFactory
	{
		static readonly Type GenericHandler = typeof(Command<>);
		readonly IContainer _container;

		public CommandFactory(IContainer container)
		{
			_container = container;
		}

		public IEnumerable<ICommandMessageHandler> GetCommands(object commandMessage)
		{
			Type concreteCommandType = GenericHandler.MakeGenericType(commandMessage.GetType());

			var commands = _container.GetAllInstances(concreteCommandType).Cast<ICommandMessageHandler>();
			return commands;
		}
	}
}