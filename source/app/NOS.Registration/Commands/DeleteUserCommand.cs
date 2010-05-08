using NOS.Registration.DataAccess;
using NOS.Registration.Queries;

using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration.Commands
{
	public class DeleteUserCommand : Command<DeleteUserMessage>
	{
		readonly IRegistrationRepository _registrationRepository;
		readonly ISynchronizer _synchronizer;

		public DeleteUserCommand(IRegistrationRepository registrationRepository,
		                         ISynchronizer synchronizer)
		{
			_registrationRepository = registrationRepository;
			_synchronizer = synchronizer;
		}

		protected override ReturnValue Execute(DeleteUserMessage message)
		{
			_synchronizer.Lock(() =>
				{
					var user = _registrationRepository.Query(new UserByUserName(message.User.Username));
					if (user == null)
					{
						return;
					}

					_registrationRepository.Delete(user.UserName);
				});

			return ReturnValue.Success();
		}
	}

	public class DeleteUserMessage
	{
		public DeleteUserMessage(UserInfo user)
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