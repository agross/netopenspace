using System.Linq;

using Machine.Specifications;

using NOS.Registration.Commands;
using NOS.Registration.Commands.Infrastructure;

using Rhino.Mocks;

namespace NOS.Registration.Tests.Commands.Infrastructure
{
	internal class Message
	{
	}

	[Subject(typeof(CommandInvoker))]
	public class When_a_command_message_is_processed
	{
		static CommandInvoker Invoker;
		static Message Message;
		static ExecutionResult Result;
		static ICommandFactory Factory;
		static ICommandMessageHandler[] Handlers;

		Establish context = () =>
			{
				Message = new Message();

				Handlers = new[]
				           {
				           	MockRepository.GenerateStub<ICommandMessageHandler>(),
				           	MockRepository.GenerateStub<ICommandMessageHandler>()
				           };

				Factory = MockRepository.GenerateStub<ICommandFactory>();
				Factory
					.Stub(x => x.GetCommands(Message))
					.Return(Handlers);

				Invoker = new CommandInvoker(Factory);
			};

		Because of = () => { Result = Invoker.Process(Message); };

		It should_execute_all_message_handlers =
			() => Handlers.Each(x => x.AssertWasCalled(y => y.Execute(Message)));
		
		It should_return_a_result =
			() => Result.ShouldNotBeNull();
		
		It should_succeed =
			() => Result.Successful.ShouldBeTrue();
		
		It should_return_a_result_without_messages =
			() => Result.Messages.ShouldBeEmpty();
		
		It should_return_a_result_without_return_items =
			() => Result.ReturnItems.ShouldBeEmpty();
	}
	
	[Subject(typeof(CommandInvoker))]
	public class When_a_command_message_is_processed_and_message_handlers_return_failing_results
	{
		static CommandInvoker Invoker;
		static Message Message;
		static ExecutionResult Result;
		static ICommandFactory Factory;
		static ICommandMessageHandler[] Handlers;

		Establish context = () =>
			{
				Message = new Message();

				var handler1 = MockRepository.GenerateStub<ICommandMessageHandler>();
				handler1
					.Stub(x => x.Execute(Message))
					.Return(ReturnValue.Fail("error 1").SetValue(42));

				var handler2 = MockRepository.GenerateStub<ICommandMessageHandler>();
				handler2
					.Stub(x => x.Execute(Message))
					.Return(ReturnValue.Fail("error 2"));

				Handlers = new[]
				           {
				           	handler1,
				           	handler2
				           };

				Factory = MockRepository.GenerateStub<ICommandFactory>();
				Factory
					.Stub(x => x.GetCommands(Message))
					.Return(Handlers);

				Invoker = new CommandInvoker(Factory);
			};

		Because of = () => { Result = Invoker.Process(Message); };

		It should_fail =
			() => Result.Successful.ShouldBeFalse();
	
		It should_merge_all_messages =
			() => Result.Messages.Count().ShouldEqual(2);

		It should_be_able_to_pull_out_value_one =
			() => Result.ReturnItems.Get<int>().ShouldEqual(42);
	}
	
	[Subject(typeof(CommandInvoker))]
	public class When_a_command_message_is_processed_and_message_handlers_return_values
	{
		static CommandInvoker Invoker;
		static Message Message;
		static ExecutionResult Result;
		static ICommandFactory Factory;
		static ICommandMessageHandler[] Handlers;

		Establish context = () =>
			{
				Message = new Message();

				var handler1 = MockRepository.GenerateStub<ICommandMessageHandler>();
				handler1
					.Stub(x => x.Execute(Message))
					.Return(ReturnValue.Success().SetValue("hello, world"));

				var handler2 = MockRepository.GenerateStub<ICommandMessageHandler>();
				handler2
					.Stub(x => x.Execute(Message))
					.Return(ReturnValue.Success().SetValue(42));

				Handlers = new[]
				           {
				           	handler1,
				           	handler2
				           };

				Factory = MockRepository.GenerateStub<ICommandFactory>();
				Factory
					.Stub(x => x.GetCommands(Message))
					.Return(Handlers);

				Invoker = new CommandInvoker(Factory);
			};

		Because of = () => { Result = Invoker.Process(Message); };

		It should_succeed =
			() => Result.Successful.ShouldBeTrue();
	
		It should_be_able_to_pull_out_value_one =
			() => Result.ReturnItems.Get<int>().ShouldEqual(42);
		
		It should_be_able_to_pull_out_value_two =
			() => Result.ReturnItems.Get<string>().ShouldEqual("hello, world");
	}
}