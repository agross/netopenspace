using System;
using System.Collections;
using System.Collections.Generic;

namespace NOS.Registration.Commands.Infrastructure
{
	public class GenericItemDictionary : IEnumerable
	{
		readonly IDictionary<Type, object> _items = new Dictionary<Type, object>();

		public IEnumerator GetEnumerator()
		{
			return _items.GetEnumerator();
		}

		public void Add<TItem>(TItem item)
		{
			Add(typeof(TItem), item);
		}

		public void Add(Type type, object item)
		{
			if (_items.ContainsKey(type))
			{
				_items[type] = item;
			}
			else
			{
				_items.Add(type, item);
			}
		}

		public TItem Get<TItem>()
		{
			return (TItem) Get(typeof(TItem));
		}

		public object Get(Type itemType)
		{
			return _items[itemType];
		}
	}
}