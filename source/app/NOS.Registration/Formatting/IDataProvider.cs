using System.Collections.Generic;

namespace NOS.Registration.Formatting
{
	public interface IDataProvider<T>
	{
		IEnumerable<T> GetItems();
	}
}