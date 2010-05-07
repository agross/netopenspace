using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Serialization;

using NOS.Registration.Abstractions;
using NOS.Registration.Model;

namespace NOS.Registration
{
	internal class RegistrationRepository : IRegistrationRepository
	{
		readonly string _file;
		readonly IFileReader _reader;
		readonly JavaScriptSerializer _serializer;
		readonly ISynchronizer _synchronizer;
		readonly IFileWriter _writer;

		public RegistrationRepository(string file, ISynchronizer synchronizer, IFileReader reader, IFileWriter writer)
		{
			_synchronizer = synchronizer;
			_reader = reader;
			_writer = writer;

			_serializer = new JavaScriptSerializer();
			_file = file;
		}

		public void Save(User user)
		{
			_synchronizer.Lock(() =>
				{
					var allUsers = LoadDocument().ToList();
					allUsers.Add(user);

					string serialized = _serializer.Serialize(allUsers);
					_writer.Write(_file, serialized);
				});
		}

		public void Delete(string userName)
		{
			_synchronizer.Lock(() =>
				{
					var allUsers = LoadDocument().ToList();
					var toRemove = allUsers.Where(x => x.UserName.Equals(userName, StringComparison.OrdinalIgnoreCase)).ToList();
					toRemove.Each(x => allUsers.Remove(x));

					string serialized = _serializer.Serialize(allUsers);
					_writer.Write(_file, serialized);
				});
		}

		public T Query<T>(IQuery<T> query)
		{
			var users = LoadDocument();
			return query.Apply(users);
		}

		IEnumerable<User> LoadDocument()
		{
			IList<User> deserialized = null;
			_synchronizer.Lock(() =>
				{
					string serialized = _reader.Read(_file);

					deserialized = _serializer.Deserialize<IList<User>>(serialized ?? String.Empty);
				});

			if (deserialized == null)
			{
				return new List<User>();
			}

			return deserialized;
		}
	}
}