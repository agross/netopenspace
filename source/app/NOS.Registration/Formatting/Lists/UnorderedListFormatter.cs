using NOS.Registration.Formatting.ListItems;

namespace NOS.Registration.Formatting.Lists
{
	public class UnorderedListFormatter<T> : AbstractListFormatter<T>
	{
		public UnorderedListFormatter(IListItemFormatter<T> itemFormatter) : base(itemFormatter)
		{
		}

		protected override string StartElement
		{
			get { return "<ul>"; }
		}

		protected override string EndElement
		{
			get { return "</ul>"; }
		}
	}
}