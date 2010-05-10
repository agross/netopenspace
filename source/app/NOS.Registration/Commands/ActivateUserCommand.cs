using System;

using NOS.Registration.Abstractions;
using NOS.Registration.DataAccess;
using NOS.Registration.Queries;

namespace NOS.Registration.Commands
{
	public class ActivateUserCommand : SynchronizedCommand<ActivateUserMessage>
	{
		readonly INotificationSender _notificationSender;
		readonly IRegistrationRepository _registrationRepository;
		readonly IWikiSettings _settings;

		public ActivateUserCommand(IRegistrationRepository registrationRepository,
		                           ISynchronizer synchronizer,
		                           INotificationSender notificationSender,
		                           IWikiSettings settings) : base(synchronizer)
		{
			_registrationRepository = registrationRepository;
			_notificationSender = notificationSender;
			_settings = settings;

			SuccessNotificationTemplate = "AutoRegistrationSuccessfulMessage";
			FailureNotificationTemplate = "AutoRegistrationFailedMessage";
		}

		public string SuccessNotificationTemplate
		{
			get;
			set;
		}

		public string FailureNotificationTemplate
		{
			get;
			set;
		}

		protected override ReturnValue ExecuteSynchronized(ActivateUserMessage message)
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
				_notificationSender.SendMessage(message.UserName,
												message.Email,
												"AutoRegistration",
												SuccessNotificationTemplate);

				return ReturnValue.Success();
			}
			catch (Exception ex)
			{
				_notificationSender.SendMessage(message.UserName,
												_settings.ContactEmail,
												"AutoRegistration",
												FailureNotificationTemplate);
				_notificationSender.SendMessage(message.UserName,
												message.Email,
												"AutoRegistration",
												FailureNotificationTemplate);

				return ReturnValue.Fail(ex.Message);
			}
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