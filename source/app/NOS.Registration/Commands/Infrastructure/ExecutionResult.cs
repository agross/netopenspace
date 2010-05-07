using System.Collections.Generic;
using System.Linq;

namespace NOS.Registration.Commands.Infrastructure
{
	public class ExecutionResult
	{
		readonly List<string> _messages = new List<string>();
		readonly GenericItemDictionary _returnItems = new GenericItemDictionary();

		public bool Successful
		{
			get { return _messages.Count == 0; }
		}

		public IEnumerable<string> Messages
		{
			get { return _messages; }
		}

		public GenericItemDictionary ReturnItems
		{
			get { return _returnItems; }
		}

		public void Merge(ReturnValue returnObject)
		{
			if (returnObject != null && returnObject.Messages.Any())
			{
				returnObject.Messages.Each(x => _messages.Add(x));
			}

			if (returnObject != null && returnObject.Type != null)
			{
				ReturnItems.Add(returnObject.Type, returnObject.Value);
			}
		}
	}
}