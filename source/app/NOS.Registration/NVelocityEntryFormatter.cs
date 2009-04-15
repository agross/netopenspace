using System.IO;

using NVelocity;
using NVelocity.App;

namespace NOS.Registration
{
	internal class NVelocityEntryFormatter : IEntryFormatter
	{
		readonly VelocityEngine _engine;

		string _entryTemplate;

		public NVelocityEntryFormatter()
		{
			_engine = new VelocityEngine();
			_engine.Init();
		}

		#region IEntryFormatter Members
		public string EntryTemplate
		{
			get { return _entryTemplate; }
			set
			{
				if (value != null)
				{
					value = value.Replace("\\n", "\n");
				}
				_entryTemplate = value;
			}
		}

		public string FormatUserEntry(User user)
		{
			var context = new VelocityContext();
			context.Put("user", user);

			using (StringWriter writer = new StringWriter())
			{
				_engine.Evaluate(context, writer, null, EntryTemplate);

				return writer.ToString();
			}
		}
		#endregion
	}
}