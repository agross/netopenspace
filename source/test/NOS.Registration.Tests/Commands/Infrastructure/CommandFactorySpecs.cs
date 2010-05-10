using System;
using System.Collections.Generic;
using System.Linq;

using Machine.Specifications;

using NOS.Registration.Commands;
using NOS.Registration.Commands.Infrastructure;

namespace NOS.Registration.Tests.Commands.Infrastructure
{
	[Subject(typeof(CommandFactory))]
	public class When_the_handlers_for_a_command_are_retrieved
	{
		static CommandFactory Factory;
		static MatchingMessage Message;
		static IEnumerable<ICommandMessageHandler> Handlers;

		Establish context = () =>
			{
				var container = new StructureMap.Container();
				container.Configure(x =>
					{
						x.For<ICommandMessageHandler<MatchingMessage>>()
							.Use<MatchingHandler1>();

						x.For<ICommandMessageHandler<MatchingMessage>>()
							.Add<MatchingHandler2>();

						x.For<ICommandMessageHandler<OtherMessage>>()
							.Use<OtherHandler>();
					});

				Factory = new CommandFactory(container);
				Message = new MatchingMessage();
			};

		Because of = () => { Handlers = Factory.GetCommands(Message); };

		It should_create_the_first_matching_handler =
			() => Handlers.First().ShouldBeOfType<MatchingHandler1>();
		
		It should_create_the_second_matching_handler =
			() => Handlers.Skip(1).First().ShouldBeOfType<MatchingHandler2>();
		
		It should_create_no_other_handlers =
			() => Handlers.Count().ShouldEqual(2);
	}

	public class MatchingMessage
	{
	}

	public class MatchingHandler1 : Command<MatchingMessage>
	{
		protected override ReturnValue Execute(MatchingMessage message)
		{
			throw new NotImplementedException();
		}
	}

	public class MatchingHandler2 : Command<MatchingMessage>
	{
		protected override ReturnValue Execute(MatchingMessage message)
		{
			throw new NotImplementedException();
		}
	}

	public class OtherMessage
	{
	}

	public class OtherHandler : Command<OtherMessage>
	{
		protected override ReturnValue Execute(OtherMessage message)
		{
			throw new NotImplementedException();
		}
	}
}