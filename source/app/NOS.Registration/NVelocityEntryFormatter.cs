using System.IO;

using NVelocity;
using NVelocity.App;

namespace NOS.Registration
{
	internal class NVelocityEntryFormatter : IEntryFormatter
	{
		readonly VelocityEngine _engine;

		public NVelocityEntryFormatter()
		{
			_engine = new VelocityEngine();
			_engine.Init();
		}

		#region IEntryFormatter Members
		public string FormatUserEntry(User user, string entryTemplate)
		{
			var context = new VelocityContext();
			context.Put("user", user);

			using (StringWriter writer = new StringWriter())
			{
				entryTemplate = PrepareTemplate(entryTemplate);
				_engine.Evaluate(context, writer, null, entryTemplate);

				return writer.ToString();
			}
		}
		#endregion

		static string PrepareTemplate(string value)
		{
			if (value != null)
			{
				return value.Replace("\\n", "\n");
			}

			return value;
		}
	}
}