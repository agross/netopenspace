using System;
using System.Collections.Generic;

namespace NOS.Registration
{
	public class DefaultPluginConfiguration : IPluginConfiguration
	{
		public DefaultPluginConfiguration()
		{
			EntryTemplate = "# $user.UserName";
			Comment = "AutoRegistration";
		}

		public int MaximumAttendees
		{
			get;
			protected set;
		}

		public string PageName
		{
			get;
			protected set;
		}

		public string ListStartPattern
		{
			get;
			protected set;
		}

		public string ListEndPattern
		{
			get;
			protected set;
		}

		public string WaitingListEndPattern
		{
			get;
			protected set;
		}

		public string Comment
		{
			get;
			protected set;
		}

		public string EntryPattern
		{
			get;
			protected set;
		}

		public string EntryTemplate
		{
			get;
			protected set;
		}

		public int HardLimit
		{
			get;
			protected set;
		}

		public IEnumerable<string> Parse(string configString, IPageRepository pageRepository)
		{
			ICollection<string> errors = new List<string>();

			configString
				.Split(new[] { '\n' }, StringSplitOptions.RemoveEmptyEntries)
				.Each(x =>
					{
						string key = x;
						string value = x;
						if (x.IndexOf('=') >= 0)
						{
							key = x.Substring(0, x.IndexOf('=')).ToLowerInvariant();
							value = x.Substring(x.IndexOf('=') + 1).Trim();
						}
						
						int intResult;
						switch (key)
						{
							case "entrytemplate":
								EntryTemplate = value;
								break;

							case "entrypattern":
								EntryPattern = value;
								break;

							case "pagename":
								PageName = value;
								break;

							case "liststartpattern":
								ListStartPattern = value;
								break;

							case "listendpattern":
								ListEndPattern = value;
								break;

							case "waitinglistendpattern":
								WaitingListEndPattern = value;
								break;

							case "maximumattendees":
								if (!int.TryParse(value, out intResult))
								{
									errors.Add(String.Format("Could not convert configuration value to integer: Key='{0}' Value='{1}'",
									                         key,
									                         value));
								}
								else
								{
									MaximumAttendees = intResult;
								}
								break;
							
							case "hardlimit":
								if (!int.TryParse(value, out intResult))
								{
									errors.Add(String.Format("Could not convert configuration value to integer: Key='{0}' Value='{1}'",
									                         key,
									                         value));
								}
								else
								{
									HardLimit = intResult;
								}
								break;

							case "comment":
								Comment = value;
								break;

							default:
								errors.Add(String.Format("Unknown configuration key: {0}", key));
								break;
						}
					});

			AssertConfigurationIsValid(errors, pageRepository);
			return errors;
		}

		void AssertConfigurationIsValid(ICollection<string> errors, IPageRepository pageRepository)
		{
			if (String.IsNullOrEmpty(PageName))
			{
				errors.Add("The page name for the attendee page is missing. Configuration sample: 'PageName=Attendee list'.");
			}

			if (!String.IsNullOrEmpty(PageName))
			{
				if (pageRepository.FindPage(PageName) == null)
				{
					errors.Add(String.Format("The attendee page '{0}' does not exist.", PageName));
				}
			}

			if (String.IsNullOrEmpty(EntryPattern))
			{
				errors.Add("The entry pattern is missing. Configuration sample: 'EntryPattern=^#.*$'.");
			}

			if (String.IsNullOrEmpty(ListStartPattern))
			{
				errors.Add(
					"The attendee list start pattern is missing. Configuration sample: 'ListStartPattern=<!--DO NOT REMOVE List start-->'.");
			}

			if (String.IsNullOrEmpty(ListEndPattern))
			{
				errors.Add(
					"The attendee list end pattern is missing. Configuration sample: 'ListEndPattern=<!--DO NOT REMOVE List end-->'.");
			}

			if (String.IsNullOrEmpty(WaitingListEndPattern))
			{
				errors.Add(
					"The attendee waiting list end pattern is missing. Configuration sample: 'WaitingListEndPattern=<!--DO NOT REMOVE Waiting list end-->'.");
			}
			
			if (MaximumAttendees == 0)
			{
				errors.Add(
					"The maximum attendee count is missing. Configuration sample: 'MaximumAttendees=12'.");
			}
	
			if (MaximumAttendees > HardLimit)
			{
				errors.Add(
					"The maximum attendee count must be less than or equal to the hard limit. Configuration sample: 'MaximumAttendees=12\nHardLimit=15'.");
			}
		}
	}
}