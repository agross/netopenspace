using System;
using System.Web.UI.WebControls;

namespace NOS.Registration
{
	public class AutoRegistrationPresenter
	{
		readonly ILogger _logger;
		readonly IRegistrationRepository _repository;
		readonly IAutoRegistrationView _view;

		public AutoRegistrationPresenter(IAutoRegistrationView view)
			: this(view, new RegistrationRepository(), new DefaultLogger())
		{
		}

		public AutoRegistrationPresenter(IAutoRegistrationView view, IRegistrationRepository repository, ILogger logger)
		{
			_view = view;
			_repository = repository;
			_logger = logger;

			view.UserCreated += View_UserCreated;
			view.ValidateInvoiceAddress += ValidateInvoiceAddress;
		}

		void View_UserCreated(object sender, EventArgs e)
		{
			if (!_view.AutoRegisterUser)
			{
				_logger.Info("User opted-out of auto registration", _view.UserName);
				return;
			}

			try
			{
				var user = new User(_view.UserName)
				           {
				           	Data =
				           		{
				           			Xing = _view.Xing,
				           			Twitter = _view.Twitter,
				           			Name = _view.Name,
				           			Blog = _view.Blog,
				           			Email = _view.Email,
				           			Picture = _view.Picture,
				           			Sponsoring = _view.Sponsoring
				           		}
				           };

				_repository.Save(user);
				_logger.Info("Saved registration data", _view.UserName);
			}
			catch (Exception ex)
			{
				_logger.Error(String.Format("Saving registration data failed: {0}", ex), _view.UserName);
			}
		}

		void ValidateInvoiceAddress(object sender, ServerValidateEventArgs e)
		{
			if (!_view.AutoRegisterUser)
			{
				e.IsValid = true;
				return;
			}

			if (_view.Sponsoring > 0)
			{
				e.IsValid = _view.InvoiceAddress != null && _view.InvoiceAddress.Length > 0;
			}
		}
	}
}