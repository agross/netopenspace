using System;
using System.Security;
using System.Security.Cryptography;

using NOS.Registration.Abstractions;

namespace NOS.Registration.Security
{
	public class AntiCsrf : IAntiCsrf
	{
		readonly ILogger _logger;
		readonly ISession _session;
		readonly IUserContext _userContext;

		public AntiCsrf(ILogger logger, ISession session, IUserContext userContext)
		{
			_logger = logger;
			_session = session;
			_userContext = userContext;
		}

		public string GenerateToken()
		{
			var token = Convert.ToBase64String(CreateRandomBytes(50));
			_session.CsrfToken = token;
			return _session.CsrfToken;
		}

		public void Verify(string token)
		{
			if (SessionTokenIsEmpty() || FormTokenIsEmpty(token) || TokenDoNotMatch(token))
			{
				_logger.Warning(String.Format("CSRF token verification failed. Should be {0}, was {1}", _session.CsrfToken, token),
				                _userContext.UserName);

				_session.EndSessionAndEnforceLogin();
				throw new SecurityException();
			}
		}

		static bool FormTokenIsEmpty(string token)
		{
			return token.IsNullOrEmpty();
		}

		bool SessionTokenIsEmpty()
		{
			return _session.CsrfToken.IsNullOrEmpty();
		}

		bool TokenDoNotMatch(string token)
		{
			return _session.CsrfToken != token;
		}

		static byte[] CreateRandomBytes(int length)
		{
			byte[] r = new byte[length];
			new RNGCryptoServiceProvider().GetBytes(r);
			return r;
		}
	}
}