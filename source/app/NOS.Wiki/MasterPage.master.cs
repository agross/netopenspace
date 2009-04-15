
using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using ScrewTurn.Wiki.PluginFramework;

namespace ScrewTurn.Wiki {

    public partial class MasterPage : System.Web.UI.MasterPage {

		protected void Page_Load(object sender, EventArgs e) {

			lblStrings.Text = string.Format("<script type=\"text/javascript\">\r\n<!--\r\n__BaseName = \"{0}\";\r\n// -->\r\n</script>", CphMaster.ClientID + "_");

			// Manage Private Wiki
			if(Settings.PrivateAccess && SessionFacade.LoginKey == null && Path.GetFileName(Request.PhysicalPath).ToLowerInvariant() != "login.aspx" &&
				!Path.GetFileName(Request.PhysicalPath).ToLowerInvariant().Equals("register.aspx")) {

				// Check whether the user is trying to view/edit a public page
				// Every time Request["Page"] is used and the requested page is public, then the action is allowed
				
				// Bug fix (ticket #187): Check the DefaultPage property if no page is requested
				string p = Request["Page"] != null ? Request["Page"] : Settings.DefaultPage;

				if(!string.IsNullOrEmpty(p)) {
					PageInfo page = Pages.Instance.FindPage(p);
					if(page == null || page.Status != PageStatus.Public) {
						Response.Redirect("Login.aspx");
					}
				} else Response.Redirect("Login.aspx");
			}

			PrintHtmlHead();
			PrintHeader();
			PrintSidebar();
			PrintFooter();
			PrintPageHeaderAndFooter();
		}

		public void PrintPageHeaderAndFooter() {
			string h = null;
			if(!Content.PseudoCache.TryGetValue("PageHeader", out h)) {
				h = Tools.LoadFile(Settings.PageHeaderFile);
				if(!string.IsNullOrEmpty(h)) {
					h = @"<div id=""PageInternalHeaderDiv"">" + FormattingPipeline.FormatWithPhase1And2(h, null) + "</div>";
				}
				else h = "";
				Content.PseudoCache["PageHeader"] = h;
			}
			if(h.Length > 0) lblPageHeaderDiv.Text = FormattingPipeline.FormatWithPhase3(h, null);
			else lblPageHeaderDiv.Text = "";

			h = null;
			if(!Content.PseudoCache.TryGetValue("PageFooter", out h)) {
				h = Tools.LoadFile(Settings.PageFooterFile);
				if(!string.IsNullOrEmpty(h)) {
					h = @"<div id=""PageInternalFooterDiv"">" + FormattingPipeline.FormatWithPhase1And2(h, null) + "</div>";
				}
				else h = "";
				Content.PseudoCache["PageFooter"] = h;
			}
			if(h.Length > 0) lblPageFooterDiv.Text = FormattingPipeline.FormatWithPhase3(h, null);
			else lblPageFooterDiv.Text = "";
		}

		public void PrintHtmlHead() {
			string h;
			if(!Content.PseudoCache.TryGetValue("Head", out h)) {
				StringBuilder sb = new StringBuilder();
				sb.Append(@"<meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"" />");
				sb.Append("\n");
				sb.Append(@"<link rel=""alternate"" title=""");
				sb.Append(Settings.WikiTitle);
				sb.Append(@""" href=""");
				sb.Append(Settings.MainUrl);
				sb.Append(@"RSS.aspx"" type=""application/rss+xml"" />");
				sb.Append("\n");
				sb.Append(Tools.Includes);
				h = sb.ToString();
				Content.PseudoCache["Head"] = h;
			}
			// Use a Control to allow 3rd party plugins to programmatically access the Page header
			Literal c = new Literal();
			c.Text = h;
			Page.Header.Controls.Add(c);
        }

        public void PrintHeader() {
			string h;
			if(!Content.PseudoCache.TryGetValue("Header", out h)) {
				h = FormattingPipeline.FormatWithPhase1And2(Tools.LoadFile(Settings.HeaderFile), null);
				// Does not work with tabs.
				// Content.PseudoCache["Header"] = h;
			}
			lblHeaderDiv.Text = FormattingPipeline.FormatWithPhase3(h, null);
        }

        public void PrintSidebar() {
			string s;
			if(!Content.PseudoCache.TryGetValue("Sidebar", out s)) {
				s = FormattingPipeline.FormatWithPhase1And2(Tools.LoadFile(Settings.SidebarFile), null);
				Content.PseudoCache["Sidebar"] = s;
			}
			lblSidebarDiv.Text = FormattingPipeline.FormatWithPhase3(s, null);
        }

		public void PrintFooter() {
			string f;
			if(!Content.PseudoCache.TryGetValue("Footer", out f)) {
				f = FormattingPipeline.FormatWithPhase1And2(Tools.LoadFile(Settings.FooterFile), null);
				Content.PseudoCache["Footer"] = f;
			}
			lblFooterDiv.Text = FormattingPipeline.FormatWithPhase3(f, null);
		}

	}

}
