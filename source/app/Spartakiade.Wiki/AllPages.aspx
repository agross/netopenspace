<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="ScrewTurn.Wiki.AllPages" Title="Untitled Page" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="AllPages.aspx.cs" %>

<%@ Register TagPrefix="st" TagName="PageSelector" Src="~/PageSelector.ascx" %>

<asp:Content ID="CtnPages" ContentPlaceHolderID="CphMaster" Runat="Server">

	<h1 class="pagetitlesystem"><asp:Literal ID="lblPages" runat="server" Text="Page Index" meta:resourcekey="lblPagesResource1" EnableViewState="False" /></h1>
	<p><asp:Literal ID="lblDescription" runat="server" Text="The list of all pages contained in the current namespace." meta:resourcekey="lblDescriptionResource1" EnableViewState="False" /></p>
	<br />
	
	<asp:HyperLink ID="lnkCategories" runat="server" Text="Page Categories" ToolTip="View all Page Categories" meta:resourcekey="lnkCategoriesResource1" />
	&bull;
	<asp:HyperLink ID="lnkSearch" runat="server" Text="Search" ToolTip="Perform a Search" meta:resourcekey="lnkSearchResource1" />
	
	<div id="PageSelectorDiv">
		<st:PageSelector ID="pageSelector" runat="server" PageSize="<%# PageSize %>" OnSelectedPageChanged="pageSelector_SelectedPageChanged" />
	</div>
   
	<anthem:Panel ID="pnlPageList" runat="server" EnableViewState="False" AutoUpdateAfterCallBack="True" meta:resourcekey="pnlPageListResource1" UpdateAfterCallBack="True" />

</asp:Content>
