using Machine.Specifications;

using NOS.Registration.Abstractions;
using NOS.Registration.EntryPositioning;
using NOS.Registration.EntryPositioning.Opinions;

using Rhino.Mocks;

namespace NOS.Registration.Tests.EntryPositioning
{
	[Subject(typeof(DefaultOpinionEvaluator))]
	public class When_the_opinions_about_the_entry_position_are_evaluated
	{
		static IHaveOpinionAboutEntryPosition[] Opinions;
		static DefaultOpinionEvaluator Evaluator;
		static EvaluationContext Context;
		static Opinion Position;

		Establish context = () =>
			{
				Opinions = new[]
				           {
				           	MockRepository.GenerateStub<IHaveOpinionAboutEntryPosition>(),
				           	MockRepository.GenerateStub<IHaveOpinionAboutEntryPosition>(),
				           	MockRepository.GenerateStub<IHaveOpinionAboutEntryPosition>()
				           };

				Opinions[0].Stub(x => x.GetOpinionAboutPosition(null))
					.IgnoreArguments()
					.Return(Opinion.IncludeInList);
				Opinions[1].Stub(x => x.GetOpinionAboutPosition(null))
					.IgnoreArguments()
					.Return(Opinion.IncludeInWaitingList);
				Opinions[2].Stub(x => x.GetOpinionAboutPosition(null))
					.IgnoreArguments()
					.Return(Opinion.NoOpinion);

				Evaluator = new DefaultOpinionEvaluator(Opinions);
				
				Context = new EvaluationContext();
			};

		Because of = () => { Position = Evaluator.Evaluate(Context); };

		It should_ask_each_element_about_the_opinion =
			() => Opinions.Each(x => x.AssertWasCalled(y => y.GetOpinionAboutPosition(Context)));

		It should_use_the_last_opinion_unequal_to__no_opinion__ =
			() => Position.ShouldEqual(Opinion.IncludeInWaitingList);
	}

	public abstract class OpinionEvaluationSpecs
	{
		protected static IPluginConfiguration Configuration;
		protected static EvaluationContext Context;
		protected static DefaultOpinionEvaluator Evaluator;
		static IHaveOpinionAboutEntryPosition[] Opinions;

		Establish context = () =>
			{
				Opinions = new IHaveOpinionAboutEntryPosition[]
				           {
				           	new OnAttendeeList(),
				           	new OnWaitingListIfNotSponsoring(),
				           	new OnWaitingListIfHardLimitIsReached()
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
	public class When_the_position_is_evaluated_and_the_attendee_list_has_open_seats : OpinionEvaluationSpecs
	{
		static Opinion Position;

		Establish context = () =>
			{
				Configuration.Stub(x => x.MaximumAttendees).Return(10);
				Configuration.Stub(x => x.HardLimit).Return(15);

				Context.NumberOfAttendees = 9;
			};

		Because of = () => { Position = Evaluator.Evaluate(Context); };

		It should_add_the_user_to_the_attendee_list =
			() => Position.ShouldEqual(Opinion.IncludeInList);
	}

	[Subject(typeof(DefaultOpinionEvaluator))]
	public class When_the_position_is_evaluated_and_the_attendee_list_is_full_and_the_user_did_not_show_monetary_support
		: OpinionEvaluationSpecs
	{
		static Opinion Position;

		Establish context = () =>
			{
				Configuration.Stub(x => x.MaximumAttendees).Return(10);
				Configuration.Stub(x => x.HardLimit).Return(15);

				Context.NumberOfAttendees = 11;
				Context.User.Data.Sponsoring = decimal.Zero;
			};

		Because of = () => { Position = Evaluator.Evaluate(Context); };

		It should_add_the_user_to_the_waiting_list =
			() => Position.ShouldEqual(Opinion.IncludeInWaitingList);
	}

	[Subject(typeof(DefaultOpinionEvaluator))]
	public class When_the_position_is_evaluated_and_the_attendee_list_is_full_but_the_user_did_show_monetary_support
		: OpinionEvaluationSpecs
	{
		static Opinion Position;

		Establish context = () =>
			{
				Configuration.Stub(x => x.MaximumAttendees).Return(10);
				Configuration.Stub(x => x.HardLimit).Return(15);

				Context.NumberOfAttendees = 11;
				Context.User.Data.Sponsoring = decimal.One;
			};

		Because of = () => { Position = Evaluator.Evaluate(Context); };

		It should_add_the_user_to_the_attendee_list =
			() => Position.ShouldEqual(Opinion.IncludeInList);
	}

	[Subject(typeof(DefaultOpinionEvaluator))]
	public class When_the_position_is_evaluated_and_the_hard_limit_is_reached : OpinionEvaluationSpecs
	{
		static Opinion Position;

		Establish context = () =>
			{
				Configuration.Stub(x => x.MaximumAttendees).Return(10);
				Configuration.Stub(x => x.HardLimit).Return(15);

				Context.NumberOfAttendees = 15;
				Context.User.Data.Sponsoring = decimal.One;
			};

		Because of = () => { Position = Evaluator.Evaluate(Context); };

		It should_add_the_user_to_the_waiting_list =
			() => Position.ShouldEqual(Opinion.IncludeInWaitingList);
	}
}