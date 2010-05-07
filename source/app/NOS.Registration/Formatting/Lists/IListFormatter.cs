using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace NOS.Registration.Formatting.Lists
{
	public interface IListFormatter<T>
	{
		StringBuilder FormatList(IEnumerable<T> items);
		StringBuilder FormatEmptyList(XmlDocument document);
	}
}