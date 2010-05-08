using System.IO;

using NVelocity;
using NVelocity.App;

namespace NOS.Registration.Templating
{
	internal class NVelocityTemplateEngine : ITemplateEngine
	{
		readonly VelocityEngine _engine;

		public NVelocityTemplateEngine()
		{
			_engine = new VelocityEngine();
			_engine.Init();
		}

		public string Format(object item, string template)
		{
			var context = new VelocityContext();
			context.Put("item", item);

			using (StringWriter writer = new StringWriter())
			{
				_engine.Evaluate(context, writer, null, template);

				return writer.ToString();
			}
		}
	}
}