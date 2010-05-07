namespace NOS.Registration.Formatting.ListItems
{
	public interface IListItemFormatter<T>
	{
		string FormatItem(T item);
	}
}