<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="Search.aspx.cs" Inherits="ScrewTurn.Wiki.Search" ValidateRequest="false" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" %>

<asp:Content ID="ctnSearch" ContentPlaceHolderID="CphMaster" runat="server">
	<asp:Literal ID="lblStrings" runat="server" />

	<script type="text/javascript">
	<!--
		function ToggleCategoriesList() {
			var chk = document.getElementById(AllNamespacesCheckbox);
			if(chk.checked) document.getElementById("CategoryFilterDiv").style["display"] = "none";
			else document.getElementById("CategoryFilterDiv").style["display"] = "";
		}
	// -->
	</script>

	<h1 class="pagetitlesystem"><asp:Literal ID="lblTitle" runat="server" Text="Search Engine" EnableViewState="False" meta:resourcekey="lblTitleResource1" /></h1>
	<p><asp:Literal ID="lblInstructions" runat="server" Text="Here you can search through the pages of this Namespace, their attachments and the files uploaded to the system.<br /><b>Note</b>: the results will only display the items you have permissions to read." EnableViewState="False" meta:resourcekey="lblInstructionsResource1" /></p>
	
	<div id="SearchControlsDiv">
		<asp:TextBox ID="txtQuery" runat="server" CssClass="textbox" meta:resourcekey="txtQueryResource1" />
		<asp:Button ID="btnGo" runat="server" Text="Go" EnableViewState="False" CssClass="button" OnClick="btnGo_Click" meta:resourcekey="btnGoResource1" /><br />
		
		<div id="RadiosDiv">
			<asp:RadioButton ID="rdoAtLeastOneWord" runat="server" Text="At least one word" Checked="True" GroupName="search" meta:resourcekey="rdoAtLeastOneWordResource1" />
			<asp:RadioButton ID="rdoAllWords" runat="server" Text="All words" GroupName="search" meta:resourcekey="rdoAllWordsResource1" />
			<asp:RadioButton ID="rdoExactPhrase" runat="server" Text="Exact phrase" GroupName="search" meta:resourcekey="rdoExactPhraseResource1" />
		</div>
		
		<asp:CheckBox ID="chkAllNamespaces" runat="server" Text="Search in all Namespaces and all Categories" Checked="true" onclick="javascript:ToggleCategoriesList();" meta:resourcekey="chkAllNamespacesResource1" />
		<br />
		<asp:CheckBox ID="chkFilesAndAttachments" runat="server" Text="Search Files and Attachments" Checked="true" meta:resourcekey="chkFilesAndAttachmentsResource1" />
	</div>
	
	<div id="CategoryFilterDiv">
		<h4><asp:Literal ID="lblCategoryFilter" runat="server" Text="Filter by Category" EnableViewState="False" meta:resourcekey="lblCategoryFilterResource1" /></h4>
		<a href="#" onclick="javascript:$('#CategoryFilterInternalDiv input').each(function() { $(this).get(0).checked = true; }); return false;"><asp:Literal ID="lblSelectAll" runat="server" Text="Select all" meta:resourcekey="lblSelectAllResource1" /></a> &mdash;
		<a href="#" onclick="javascript:$('#CategoryFilterInternalDiv input').each(function() { $(this).get(0).checked = false; }); return false;"><asp:Literal ID="lblSelectNone" runat="server" Text="None" meta:resourcekey="lblSelectNoneResource1" /></a> &mdash;
		<a href="#" onclick="javascript:$('#CategoryFilterInternalDiv input').each(function() { $(this).get(0).checked = !$(this).get(0).checked; });return false;"><asp:Literal ID="lblSelectInverse" runat="server" Text="Invert" meta:resourcekey="lblSelectInverseResource1" /></a>
		<div id="CategoryFilterInternalDiv">
			<i><asp:CheckBox ID="chkUncategorizedPages" runat="server" Text="Uncategorized Pages" Checked="True" meta:resourcekey="chkUncategorizedPagesResource1" /></i><br />
			<asp:CheckBoxList ID="lstCategories" runat="server" RepeatLayout="Flow" meta:resourcekey="lstCategoriesResource1" />
		</div>
	</div>
	
	<div id="SearchStatsDiv">
		<asp:Literal ID="lblStats" runat="server" meta:resourcekey="lblStatsResource1" />
	</div>
	
	<div id="ResultsDiv">
		<asp:Repeater ID="rptResults" runat="server">
			<ItemTemplate>
				<h3 class='searchresult<%# Eval("Type") %>'><a href='<%# Eval("Link") %>' title='<%# Eval("Title") %>'><%# Eval("Title") %></a> &mdash; <%# Eval("Relevance", "{0:N1}") %>%</h3>
				<p class="excerpt" style='<%# (((string)Eval("FormattedExcerpt")).Length > 0 ? "" : "display: none;") %>'><%# Eval("FormattedExcerpt") %></p>
			</ItemTemplate>
		</asp:Repeater>
	</div>
	
	<asp:Literal ID="lblHideCategoriesScript" runat="server" />
	
	<script type="text/javascript">
		ToggleCategoriesList();
	</script>
	
</asp:Content>
