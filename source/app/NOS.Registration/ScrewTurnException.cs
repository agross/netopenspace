using System;
using System.Runtime.Serialization;

namespace NOS.Registration
{
	[Serializable]
	internal class ScrewTurnException : Exception
	{
		public ScrewTurnException(string message, params object[] args) : base(String.Format(message, args))
		{
		}

		public ScrewTurnException(string message) : base(message)
		{
		}

		protected ScrewTurnException(
			SerializationInfo info,
			StreamingContext context) : base(info, context)
		{
		}
	}
}