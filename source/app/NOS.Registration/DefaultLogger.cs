using ScrewTurn.Wiki;
using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration
{
	internal class DefaultLogger : ILogger
	{
		#region ILogger Members
		public void Error(string message, string username)
		{
			Log.LogEntry(Tools.EscapeString(message), EntryType.Error, Tools.EscapeString(username));
		}

		public void Info(string message, string username)
		{
			Log.LogEntry(Tools.EscapeString(message), EntryType.General, Tools.EscapeString(username));
		}

		public void Warning(string message, string username)
		{
			Log.LogEntry(Tools.EscapeString(message), EntryType.Warning, Tools.EscapeString(username));
		}
		#endregion
	}
}