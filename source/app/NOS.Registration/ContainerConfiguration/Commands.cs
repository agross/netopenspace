using System;
using System.Linq;

using Castle.Core.Interceptor;
using Castle.DynamicProxy;

using NOS.Registration.Commands;
using NOS.Registration.Commands.Infrastructure;

using StructureMap;
using StructureMap.Configuration.DSL;
using StructureMap.Graph;
using StructureMap.Interceptors;
using StructureMap.TypeRules;

namespace NOS.Registration.ContainerConfiguration
{
	public class Commands : Registry
	{
		public Commands()
		{
			ForSingletonOf<ICommandInvoker>().Use<CommandInvoker>();
			ForSingletonOf<ICommandFactory>().Use<CommandFactory>();
			ForSingletonOf<ISynchronizer>().Use<CrossContextSynchronizer>();

			Scan(x =>
				{
					x.TheCallingAssembly();
					x.Convention<CommandConvention>();
				});
		}
	}

	public class CommandConvention : IRegistrationConvention
	{
		public void Process(Type type, Registry registry)
		{
			if (!type.IsConcrete() || !type.Closes(typeof(Command<>)))
			{
				return;
			}

			var closedInterface = type.GetInterfaces()
				.Where(x => x.IsGenericType)
				.First(x => x.GetGenericTypeDefinition() == typeof(ICommandMessageHandler<>));

			registry
				.For(closedInterface)
				.Use(type)
				.Named(type.FullName)
				.Interceptor = new ProxyInstanceInterceptor(closedInterface);
		}
	}

	public class ProxyInstanceInterceptor : InstanceInterceptor
	{
		static readonly ProxyGenerator ProxyGenerator = new ProxyGenerator();
		readonly ProxyGenerationOptions _generationOptions = new ProxyGenerationOptions();
		readonly Type _pluginType;

		public ProxyInstanceInterceptor(Type pluginType)
		{
			_pluginType = pluginType;
		}

		public object Process(object target, IContext context)
		{
			if (!(target is IAmSynchronized))
			{
				return target;
			}

			return ProxyGenerator.CreateInterfaceProxyWithTarget(_pluginType,
			                                                     new[] { typeof(ICommandMessageHandler) },
			                                                     target,
			                                                     _generationOptions,
			                                                     context.GetInstance<SynchronizerInterceptor>());
		}
	}

	public class SynchronizerInterceptor : IInterceptor
	{
		readonly ISynchronizer _synchronizer;

		public SynchronizerInterceptor(ISynchronizer synchronizer)
		{
			_synchronizer = synchronizer;
		}

		public void Intercept(IInvocation invocation)
		{
			_synchronizer.Lock(invocation.Proceed);
		}
	}
}