<%@ Control Language="C#" AutoEventWireup="true" Inherits="ScrewTurn.Wiki.AttachmentViewer" Codebehind="AttachmentViewer.ascx.cs" %>

<anthem:Repeater ID="rptItems" runat="server" AutoUpdateAfterCallBack="True" 
	OnDataBinding="rptItems_DataBinding" UpdateAfterCallBack="True">
	<HeaderTemplate>
		<table id="AttachmentViewerTable" class="generic" cellpadding="0" cellspacing="0">
			<thead>
			<tr class="tableheader">
				<th>&nbsp;</th>
				<th><asp:Literal ID="lblName" runat="server" Text="Name" EnableViewState="False" meta:resourcekey="lblNameResource1" /></th>
				<th><asp:Literal ID="lblSize" runat="server" Text="Size" EnableViewState="False" meta:resourcekey="lblSizeResource1" /></th>
			</tr>
			</thead>
			<tbody>
	</HeaderTemplate>
	<ItemTemplate>
		<tr class="tablerow">
			<td><img src="Images/File.png" alt="-" /></td>
			<td><a href='<%# Eval("Link") %>' title="<%# ScrewTurn.Wiki.Properties.Messages.Download %>"><%# Eval("Name") %></a></td>
			<td><%# Eval("Size") %></td>
		</tr>
	</ItemTemplate>
	<AlternatingItemTemplate>
		<tr class="tablerowalternate">
			<td><img src="Images/File.png" alt="-" /></td>
			<td><a href='<%# Eval("Link") %>' title="<%# ScrewTurn.Wiki.Properties.Messages.Download %>"><%# Eval("Name") %></a></td>
			<td><%# Eval("Size") %></td>
		</tr>
	</AlternatingItemTemplate>
	<FooterTemplate>
		</tbody>
		</table>
	</FooterTemplate>
</anthem:Repeater>
