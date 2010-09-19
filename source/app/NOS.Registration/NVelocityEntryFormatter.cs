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

		public string FormatUserEntry(User user, ISettings settings, string template)
		{
			var context = new VelocityContext();
			context.Put("user", user);
			context.Put("settings", settings);

			using (StringWriter writer = new StringWriter())
			{
				template = PrepareTemplate(template);
				_engine.Evaluate(context, writer, null, template);

				return writer.ToString();
			}
		}

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