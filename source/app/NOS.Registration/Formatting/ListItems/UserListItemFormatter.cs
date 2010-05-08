using NOS.Registration.Abstractions;
using NOS.Registration.Model;
using NOS.Registration.Templating;

namespace NOS.Registration.Formatting.ListItems
{
	public class UserListItemFormatter : IListItemFormatter<User>
	{
		readonly ITemplateEngine _templateEngine;
		readonly IPluginConfiguration _configuration;

		public UserListItemFormatter(ITemplateEngine templateEngine, IPluginConfiguration configuration)
		{
			_templateEngine = templateEngine;
			_configuration = configuration;
		}

		public string FormatItem(User item)
		{
			return _templateEngine.Format(item, _configuration.EntryTemplate);
		}
	}
}