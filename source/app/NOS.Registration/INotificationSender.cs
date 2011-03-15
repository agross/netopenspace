using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration
{
	public interface INotificationSender
	{
		void SendMessage(string recipient, string subject, string message);
		void Configure(IHostV30 host, ISettings settings);
	}
}