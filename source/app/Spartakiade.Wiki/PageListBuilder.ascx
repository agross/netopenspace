<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PageListBuilder.ascx.cs" Inherits="ScrewTurn.Wiki.PageListBuilder" %>

<anthem:TextBox ID="txtPageName" runat="server" CssClass="textbox" AutoUpdateAfterCallBack="True"
	meta:resourcekey="txtPageNameResource1" />
<anthem:Button ID="btnSearch" runat="server" Text="Search" ToolTip="Search for a Page"
	OnClick="btnSearch_Click" meta:resourcekey="btnSearchResource1" /><br />
<anthem:DropDownList ID="lstAvailablePage" runat="server" CssClass="dropdown" 
	meta:resourcekey="lstAvailablePageResource1" />
<anthem:Button ID="btnAddPage" runat="server" Text="Add" ToolTip="Add the selected Page to the list"
	Enabled="False" AutoUpdateAfterCallBack="True" OnClick="btnAddPage_Click" 
	meta:resourcekey="btnAddPageResource1" />

<div id="PagesListDiv">
	<anthem:ListBox ID="lstPages" runat="server" CssClass="listbox" AutoCallBack="True"
		OnSelectedIndexChanged="lstPages_SelectedIndexChanged" meta:resourcekey="lstPagesResource1" />
</div>

<anthem:Button ID="btnRemove" runat="server" Text="Remove" ToolTip="Remove the selected page from the list"
	Enabled="False" AutoUpdateAfterCallBack="True" OnClick="btnRemove_Click" meta:resourcekey="btnRemoveResource1" />
