
using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using ScrewTurn.Wiki.PluginFramework;
using System.Text;

namespace ScrewTurn.Wiki {

	public partial class RSS : BasePage {

        protected void Page_Load(object sender, EventArgs e) {
			// Check Private Wiki
			bool hasAccess = true;
			bool destroySession = false;
			if(SessionFacade.LoginKey == null && Settings.PrivateAccess) {
				// Look for username/password in the query string
				if(Request["Username"] != null && Request["Password"] != null) {
					// Try to authenticate
					UserInfo u = Users.Instance.Find(Request["Username"]);
					if(u != null) {
						// Very "dirty" way - pages should not access Providers
						if(u.Provider.TestAccount(u, Request["Password"])) {
							// Valid account
							hasAccess = true;
						}
						else hasAccess = false;
					}
					else {
						// Check for built-in admin account
						if(Request["Username"].Equals("admin") && Request["Password"].Equals(Settings.MasterPassword)) {
							hasAccess = true;
						}
						else hasAccess = false;
					}
					destroySession = true;
				}
				else hasAccess = false;
			}
			else destroySession = true;

			if(!hasAccess) {
				// Return an empty page
				Response.Clear();
				Response.End();
				// AG - Bug with the editing of pages Session.Abandon();
				return;
			}

			// AG - Bug with the editing of pages if(destroySession) Session.Abandon();

            Response.ClearContent();
            Response.ContentType = "text/xml;charset=UTF-8";
            Response.ContentEncoding = System.Text.UTF8Encoding.UTF8;

			Pages pages = Pages.Instance;

            if(Request["Page"] != null) {
				PageInfo page = pages.FindPage(Request["Page"]);
				if(page == null) return;
				PageContent content = Content.GetPageContent(page, true);
				if(Request["Discuss"] == null) {
					Response.Write(RssHead);

					Response.Write("<channel>" + BuildChannelHead(Settings.WikiTitle + " - " + content.Title,
						Settings.MainUrl + page.Name + Settings.PageExtension,
						Settings.MainUrl + "RSS.aspx?Page=" + page.Name,
						content.Title + " - " + Resources.Messages.PageUpdates));
					Response.Write("<item>\r\n");
					Response.Write("<title><![CDATA[" + content.Title + "]]></title>\r\n");
					Response.Write("<link>" + Settings.MainUrl + page.Name + Settings.PageExtension + "</link>\r\n");
					Response.Write("<description><![CDATA[" + content.Title + ": " + Resources.Messages.ThePageHasBeenUpdatedBy + " " +
						content.User + (content.Comment.Length > 0 ? ".<br />" + content.Comment : ".") + "]]></description>\r\n");
					Response.Write("<pubDate>" + content.LastModified.ToUniversalTime().ToString("R") + "</pubDate>\r\n");
					Response.Write("<guid isPermaLink=\"false\">" + GetGuid(page.Name, content.LastModified) + "</guid>\r\n");
					Response.Write("</item>\r\n");
					Response.Write("</channel>\r\n");

					Response.Write(RssFoot);
				}
				else {
					List<Message> messages = new List<Message>(Pages.Instance.GetPageMessages(page));
					// Un-tree Messages
					UnTreeMessages(messages, messages);
					// Sort from newer to older
					messages.Sort(new MessageDateTimeComparer(true));

					Response.Write(RssHead);

					Response.Write("<channel>" + BuildChannelHead(Settings.WikiTitle + " - " + content.Title + " - Discussion Updates",
						Settings.MainUrl + page.Name + Settings.PageExtension + "?Discuss=1",
						Settings.MainUrl + "RSS.aspx?Page=" + page.Name + "&amp;Discuss=1",
						Settings.WikiTitle + " - " + content.Title + " - Discussion Updates"));

					for(int i = 0; i < messages.Count; i++) {
						Response.Write("<item>\r\n");
						Response.Write("<title><![CDATA[" + messages[i].Subject + "]]></title>\r\n");
						Response.Write("<link>" + Settings.MainUrl + page.Name + Settings.PageExtension + "?Discuss=1</link>\r\n");
						Response.Write("<description><![CDATA[" + Formatter.Format(messages[i].Body, null) + "]]></description>\r\n");
						Response.Write("<pubDate>" + messages[i].DateTime.ToUniversalTime().ToString("R") + "</pubDate>\r\n");
						Response.Write("<guid isPermaLink=\"false\">" + GetGuid(page.Name + "-" + messages[i].ID.ToString(), messages[i].DateTime) + "</guid>\r\n");
						Response.Write("</item>\r\n");
					}

					Response.Write("</channel>\r\n");

					Response.Write(RssFoot);
				}
            }
			else {
				// All updates
				Response.Write(RssHead);

				bool useCat = false;
				string cat = "";
				if(Request["Category"] != null) {
					useCat = true;
					cat = Request["Category"];
				}

				Response.Write("<channel>" + BuildChannelHead(Settings.WikiTitle + " - " + Resources.Messages.PageUpdates,
					Settings.MainUrl,
					Settings.MainUrl + "RSS.aspx" + (useCat ? ("?Category=" + cat) : ""),
					Resources.Messages.RecentPageUpdates));

				RecentChange[] ch = RecentChanges.Instance.AllChanges;
				Array.Reverse(ch);
				for(int i = 0; i < ch.Length; i++) {
					PageInfo p = Pages.Instance.FindPage(ch[i].Page);
					if(p != null && useCat) {
						CategoryInfo[] infos = Pages.Instance.GetCategoriesPerPage(p);
						if(infos.Length == 0) {
							if(!cat.Equals("-")) continue;
						}
						else {
							bool found = false;
							for(int k = 0; k < infos.Length; k++) {
								if(infos[k].Name.Equals(cat)) {
									found = true;
									break;
								}
							}
							if(!found) continue;
						}
					}
					else if(p == null && useCat) continue;
					Response.Write("<item>\r\n");
					Response.Write("<title><![CDATA[" + ch[i].Title + "]]></title>\r\n");
					if(ch[i].Change != Change.PageDeleted && p != null)
						Response.Write("<link>" + Settings.MainUrl + ch[i].Page + Settings.PageExtension + "</link>\r\n");
					else Response.Write("<link>" + Settings.MainUrl + "</link>\r\n");
					Response.Write("<description><![CDATA[");
					switch(ch[i].Change) {
						case Change.PageUpdated:
							Response.Write(Resources.Messages.ThePageHasBeenUpdatedBy);
							break;
						case Change.PageDeleted:
							Response.Write(Resources.Messages.ThePageHasBeenDeletedBy);
							break;
						case Change.PageRenamed:
							Response.Write(Resources.Messages.ThePageHasBeenRenamedBy);
							break;
						case Change.PageRolledBack:
							Response.Write(Resources.Messages.ThePageHasBeenRolledBackBy);
							break;
					}
					Response.Write(" " + ch[i].User + (ch[i].Description.Length > 0 ? ".<br />" + ch[i].Description : ".") + "]]></description>\r\n");
					Response.Write("<pubDate>" + ch[i].DateTime.ToUniversalTime().ToString("R") + "</pubDate>\r\n");
					Response.Write("<guid isPermaLink=\"false\">" + GetGuid(ch[i].Page, ch[i].DateTime) + "</guid>\r\n");
					Response.Write("</item>\r\n");
				}
				Response.Write("</channel>\r\n");

				Response.Write(RssFoot);
			}

        }

