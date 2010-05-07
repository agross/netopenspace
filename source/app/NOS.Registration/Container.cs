using System;
using System.Collections.Generic;

using NOS.Registration.Abstractions;
using NOS.Registration.EntryPositioning;
using NOS.Registration.EntryPositioning.Opinions;
using NOS.Registration.Formatting;

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
					// ScrewTurn abstractions.
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

					x.For<ISynchronizer>()
						.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
						.Use<CrossContextSynchronizer>();

					x.For<IRegistrationRepository>()
						.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
						.Use<RegistrationRepository>()
						.Ctor<string>("file").Is("AutoRegistration.cs");

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
					
					x.For<IFormatter>()
						.LifecycleIs(Lifecycles.GetLifecycle(InstanceScope.Singleton))
						.Use<AttendeeListFormatter>();
				});
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