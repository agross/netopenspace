using System;

using NOS.Registration.Commands;
using NOS.Registration.Commands.Infrastructure;

namespace NOS.Registration.UI
{
	public class AutoRegistrationPresenter
	{
		readonly ICommandInvoker _commandInvoker;
		readonly IAutoRegistrationView _view;

		public AutoRegistrationPresenter(IAutoRegistrationView view,
		                                 ICommandInvoker commandInvoker)
		{
			_view = view;
			_commandInvoker = commandInvoker;

			view.UserCreated += View_UserCreated;
		}

		void View_UserCreated(object sender, EventArgs e)
		{
			_commandInvoker.Process(new CreateUserMessage(_view));
		}
	}
}