		private void UnTreeMessages(List<Message> root, List<Message> messages) {
			for(int i = 0; i < messages.Count; i++) {
				root.AddRange(messages[i].Replies);
				UnTreeMessages(root, messages[i].Replies);
				messages[i].Replies.Clear();
			}
		}

		private string BuildChannelHead(string title, string link, string selfLink, string description) {
			StringBuilder sb = new StringBuilder(200);
            sb.AppendFormat("<title><![CDATA[{0}]]></title>\r\n", title);
            sb.AppendFormat("<link>{0}</link>\r\n", link);
			sb.AppendFormat("<atom:link href=\"{0}\" rel=\"self\" type=\"application/rss+xml\" />\r\n", selfLink);
            sb.AppendFormat("<description><![CDATA[{0}]]></description>\r\n", description);
			sb.AppendFormat("<pubDate>{0:R}</pubDate>\r\n", DateTime.Now);
            sb.Append("<generator><![CDATA[ScrewTurn Wiki RSS Feed Generator]]></generator>\r\n");
			return sb.ToString();
        }

        private string RssHead {
            get {
                return "<?xml version=\"1.0\" encoding=\"utf-8\"?>\r\n<rss version=\"2.0\" xmlns:atom=\"http://www.w3.org/2005/Atom\">\r\n";
            }
        }

        private string RssFoot {
            get {
                return "</rss>\r\n";
            }
        }

		/// <summary>
		/// Gets a valid and consistent GUID for RSS items.
		/// </summary>
		/// <param name="item">The item name, for example the page name.</param>
		/// <param name="editDateTime">The last date/time the item was modified.</param>
		/// <returns>The GUID.</returns>
		private string GetGuid(string item, DateTime editDateTime) {
			return Hash.Compute(item + editDateTime.ToString("yyyyMMddHHmmss"));
		}

    }

}
