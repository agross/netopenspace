using System.Collections.Generic;

using Machine.Specifications;

using NOS.Registration.Formatting;
using NOS.Registration.Model;

using Rhino.Mocks;

namespace NOS.Registration.Tests.Formatting
{
	internal class TheQuery : IQuery<IEnumerable<User>>
	{
		public IEnumerable<User> Apply(IEnumerable<User> data)
		{
			return new User[] { };
		}
	}

	[Subject(typeof(RegistrationDataProvider<>))]
	public class When_registration_data_is_provided_for_list_formatting
	{
		static RegistrationDataProvider<TheQuery> Provider;
		static IRegistrationRepository Repository;

		Establish context = () =>
			{
				Repository = MockRepository.GenerateStub<IRegistrationRepository>();

				Provider = new RegistrationDataProvider<TheQuery>(Repository);
			};

		Because of = () => Provider.GetItems();

		It should_execute_the_query_against_the_repository =
			() => Repository.AssertWasCalled(x => x.Query(Arg<TheQuery>.Is.NotNull));
	}
}