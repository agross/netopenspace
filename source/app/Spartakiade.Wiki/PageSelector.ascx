<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PageSelector.ascx.cs" Inherits="ScrewTurn.Wiki.PageSelector" %>

<anthem:Repeater ID="rptPages" runat="server" OnItemCommand="rptPages_ItemCommand" AutoUpdateAfterCallBack="true">
	<ItemTemplate>
		<anthem:LinkButton ID="lnkPage" runat="server" Text='<%# Eval("Text") %>'
			CommandName="Select" CommandArgument='<%# Eval("Page") %>'
			CssClass='<%# (bool)Eval("Selected") ? "selected" : "" %>' />
	</ItemTemplate>
</anthem:Repeater>
