namespace NOS.Registration.Templating
{
	public interface ITemplateEngine
	{
		string Format(object item, string template);
	}
}