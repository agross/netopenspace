using NOS.Registration.Formatting.ListItems;

namespace NOS.Registration.Formatting.Lists
{
	public class OrderedListFormatter<T> : AbstractListFormatter<T>
	{
		public OrderedListFormatter(IListItemFormatter<T> itemFormatter) : base(itemFormatter)
		{
		}

		protected override string StartElement
		{
			get { return "<ol>"; }
		}

		protected override string EndElement
		{
			get { return "</ol>"; }
		}
	}
}