using System;

namespace NOS.Registration
{
	public class AutoRegistrationPresenter
	{
		readonly IRegistrationRepository _repository;
		readonly ILogger _logger;
		readonly IAutoRegistrationView _view;

		public AutoRegistrationPresenter(IAutoRegistrationView view) : this(view, new RegistrationRepository(), new DefaultLogger())
		{
		}

		public AutoRegistrationPresenter(IAutoRegistrationView view, IRegistrationRepository repository, ILogger logger)
		{
			_view = view;
			_repository = repository;
			_logger = logger;

			view.UserCreated += View_UserCreated;
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
	}
}