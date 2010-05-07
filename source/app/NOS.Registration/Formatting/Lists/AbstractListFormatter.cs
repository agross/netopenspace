using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;

using NOS.Registration.Formatting.ListItems;

namespace NOS.Registration.Formatting.Lists
{
	public abstract class AbstractListFormatter<T> : IListFormatter<T>
	{
		readonly IListItemFormatter<T> _itemFormatter;

		protected AbstractListFormatter(IListItemFormatter<T> itemFormatter)
		{
			_itemFormatter = itemFormatter;
		}

		protected abstract string StartElement
		{
			get;
		}

		protected abstract string EndElement
		{
			get;
		}

		public StringBuilder FormatList(IEnumerable<T> items)
		{
			var result = new StringBuilder(StartElement);

			items.Each(x => result.AppendFormat("<li>{0}</li>", _itemFormatter.FormatItem(x)));

			return result.Append(EndElement);
		}

		public StringBuilder FormatEmptyList(XmlDocument document)
		{
			var emptyText = document.DocumentElement.GetAttribute("empty-value");

			if (String.IsNullOrEmpty(emptyText))
			{
				return new StringBuilder(0);
			}

			return new StringBuilder()
				.Append(StartElement)
				.AppendFormat("<li>{0}</li>", emptyText)
				.Append(EndElement);
		}
	}
}