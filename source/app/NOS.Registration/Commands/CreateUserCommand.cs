using System;

using NOS.Registration.Abstractions;
using NOS.Registration.DataAccess;
using NOS.Registration.Model;
using NOS.Registration.UI;

namespace NOS.Registration.Commands
{
	public class CreateUserCommand : Command<CreateUserMessage>
	{
		readonly IRegistrationRepository _registrationRepository;
		readonly ILogger _logger;

		public CreateUserCommand(ILogger logger, IRegistrationRepository registrationRepository)
		{
			_registrationRepository = registrationRepository;
			_logger = logger;
		}

		protected override ReturnValue Execute(CreateUserMessage message)
		{
			if (!message.View.AutoRegisterUser)
			{
				_logger.Info("User opted out of auto registration", message.View.UserName);
				return ReturnValue.Success();
			}

			try
			{
				var user = new User(message.View.UserName)
				{
					Data =
					{
						Xing = message.View.Xing,
						Twitter = message.View.Twitter,
						Name = message.View.Name,
						Blog = message.View.Blog,
						Email = message.View.Email,
						Picture = message.View.Picture,
						Sponsoring = message.View.Sponsoring
					}
				};

				_registrationRepository.Save(user);

				_logger.Info("Saved registration data", message.View.UserName);
			}
			catch (Exception ex)
			{
				var error = String.Format("Saving registration data failed: {0}", ex);
				_logger.Error(error, message.View.UserName);
				
				return ReturnValue.Fail(error);
			}
			
			return ReturnValue.Success();
		}
	}

	public class CreateUserMessage
	{
		public CreateUserMessage(IAutoRegistrationView view)
		{
			View = view;
		}

		public IAutoRegistrationView View
		{
			get;
			private set;
		}
	}
}