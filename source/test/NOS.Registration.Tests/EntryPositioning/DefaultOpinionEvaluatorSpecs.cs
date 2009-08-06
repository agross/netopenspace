using Machine.Specifications;

using NOS.Registration.EntryPositioning;

using Rhino.Mocks;

namespace NOS.Registration.Tests.EntryPositioning
{
	[Subject(typeof(DefaultOpinionEvaluator))]
	public class When_the_opinions_about_the_entry_position_are_evaluated
	{
		static IHasOpinionAboutEntryPosition[] Opinions;
		static DefaultOpinionEvaluator Evaluator;
		static EvaluationContext Context;
		static int Position;

		Establish context = () =>
			{
				Opinions = new[]
				           {
				           	MockRepository.GenerateStub<IHasOpinionAboutEntryPosition>(),
				           	MockRepository.GenerateStub<IHasOpinionAboutEntryPosition>(),
				           	MockRepository.GenerateStub<IHasOpinionAboutEntryPosition>()
				           };

				Context = new EvaluationContext();

				Opinions[0].Stub(x => x.GetPosition(null))
					.IgnoreArguments()
					.Return(12);
				Opinions[1].Stub(x => x.GetPosition(null))
					.IgnoreArguments()
					.Return(42);
				Opinions[2].Stub(x => x.GetPosition(null))
					.IgnoreArguments()
					.Return(int.MinValue);

				Evaluator = new DefaultOpinionEvaluator(Opinions);
			};

		Because of = () => { Position = Evaluator.Evaluate(Context); };

		It should_ask_each_element_for_the_position = () => Opinions.Each(x => x.AssertWasCalled(y => y.GetPosition(Context)));
		It should_return_the_last_opinion_larger_than_minus_one = () => Position.ShouldEqual(42);
	}

	public abstract class With_default_opinions
	{
		protected static IPluginConfiguration Configuration;
		protected static EvaluationContext Context;
		protected static DefaultOpinionEvaluator Evaluator;
		static IHasOpinionAboutEntryPosition[] Opinions;

		Establish context = () =>
			{
				Opinions = new IHasOpinionAboutEntryPosition[]
				           {
				           	new AtListEnd(),
				           	new AtListEndWhenSponsoring(),
				           	new AtWaitingListEndWhenHardLimitReached()
				           };

				Configuration = MockRepository.GenerateStub<IPluginConfiguration>();

				Context = new EvaluationContext
				          {
				          	Configuration = Configuration,
				          	User = new User("user"),
				          	Logger = MockRepository.GenerateStub<ILogger>()
				          };

				Evaluator = new DefaultOpinionEvaluator(Opinions);
			};
	}

	[Subject(typeof(DefaultOpinionEvaluator))]
	public class When_the_position_is_evaluated_and_the_attendee_list_has_open_seats : With_default_opinions
	{
		static int Position;

		Establish context = () =>
			{
				Configuration.Stub(x => x.MaximumAttendees).Return(10);
				Configuration.Stub(x => x.HardLimit).Return(15);

				Context.NumberOfAttendees = 9;
				Context.ListEnd = 245;
			};

		Because of = () => { Position = Evaluator.Evaluate(Context); };

		It should_add_the_user_to_the_attendee_list =
			() => Position.ShouldEqual(Context.ListEnd);
	}

	[Subject(typeof(DefaultOpinionEvaluator))]
	public class When_the_position_is_evaluated_and_the_attendee_list_is_full_and_the_user_did_not_show_monetary_support
		: With_default_opinions
	{
		static int Position;

		Establish context = () =>
			{
				Configuration.Stub(x => x.MaximumAttendees).Return(10);
				Configuration.Stub(x => x.HardLimit).Return(15);

				Context.NumberOfAttendees = 11;
				Context.ListEnd = 245;
				Context.WaitingListEnd = 512;
				Context.User.Data.Sponsoring = decimal.Zero;
			};

		Because of = () => { Position = Evaluator.Evaluate(Context); };

		It should_add_the_user_to_the_waiting_list =
			() => Position.ShouldEqual(Context.WaitingListEnd);
	}

	[Subject(typeof(DefaultOpinionEvaluator))]
	public class When_the_position_is_evaluated_and_the_attendee_list_is_full_but_the_user_did_show_monetary_support
		: With_default_opinions
	{
		static int Position;

		Establish context = () =>
			{
				Configuration.Stub(x => x.MaximumAttendees).Return(10);
				Configuration.Stub(x => x.HardLimit).Return(15);

				Context.NumberOfAttendees = 11;
				Context.ListEnd = 245;
				Context.WaitingListEnd = 512;
				Context.User.Data.Sponsoring = decimal.One;
			};

		Because of = () => { Position = Evaluator.Evaluate(Context); };

		It should_add_the_user_to_the_attendee_list =
			() => Position.ShouldEqual(Context.ListEnd);
	}

	[Subject(typeof(DefaultOpinionEvaluator))]
	public class When_the_position_is_evaluated_and_the_hard_limit_is_reached : With_default_opinions
	{
		static int Position;

		Establish context = () =>
			{
				Configuration.Stub(x => x.MaximumAttendees).Return(10);
				Configuration.Stub(x => x.HardLimit).Return(15);

				Context.NumberOfAttendees = 15;
				Context.ListEnd = 245;
				Context.WaitingListEnd = 512;
				Context.User.Data.Sponsoring = decimal.One;
			};

		Because of = () => { Position = Evaluator.Evaluate(Context); };

		It should_add_the_user_to_the_waiting_list =
			() => Position.ShouldEqual(Context.WaitingListEnd);
	}
}