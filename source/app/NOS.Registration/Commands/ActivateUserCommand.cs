using NOS.Registration.Abstractions;
using NOS.Registration.DataAccess;
using NOS.Registration.Queries;

namespace NOS.Registration.Commands
{
	public class ActivateUserCommand : Command<ActivateUserMessage>
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
						var user = _registrationRepository.Query(new UserByUserName(message.UserName));
						if (user == null)
						{
							return;
						}

						user.Active = true;

						// TODO
					}
					finally
					{
						_notificationSender.SendMessage(message.UserName, message.Email, "AutoRegistration", failed);
						if (failed)
						{
							_notificationSender.SendMessage(message.UserName, _settingsAccessor.ContactEmail, "AutoRegistration", true);
						}
					}
				});

			return ReturnValue.Success();
		}
	}

	public class ActivateUserMessage
	{
		public ActivateUserMessage(string userName, string email)
		{
			UserName = userName;
			Email = email;
		}

		public string UserName
		{
			get;
			private set;
		}

		public string Email
		{
			get;
			private set;
		}
	}
}