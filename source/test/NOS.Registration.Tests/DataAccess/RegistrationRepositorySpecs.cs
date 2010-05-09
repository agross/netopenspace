using System;
using System.Collections.Generic;
using System.Linq;

using Machine.Specifications;

using NOS.Registration.Abstractions;
using NOS.Registration.DataAccess;
using NOS.Registration.Model;
using NOS.Registration.Queries;
using NOS.Registration.Tests.ForTesting;

using Rhino.Mocks;

namespace NOS.Registration.Tests.DataAccess
{
	public class RepositorySpecs
	{
		protected static IFileReader Reader;
		protected static IRegistrationRepository Repository;
		protected static IEnumerable<User> Users;
		protected static IFileWriter Writer;

		Establish context = () =>
			{
				var synchronizer = new FakeSynchronizer();

				Reader = MockRepository.GenerateStub<IFileReader>();
				Writer = MockRepository.GenerateStub<IFileWriter>();

				Repository = new RegistrationRepository("file",
				                                        synchronizer,
				                                        Reader,
				                                        Writer);
			};
	}

	[Subject(typeof(RegistrationRepository))]
	public class When_all_users_are_loaded_and_no_users_exist : RepositorySpecs
	{
		Establish context = () => Reader
		                          	.Stub(x => x.Read("file"))
		                          	.Return(String.Empty);

		Because of = () => { Users = Repository.Query(new AllUsers()); };

		It should_return_an_empty_list =
			() => Users.ShouldBeEmpty();
	}

	[Subject(typeof(RegistrationRepository))]
	public class When_all_users_are_loaded_and_the_user_file_does_not_exists : RepositorySpecs
	{
		Establish context = () => Reader
		                          	.Stub(x => x.Read("file"))
		                          	.Return(null);

		Because of = () => { Users = Repository.Query(new AllUsers()); };

		It should_return_an_empty_list =
			() => Users.ShouldBeEmpty();
	}

	[Subject(typeof(RegistrationRepository))]
	public class When_all_users_are_loaded_and_users_exist : RepositorySpecs
	{
		Establish context = () => Reader
		                          	.Stub(x => x.Read("file"))
		                          	.Return(
		                          		"[ { UserName: \"torsten\", Data: { Xing: \"foo\", Twitter: \"bar\" } }, { UserName: \"alex\", Data: { Xing: \"baz\" } } ]");

		Because of = () => { Users = Repository.Query(new AllUsers()); };

		It should_load_the_user_list =
			() => Users.Count().ShouldEqual(2);

		It should_load_user_data =
			() => Users.First().Data.Xing.ShouldEqual("foo");

		It should_assign_null_to_nonexistent_values =
			() => Users.Skip(1).First().Data.Twitter.ShouldBeNull();
	}

	[Subject(typeof(RegistrationRepository))]
	public class When_a_new_user_is_saved : RepositorySpecs
	{
		Establish context = () => Reader
		                          	.Stub(x => x.Read("file"))
		                          	.Return("[ { UserName: \"torsten\", Data: { Xing: \"foo\", Twitter: \"bar\" } } ]");

		Because of = () => Repository.Save(New.User.Named("alex"));

		It should_add_the_user_to_the_list =
			() => Writer.AssertWasCalled(x => x.Write(Arg<string>.Is.Equal("file"),
			                                          Arg<string>.Matches(y => y.Contains("alex"))));

		It should_retain_the_original_collection =
			() => Writer.AssertWasCalled(x => x.Write(Arg<string>.Is.Equal("file"),
			                                          Arg<string>.Matches(y => y.Contains("torsten"))));
	}

	[Subject(typeof(RegistrationRepository))]
	public class When_an_existing_user_is_saved : RepositorySpecs
	{
		Establish context = () => Reader
		                          	.Stub(x => x.Read("file"))
		                          	.Return("[ { UserName: \"torsten\", Data: { Xing: \"foo\", Twitter: \"bar\" } } ]");

		Because of = () => Repository.Save(New.User.Named("torsten"));

		It should_update_the_user =
			() => Writer.AssertWasCalled(x => x.Write(Arg<string>.Is.Equal("file"),
			                                          Arg<string>.Matches(y => !y.Contains("foo"))));
	}

	[Subject(typeof(RegistrationRepository))]
	public class When_an_existing_user_is_deleted : RepositorySpecs
	{
		Establish context = () => Reader
		                          	.Stub(x => x.Read("file"))
		                          	.Return(
		                          		"[ { UserName: \"torsten\", Data: { Xing: \"foo\", Twitter: \"bar\" } }, { UserName: \"alex\", Data: { Xing: \"baz\" } } ]");

		Because of = () => Repository.Delete(New.User.Named("torsten"));

		It should_remove_the_user_from_the_list =
			() => Writer.AssertWasCalled(x => x.Write(Arg<string>.Is.Equal("file"),
			                                          Arg<string>.Matches(y => !y.Contains("torsten"))));

		It should_retain_all_other_users =
			() => Writer.AssertWasCalled(x => x.Write(Arg<string>.Is.Equal("file"),
			                                          Arg<string>.Matches(y => y.Contains("alex"))));
	}

	[Subject(typeof(RegistrationRepository))]
	public class When_a_user_is_deleted_and_no_users_exist : RepositorySpecs
	{
		Establish context = () => Reader
		                          	.Stub(x => x.Read("file"))
		                          	.Return(null);

		Because of = () => Repository.Delete(New.User.Named("torsten"));

		It should_succeed =
			() => true.ShouldBeTrue();
	}
}