using System;

using NOS.Registration.DataAccess;
using NOS.Registration.Queries;

namespace NOS.Registration.Commands
{
	public class DeleteUserCommand : SynchronizedCommand<DeleteUserMessage>
	{
		readonly IRegistrationRepository _registrationRepository;

		public DeleteUserCommand(IRegistrationRepository registrationRepository,
		                         ISynchronizer synchronizer) : base(synchronizer)
		{
			_registrationRepository = registrationRepository;
		}

		protected override ReturnValue ExecuteSynchronized(DeleteUserMessage message)
		{
			var user = _registrationRepository.Query(new UserByUserName(message.UserName));
			if (user == null)
			{
				return ReturnValue.Success();
			}

			try
			{
				_registrationRepository.Delete(user);

				return ReturnValue.Success();
			}
			catch (Exception ex)
			{
				return ReturnValue.Fail(ex.Message);
			}
		}
	}

	public class DeleteUserMessage
	{
		public DeleteUserMessage(string userName)
		{
			UserName = userName;
		}

		public string UserName
		{
			get;
			private set;
		}
	}
}