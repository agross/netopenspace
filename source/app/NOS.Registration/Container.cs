using System;
using System.Collections.Generic;

using NOS.Registration.Abstractions;
using NOS.Registration.EntryPositioning;
using NOS.Registration.EntryPositioning.Opinions;
using NOS.Registration.Formatting;
using NOS.Registration.Formatting.ListItems;
using NOS.Registration.Formatting.Lists;
using NOS.Registration.Model;
using NOS.Registration.Queries;

using StructureMap;
using StructureMap.Pipeline;

namespace NOS.Registration
{
	public static class Container
	{
		public static void BootstrapStructureMap()
		{
			ObjectFactory.Initialize(x =>
				{
					ScrewTurnWikiAbstractions(x);

					DataAccess(x);

					x.For<IPageRepository>()
						.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
						.Use<PageRepository>();

					x.For<IPageFormatter>()
						.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
						.Use<PageFormatter>();

					x.For<IEntryFormatter>()
						.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
						.Use<NVelocityEntryFormatter>();

					x.For<INotificationSender>()
						.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
						.Use<EmailNotificationSender>();

					x.For<IPluginConfiguration>()
						.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
						.Use<DefaultPluginConfiguration>();

					x.For<IHaveOpinionAboutEntryPosition>()
						.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
						.Add<OnAttendeeList>();

					x.For<IHaveOpinionAboutEntryPosition>()
						.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
						.Add<OnWaitingListIfNotSponsoring>();

					x.For<IHaveOpinionAboutEntryPosition>()
						.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
						.Add<OnWaitingListIfHardLimitIsReached>();

					x.For<IOpinionEvaluator>()
						.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
						.Use<DefaultOpinionEvaluator>();

					ListMarkupFormatting(x);
				});
		}

		static void ScrewTurnWikiAbstractions(IInitializationExpression x)
		{
			x.For<ILogger>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<Logger>();

			x.For<IFileReader>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<FileReader>();

			x.For<IFileWriter>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<FileWriter>();

			x.For<ISettingsAccessor>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<SettingsAccessor>();
		}

		static void DataAccess(IInitializationExpression x)
		{
			x.For<ISynchronizer>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<CrossContextSynchronizer>();

			x.For<IRegistrationRepository>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<RegistrationRepository>()
				.Ctor<string>("file").Is(typeof(AutoRegistrationPlugin).FullName + ".Data.cs");
		}

		static void ListMarkupFormatting(IInitializationExpression x)
		{
			x.For<IMarkupScanner>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<MarkupScanner>()
				.Named("attendee list")
				.Ctor<string>("name").Is("Attendee list")
				.Ctor<string>("expression").Is(@"<attendee-list(.+?)/>");
			
			x.For<IMarkupScanner>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<MarkupScanner>()
				.Named("waiting list")
				.Ctor<string>("name").Is("Waiting list")
				.Ctor<string>("expression").Is(@"<waiting-list(.+?)/>");
			
			x.For<IMarkupScanner>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<MarkupScanner>()
				.Named("withdrawal list")
				.Ctor<string>("name").Is("Withdrawal list")
				.Ctor<string>("expression").Is(@"<withdrawal-list(.+?)/>");
			
			x.For<IMarkupScanner>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use<MarkupScanner>()
				.Named("interest list")
				.Ctor<string>("name").Is("Interest list")
				.Ctor<string>("expression").Is(@"<interest-list(.+?)/>");
					
			x.For(typeof(IListItemFormatter<>))
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use(typeof(UserListItemFormatter));
			
			x.For(typeof(IListFormatter<>))
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use(typeof(OrderedListFormatter<>))
				.Named("ol");
					
			x.For(typeof(IListFormatter<>))
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use(typeof(UnorderedListFormatter<>))
				.Named("ul");
			
			x.For(typeof(IDataProvider<User>))
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Use(typeof(RegistrationDataProvider<Attendees>))
				.Named("attendees");
					
			x.For<IMarkupFormatter>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Add<ListMarkupFormatter<User>>()
				.Ctor<IMarkupScanner>().Is(y => y.TheInstanceNamed("attendee list"))
				.Ctor<IDataProvider<User>>().Is(y => y.TheInstanceNamed("attendees"))
				.Ctor<IListFormatter<User>>("emptyListFormatter").Is(y => y.TheInstanceNamed("ul"))
				.Ctor<IListFormatter<User>>("listFormatter").Is(y => y.TheInstanceNamed("ol"));
			
			x.For<IMarkupFormatter>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Add<ListMarkupFormatter<User>>()
				.Ctor<IMarkupScanner>().Is(y => y.TheInstanceNamed("waiting list"))
				.Ctor<IDataProvider<User>>().Is(y => y.TheInstanceNamed("attendees"))
				.Ctor<IListFormatter<User>>("emptyListFormatter").Is(y => y.TheInstanceNamed("ul"))
				.Ctor<IListFormatter<User>>("listFormatter").Is(y => y.TheInstanceNamed("ol"));
			
			x.For<IMarkupFormatter>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Add<ListMarkupFormatter<User>>()
				.Ctor<IMarkupScanner>().Is(y => y.TheInstanceNamed("withdrawal list"))
				.Ctor<IDataProvider<User>>().Is(y => y.TheInstanceNamed("attendees"))
				.Ctor<IListFormatter<User>>("emptyListFormatter").Is(y => y.TheInstanceNamed("ul"))
				.Ctor<IListFormatter<User>>("listFormatter").Is(y => y.TheInstanceNamed("ul"));
			
			x.For<IMarkupFormatter>()
				.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
				.Add<ListMarkupFormatter<User>>()
				.Ctor<IMarkupScanner>().Is(y => y.TheInstanceNamed("interest list"))
				.Ctor<IDataProvider<User>>().Is(y => y.TheInstanceNamed("attendees"))
				.Ctor<IListFormatter<User>>("emptyListFormatter").Is(y => y.TheInstanceNamed("ul"))
				.Ctor<IListFormatter<User>>("listFormatter").Is(y => y.TheInstanceNamed("ul"));
		}

		public static T GetInstance<T>()
		{
			if (String.IsNullOrEmpty(ObjectFactory.Profile))
			{
				BootstrapStructureMap();
			}

			return ObjectFactory.GetInstance<T>();
		}

		public static IList<T> GetAllInstances<T>()
		{
			if (String.IsNullOrEmpty(ObjectFactory.Profile))
			{
				BootstrapStructureMap();
			}

			return ObjectFactory.GetAllInstances<T>();
		}

		public static void Release()
		{
			ObjectFactory.Container.Dispose();
		}
	}
}