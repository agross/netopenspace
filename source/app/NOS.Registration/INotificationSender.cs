using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration
{
	public interface INotificationSender
	{
		void SendMessage(string userName, string recipient, string subject, bool failed);
		void Configure(IHostV30 host, IFileReader fileReader, ISettings settings);
	}
}