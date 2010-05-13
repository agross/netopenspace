using System;
using System.Collections.Generic;

namespace NOS.Registration
{
	public static class EnumerableExtensions
	{
		public static void Each<T>(this IEnumerable<T> instance, Action<T> action)
		{
			foreach (var enumerable in instance)
			{
				action(enumerable);
			}
		}
	}
}