using System;

using NOS.Registration.DataAccess;
using NOS.Registration.Queries;

namespace NOS.Registration.Commands
{
	public class DeactivateUserCommand : SynchronizedCommand<DeactivateUserMessage>
	{
		readonly IRegistrationRepository _registrationRepository;

		public DeactivateUserCommand(IRegistrationRepository registrationRepository,
		                             ISynchronizer synchronizer) : base(synchronizer)
		{
			_registrationRepository = registrationRepository;
		}

		protected override ReturnValue ExecuteSynchronized(DeactivateUserMessage message)
		{
			var user = _registrationRepository.Query(new UserByUserName(message.UserName));
			if (user == null)
			{
				return ReturnValue.Success();
			}

			if (!user.Active)
			{
				return ReturnValue.Success();
			}

			try
			{
				user.Active = false;
				_registrationRepository.Save(user);
			}
			catch (Exception ex)
			{
				ReturnValue.Fail(ex.Message);
			}

			return ReturnValue.Success();
		}
	}

	public class DeactivateUserMessage
	{
		public DeactivateUserMessage(string userName)
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