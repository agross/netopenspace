
using System;
using System.Data;
using System.Configuration;
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

	public partial class Search : BasePage {

        protected void Page_Load(object sender, EventArgs e) {
            Page.Title = Resources.Messages.SearchTitle + " - " + Settings.WikiTitle;
			Page.Form.DefaultButton = btnGo.UniqueID;

			if(!Page.IsPostBack) {
				lstCategories.Items.Clear();
				for(int i = 0; i < Pages.Instance.AllCategories.Count; i++) {
					ListItem item = new ListItem(Pages.Instance.AllCategories[i].Name + "&nbsp;&nbsp;&nbsp;&nbsp;", Pages.Instance.AllCategories[i].Name);
					item.Selected = true;
					lstCategories.Items.Add(item);
				}
			}

			if(!Page.IsPostBack) {
				chkFullSearch.Checked = Request["FullText"] != null;
				chkUncategorized.Checked = Request["NotUncategorized"] == null;
				string[] cats = Request["Categories"] != null ? Request["Categories"].Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries) : null;
				for(int i = 0; cats != null && i < lstCategories.Items.Count; i++) {
					bool found = false;
					for(int k = 0; k < cats.Length; k++) {
						if(lstCategories.Items[i].Value.Equals(cats[k])) {
							found = true;
							break;
						}
					}
					lstCategories.Items[i].Selected = found;
				}
				if(Request["Query"] != null) {
					txtSearch.Text = Request["Query"];
					PerformSearch();
				}
			}
        }

		protected void btnGo_Click(object sender, EventArgs e) {
			StringBuilder sb = new StringBuilder();
			sb.Append("Search.aspx?Query=" + Tools.UrlEncode(txtSearch.Text) + (chkFullSearch.Checked ? "&FullText=1" : ""));
			// Cats
			if(!chkUncategorized.Checked) sb.Append("&NotUncategorized=1");
			sb.Append("&Categories=");
			for(int i = 0; i < lstCategories.Items.Count; i++) {
				if(lstCategories.Items[i].Selected) sb.Append(Tools.UrlEncode(lstCategories.Items[i].Value) + ",");
			}
			Response.Redirect(sb.ToString());
		}

		private void PerformSearch() {
			lblResults.Text = "";

			txtSearch.Text = txtSearch.Text.Trim().Replace("  ", "");

			if(txtSearch.Text.Replace(" ", "").Length < 2) {
				lblResults.Text = @"<br /><br /><span class=""resulterror"">" + Resources.Messages.InvalidQuery + "</span>";
				return;
			}

			List<string> categories = new List<string>();
			for(int i = 0; i < lstCategories.Items.Count; i++) {
				if(lstCategories.Items[i].Selected) categories.Add(lstCategories.Items[i].Value);
			}

			List<SearchMatch> results = null;
			if(chkFullSearch.Checked) {
				results = SearchTools.SearchFullText(txtSearch.Text, categories, chkUncategorized.Checked);
			}
			else {
				results = SearchTools.Search(txtSearch.Text, categories, chkUncategorized.Checked);
			}

			StringBuilder sb = new StringBuilder(500);

			sb.AppendFormat("<br /><br /><b>{0}</b> {1} <i>{2}</i><br /><br />", results.Count, Resources.Messages.ResultsFor, Server.HtmlEncode(txtSearch.Text));

			if(results.Count == 0) return;

			PageContent content;
			for(int i = 0; i < results.Count; i++) {
				content = Content.GetPageContent(results[i].PageInfo, true);
				sb.Append("<div style=\"margin-bottom: 10px;\"><b>");
				sb.AppendFormat(@"<a href=""{0}{1}"" title=""{2}"">{2}</a>", Tools.UrlEncode(results[i].PageInfo.Name), Settings.PageExtension, content.Title);
				sb.Append("</b>");
				if(results.Count > 1) sb.AppendFormat(" - {0}%", results[i].Relevance);
				if(results[i].IsExcerptAvailable) {
					sb.AppendFormat("<div style=\"padding-left: 20px; margin-bottom: 10px;\"><small>{0}</small></div>", results[i].FormattedExcerpt);
				}
				sb.Append("</div>");
			}

			lblResults.Text = sb.ToString();
		}

    }

}
