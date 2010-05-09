using System;

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
			return _synchronizer.Lock(() =>
				{
					var user = _registrationRepository.Query(new UserByUserName(message.UserName));
					if (user == null)
					{
						return ReturnValue.Success();
					}

					if (user.Active)
					{
						return ReturnValue.Success();
					}

					try
					{
						user.Active = true;
						_registrationRepository.Save(user);
						_notificationSender.SendMessage(message.UserName, message.Email, "AutoRegistration", false);
						
						return ReturnValue.Success();
					}
					catch (Exception ex)
					{
						_notificationSender.SendMessage(message.UserName, _settingsAccessor.ContactEmail, "AutoRegistration", true);
						_notificationSender.SendMessage(message.UserName, message.Email, "AutoRegistration", true);
						
						return ReturnValue.Fail(ex.Message);
					}
				});
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