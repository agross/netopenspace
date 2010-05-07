using System;
using System.Collections.Generic;

namespace NOS.Registration
{
	public class DefaultPluginConfiguration : IPluginConfiguration
	{
		public DefaultPluginConfiguration()
		{
			EntryTemplate = "$user.UserName";
		}

		public int MaximumAttendees
		{
			get;
			protected set;
		}

		public int HardLimit
		{
			get;
			protected set;
		}

		public string EntryTemplate
		{
			get;
			protected set;
		}

		public IEnumerable<string> Parse(string configString)
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

							default:
								errors.Add(String.Format("Unknown configuration key: {0}", key));
								break;
						}
					});

			AssertConfigurationIsValid(errors);
			return errors;
		}

		void AssertConfigurationIsValid(ICollection<string> errors)
		{
			if (MaximumAttendees == 0)
			{
				errors.Add("The maximum attendee count is missing. Configuration sample: 'MaximumAttendees=12'.");
			}
	
			if (MaximumAttendees > HardLimit)
			{
				errors.Add(
					"The maximum attendee count must be less than or equal to the hard limit. Configuration sample: 'MaximumAttendees=12\nHardLimit=15'.");
			}
		}
	}
}