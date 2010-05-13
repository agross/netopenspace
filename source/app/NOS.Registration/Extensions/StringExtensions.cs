using System;

namespace NOS.Registration
{
	public static class StringExtensions
	{
		public static bool IsNullOrEmpty(this string instance)
		{
			if (instance != null)
			{
				instance = instance.Trim();
			}

			return String.IsNullOrEmpty(instance);
		}
	}
}