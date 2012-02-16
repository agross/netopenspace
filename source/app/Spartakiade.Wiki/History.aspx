<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="ScrewTurn.Wiki.History" Title="Untitled Page" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="History.aspx.cs" %>

<asp:Content ID="CtnHistory" ContentPlaceHolderID="CphMaster" Runat="Server">

    <h1 class="pagetitlesystem"><asp:Literal ID="lblTitle" runat="server" meta:resourcekey="lblTitleResource1" Text="-- Title --" /></h1>
    <p><asp:Literal ID="lblCompare" runat="server" Text="Compare Page Revisions" meta:resourcekey="lblCompareResource1" /></p> 
    <asp:DropDownList ID="lstRev1" runat="server" meta:resourcekey="lstRev1Resource1" />
    <asp:DropDownList ID="lstRev2" runat="server" meta:resourcekey="lstRev2Resource1" />
    <asp:Button ID="btnCompare" runat="server" Text="Compare" OnClick="btnCompare_Click" meta:resourcekey="btnCompareResource1" />
    <br /><br />
    
    <asp:Literal ID="lblHistory" runat="server" meta:resourcekey="lblHistoryResource1" />
    
    <asp:Repeater ID="rptHistory" runat="server" OnItemCommand="rptHistory_ItemCommand">
		<HeaderTemplate>
			<table id="HistoryTable" class="generic" cellpadding="0" cellspacing="0">
				<thead>
				<tr class="tableheader">
					<th style="text-align: right;">#</th>
					<th><asp:Literal ID="lblTitle" runat="server" Text="Title" EnableViewState="False" meta:resourcekey="lblTitleResource2" /></th>
					<th><asp:Literal ID="lblSavedOn" runat="server" Text="Saved on" EnableViewState="False" meta:resourcekey="lblSavedOnResource1" /></th>
					<th><asp:Literal ID="lblSavedBy" runat="server" Text="Saved by" EnableViewState="False" meta:resourcekey="lblSavedByResource1" /></th>
					<th><asp:Literal ID="lblComment" runat="server" Text="Comment" EnableViewState="False" meta:resourcekey="lblCommentResource1" /></th>
					<th>&nbsp;</th>
				</tr>
				</thead>
				<tbody>
		</HeaderTemplate>
		<ItemTemplate>
			<tr class="tablerow">
				<td style="text-align: right;"><%# Eval("Revision") %></td>
				<td><a href='<%# ScrewTurn.Wiki.UrlTools.BuildUrl("History.aspx?Page=", ScrewTurn.Wiki.Tools.UrlEncode((string)Eval("Page")), "&amp;Revision=", (string)Eval("Revision")) %>'><%# Eval("Title") %></a></td>
				<td><%# Eval("SavedOn") %></td>
				<td><%# Eval("SavedBy") %></td>
				<td><%# Eval("Comment") %></td>
				<td><asp:LinkButton ID="btnRollback" runat="server" Visible='<%# (bool)Eval("CanRollback") %>' Text="Rollback" CommandName="Rollback" CommandArgument='<%# Eval("Revision") %>' 
						OnClientClick="javascript:return __RequestConfirm();" meta:resourcekey="btnRollbackResource2" /></td>
			</tr>
		</ItemTemplate>
		<AlternatingItemTemplate>
			<tr class="tablerowalternate">
				<td style="text-align: right;"><%# Eval("Revision") %></td>
				<td><a href='<%# ScrewTurn.Wiki.UrlTools.BuildUrl("History.aspx?Page=", ScrewTurn.Wiki.Tools.UrlEncode((string)Eval("Page")), "&amp;Revision=", (string)Eval("Revision")) %>'><%# Eval("Title") %></a></td>
				<td><%# Eval("SavedOn") %></td>
				<td><%# Eval("SavedBy") %></td>
				<td><%# Eval("Comment") %></td>
				<td><asp:LinkButton ID="btnRollback" runat="server" Visible='<%# (bool)Eval("CanRollback") %>' Text="Rollback" CommandName="Rollback" CommandArgument='<%# Eval("Revision") %>' 
						OnClientClick="javascript:return __RequestConfirm();" meta:resourcekey="btnRollbackResource1" /></td>
			</tr>
		</AlternatingItemTemplate>
		<FooterTemplate>
			</tbody>
			</table>
		</FooterTemplate>
    </asp:Repeater>

</asp:Content>
