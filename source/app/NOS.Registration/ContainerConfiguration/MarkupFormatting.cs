using NOS.Registration.Formatting;
using NOS.Registration.Formatting.ListItems;
using NOS.Registration.Formatting.Lists;
using NOS.Registration.Model;
using NOS.Registration.Queries;
using NOS.Registration.Templating;

using StructureMap;
using StructureMap.Configuration.DSL;
using StructureMap.Pipeline;

namespace NOS.Registration.ContainerConfiguration
{
	public class MarkupFormatting : Registry
	{
		public MarkupFormatting()
		{
			DataProviders();
			MarkupScanners();
			ListFormatters();
			MarkupFormatters();

			For<ITemplateEngine>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<NVelocityTemplateEngine>();
		}

		void DataProviders()
		{
			For(typeof(IDataProvider<User>))
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use(typeof(RegistrationDataProvider<Attendees>))
				.Named("attendees");
			
			For(typeof(IDataProvider<User>))
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use(typeof(RegistrationDataProvider<WaitingList>))
				.Named("waiting list");
			
			For(typeof(IDataProvider<User>))
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use(typeof(RegistrationDataProvider<Withdrawals>))
				.Named("withdrawal list");

			For(typeof(IDataProvider<User>))
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use(typeof(RegistrationDataProvider<InterestOnly>))
				.Named("interest-only list");
		}

		void MarkupFormatters()
		{
			For<IMarkupFormatter>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Add<ListMarkupFormatter<User>>()
				.Ctor<IMarkupScanner>().Is(y => y.TheInstanceNamed("attendee list"))
				.Ctor<IDataProvider<User>>().Is(y => y.TheInstanceNamed("attendees"))
				.Ctor<IListFormatter<User>>("emptyListFormatter").Is(y => y.TheInstanceNamed("ul"))
				.Ctor<IListFormatter<User>>("listFormatter").Is(y => y.TheInstanceNamed("ol"));

			For<IMarkupFormatter>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Add<ListMarkupFormatter<User>>()
				.Ctor<IMarkupScanner>().Is(y => y.TheInstanceNamed("waiting list"))
				.Ctor<IDataProvider<User>>().Is(y => y.TheInstanceNamed("waiting list"))
				.Ctor<IListFormatter<User>>("emptyListFormatter").Is(y => y.TheInstanceNamed("ul"))
				.Ctor<IListFormatter<User>>("listFormatter").Is(y => y.TheInstanceNamed("ol"));

			For<IMarkupFormatter>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Add<ListMarkupFormatter<User>>()
				.Ctor<IMarkupScanner>().Is(y => y.TheInstanceNamed("withdrawal list"))
				.Ctor<IDataProvider<User>>().Is(y => y.TheInstanceNamed("withdrawal list"))
				.Ctor<IListFormatter<User>>("emptyListFormatter").Is(y => y.TheInstanceNamed("ul"))
				.Ctor<IListFormatter<User>>("listFormatter").Is(y => y.TheInstanceNamed("ul"));

			For<IMarkupFormatter>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Add<ListMarkupFormatter<User>>()
				.Ctor<IMarkupScanner>().Is(y => y.TheInstanceNamed("interest-only list"))
				.Ctor<IDataProvider<User>>().Is(y => y.TheInstanceNamed("interest-only list"))
				.Ctor<IListFormatter<User>>("emptyListFormatter").Is(y => y.TheInstanceNamed("ul"))
				.Ctor<IListFormatter<User>>("listFormatter").Is(y => y.TheInstanceNamed("ul"));
		}

		void ListFormatters()
		{
			For(typeof(IListItemFormatter<>))
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use(typeof(UserListItemFormatter));

			For(typeof(IListFormatter<>))
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use(typeof(OrderedListFormatter<>))
				.Named("ol");

			For(typeof(IListFormatter<>))
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use(typeof(UnorderedListFormatter<>))
				.Named("ul");
		}

		void MarkupScanners()
		{
			For<IMarkupScanner>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<MarkupScanner>()
				.Named("attendee list")
				.Ctor<string>("name").Is("Attendee list")
				.Ctor<string>("expression").Is(@"<attendee-list(.+?)/>");

			For<IMarkupScanner>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<MarkupScanner>()
				.Named("waiting list")
				.Ctor<string>("name").Is("Waiting list")
				.Ctor<string>("expression").Is(@"<waiting-list(.+?)/>");

			For<IMarkupScanner>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<MarkupScanner>()
				.Named("withdrawal list")
				.Ctor<string>("name").Is("Withdrawal list")
				.Ctor<string>("expression").Is(@"<withdrawal-list(.+?)/>");

			For<IMarkupScanner>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<MarkupScanner>()
				.Named("interest-only list")
				.Ctor<string>("name").Is("Interest list")
				.Ctor<string>("expression").Is(@"<interest-list(.+?)/>");
		}
	}
}