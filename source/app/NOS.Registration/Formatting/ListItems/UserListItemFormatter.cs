using NOS.Registration.Abstractions;
using NOS.Registration.Model;
using NOS.Registration.Templating;

namespace NOS.Registration.Formatting.ListItems
{
	public class UserListItemFormatter : IListItemFormatter<User>
	{
		readonly IEntryFormatter _entryFormatter;
		readonly IPluginConfiguration _configuration;

		public UserListItemFormatter(IEntryFormatter entryFormatter, IPluginConfiguration configuration)
		{
			_entryFormatter = entryFormatter;
			_configuration = configuration;
		}

		public string FormatItem(User item)
		{
			return _entryFormatter.FormatUserEntry(item, _configuration.EntryTemplate);
		}
	}
}