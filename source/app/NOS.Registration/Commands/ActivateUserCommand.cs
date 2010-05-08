using NOS.Registration.Abstractions;
using NOS.Registration.DataAccess;
using NOS.Registration.Queries;

using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration.Commands
{
	internal class ActivateUserCommand : Command<ActivateUserMessage>
	{
		readonly INotificationSender _notificationSender;
		readonly IRegistrationRepository _registrationRepository;
		readonly ISettingsAccessor _settingsAccessor;
		readonly ISynchronizer _synchronizer;

		public ActivateUserCommand(IRegistrationRepository registrationRepository,
		                           ISynchronizer synchronizer,
		                           INotificationSender notificationSender,
		                           ISettingsAccessor settingsAccessor)
		{
			_registrationRepository = registrationRepository;
			_synchronizer = synchronizer;
			_notificationSender = notificationSender;
			_settingsAccessor = settingsAccessor;
		}

		protected override ReturnValue Execute(ActivateUserMessage message)
		{
			_synchronizer.Lock(() =>
				{
					var failed = false;
					try
					{
						var user = _registrationRepository.Query(new UserByUserName(message.User.Username));
						if (user == null)
						{
							return;
						}

						// TODO
					}
					finally
					{
						_notificationSender.SendMessage(message.User.Username, message.User.Email, "AutoRegistration", failed);
						if (failed)
						{
							_notificationSender.SendMessage(message.User.Username, _settingsAccessor.ContactEmail, "AutoRegistration", true);
						}
					}
				});

			return ReturnValue.Success();
		}
	}

	public class ActivateUserMessage
	{
		public ActivateUserMessage(UserInfo user)
		{
			User = user;
		}

		public UserInfo User
		{
			get;
			private set;
		}
	}
}