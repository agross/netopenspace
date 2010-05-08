using System;
using System.Collections.Generic;

namespace NOS.Registration.Commands
{
	public class ReturnValue
	{
		readonly List<string> _messages = new List<string>();

		ReturnValue()
		{
		}

		public Type Type
		{
			get;
			private set;
		}

		public object Value
		{
			get;
			private set;
		}

		public IEnumerable<string> Messages
		{
			get { return _messages; }
		}

		public ReturnValue SetValue<T>(T input)
		{
			Type = typeof(T);
			Value = input;
			return this;
		}

		void AddMessage(string message)
		{
			_messages.Add(message);
		}

		public static ReturnValue Success()
		{
			return new ReturnValue();
		}

		public static ReturnValue Fail(string message)
		{
			return Fail(new[] { message });
		}

		public static ReturnValue Fail(IEnumerable<string> messages)
		{
			var returnValue = new ReturnValue();
			messages.Each(returnValue.AddMessage);
			return returnValue;
		}
	}
}