<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeBehind="AdminLog.aspx.cs" Inherits="ScrewTurn.Wiki.AdminLog" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" %>

<asp:Content ID="ctnHead" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="ctnLog" ContentPlaceHolderID="cphAdmin" runat="server">
	<h2 class="sectiontitle"><asp:Literal ID="lblLog" runat="server" Text="System Log" EnableViewState="False" meta:resourcekey="lblLogResource1" /></h2>
	
	<div id="LogControlsDiv">
		<div id="ButtonsDiv" class="log">
			<anthem:Button ID="btnClearLog" runat="server" Text="Clear Log" ToolTip="Clear the system log"
				CssClass="button" OnClick="btnClearLog_Click" PreCallBackFunction="RequestConfirm" meta:resourcekey="btnClearLogResource1" />
		</div>
	
		<asp:Literal ID="lblFilter" runat="server" Text="Display: " EnableViewState="False" meta:resourcekey="lblFilterResource1" />
		<anthem:CheckBox ID="chkMessages" runat="server" Text="Messages" Checked="True" 
			AutoCallBack="True" OnCheckedChanged="chkFilter_CheckedChanged" meta:resourcekey="chkMessagesResource1" />
		<anthem:CheckBox ID="chkWarnings" runat="server" Text="Warnings" Checked="True" 
			AutoCallBack="True" OnCheckedChanged="chkFilter_CheckedChanged" meta:resourcekey="chkWarningsResource1" />
		<anthem:CheckBox ID="chkErrors" runat="server" Text="Errors" Checked="True" 
			AutoCallBack="True" OnCheckedChanged="chkFilter_CheckedChanged" meta:resourcekey="chkErrorsResource1" />
		
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<anthem:Label ID="lblLimit" runat="server" Text="Currently displaying only 100 log entries &mdash;" AutoUpdateAfterCallBack="true"
			meta:resourcekey="lblLimitResource1" />
		<anthem:LinkButton ID="btnNoLimit" runat="server" Text="Display all" ToolTip="Display all log entries (might take a few seconds)"
			OnClick="btnNoLimit_Click" AutoUpdateAfterCallBack="true" meta:resourcekey="btnNoLimitResource1" />
	</div>
	
	<div id="LogListContainerDiv">
		<anthem:Repeater ID="rptLog" runat="server" AutoUpdateAfterCallBack="True"
			OnDataBinding="rptLog_DataBinding" UpdateAfterCallBack="True">
			<HeaderTemplate>
				<table class="generic" cellpadding="0" cellspacing="0">
					<thead>
					<tr class="tableheader">
						<th>&nbsp;</th>
						<th><asp:Literal ID="lblDateTime" runat="server" Text="Date/Time" EnableViewState="False" meta:resourcekey="lblDateTimeResource1" /></th>
						<th><asp:Literal ID="lblUser" runat="server" Text="User" EnableViewState="False" meta:resourcekey="lblUserResource1" /></th>
						<th><asp:Literal ID="lblMessage" runat="server" Text="Message" EnableViewState="False" meta:resourcekey="lblMessageResource1" /></th>
					</tr>
					</thead>
					<tbody>
			</HeaderTemplate>
			<ItemTemplate>
				<tr class='tablerow<%# Eval("AdditionalClass") %>'>
					<td><img src='Images/Log<%# Eval("ImageTag") %>.png' alt="Log" /></td>
					<td><%# Eval("DateTime") %></td>
					<td><%# Eval("User") %></td>
					<td><%# Eval("Message") %></td>
				</tr>
			</ItemTemplate>
			<AlternatingItemTemplate>
				<tr class='tablerowalternate<%# Eval("AdditionalClass") %>'>
					<td><img src='Images/Log<%# Eval("ImageTag") %>.png' alt="Log" /></td>
					<td><%# Eval("DateTime") %></td>
					<td><%# Eval("User") %></td>
					<td><%# Eval("Message") %></td>
				</tr>
			</AlternatingItemTemplate>
			<FooterTemplate>
				</tbody>
				</table>
			</FooterTemplate>
		</anthem:Repeater>
	</div>
	
	<div style="clear: both;"></div>

</asp:Content>
