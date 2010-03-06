<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeBehind="AdminGroups.aspx.cs" Inherits="ScrewTurn.Wiki.AdminGroups" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" %>

<%@ Register TagPrefix="st" TagName="ProviderSelector" Src="~/ProviderSelector.ascx" %>
<%@ Register TagPrefix="st" TagName="AclActionsSelector" Src="~/AclActionsSelector.ascx" %>

<asp:Content ID="ctnHead" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="ctnGroups" ContentPlaceHolderID="cphAdmin" runat="server">
	<h2 class="sectiontitle"><asp:Literal ID="lblGroups" runat="server" Text="User Groups" EnableViewState="False" meta:resourcekey="lblGroupsResource1" /></h2>
	
	<anthem:Panel ID="pnlList" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="pnlListResource1" UpdateAfterCallBack="True">
		<anthem:Button ID="btnNewGroup" runat="server" Text="New Group" ToolTip="Create a new User Group" OnClick="btnNewGroup_Click" CssClass="rightaligned" meta:resourcekey="btnNewGroupResource1" />
		
		<div id="GroupsListContainerDiv">
			<anthem:Repeater ID="rptGroups" runat="server" OnDataBinding="rptGroups_DataBinding" OnItemCommand="rptGroups_ItemCommand">
				<HeaderTemplate>
					<table cellpadding="0" cellspacing="0" class="generic">
						<thead>
						<tr class="tableheader">
							<th><asp:Literal ID="lblName" runat="server" EnableViewState="False" meta:resourcekey="lblNameResource1" Text="Name" /></th>
							<th><asp:Literal ID="lblDescription" runat="server" EnableViewState="False" meta:resourcekey="lblDescriptionResource1" Text="Description" /></th>
							<th><asp:Literal ID="lblProvider" runat="server" EnableViewState="False" meta:resourcekey="lblProviderResource1" Text="Provider" /></th>
							<th><asp:Literal ID="lblUsers" runat="server" EnableViewState="False" meta:resourcekey="lblUsersResource1" Text="Users" /></th>
							<th>&nbsp;</th>
						</tr>
						</thead>
						<tbody>
				</HeaderTemplate>
				<ItemTemplate>
					<tr class='tablerow<%# Eval("AdditionalClass") %>'>
						<td><%# Eval("Name") %></td>
						<td><%# Eval("Description") %></td>
						<td><%# Eval("Provider") %></td>
						<td><%# Eval("Users") %></td>
						<td><anthem:LinkButton ID="btnSelect" runat="server" Text="Select" ToolTip="Select this User Group" CommandName="Select" CommandArgument='<%# Eval("Name") %>' meta:resourcekey="btnSelectResource1" /></td>
					</tr>
				</ItemTemplate>
				<AlternatingItemTemplate>
					<tr class='tablerowalternate<%# Eval("AdditionalClass") %>'>
						<td><%# Eval("Name") %></td>
						<td><%# Eval("Description") %></td>
						<td><%# Eval("Provider") %></td>
						<td><%# Eval("Users") %></td>
						<td><anthem:LinkButton ID="btnSelect" runat="server" Text="Select" ToolTip="Select this User Group" CommandName="Select" CommandArgument='<%# Eval("Name") %>' meta:resourcekey="btnSelectResource2" /></td>
					</tr>
				</AlternatingItemTemplate>
				<FooterTemplate>
					</tbody>
					</table>
				</FooterTemplate>
			</anthem:Repeater>
		</div>
	</anthem:Panel>
	
	<anthem:Panel ID="pnlEditGroup" runat="server" AutoUpdateAfterCallBack="True" 
		Visible="False" meta:resourcekey="pnlEditGroupResource1">
		<div id="EditGroupDiv">
			<h2 class="separator"><asp:Literal ID="lblEditTitle" runat="server" Text="Group Details" EnableViewState="False" meta:resourcekey="lblEditTitleResource1" /></h2>
		
			<asp:Literal ID="lblProvider" runat="server" Text="Provider" EnableViewState="False" meta:resourcekey="lblProviderResource2" /><br />
			<st:ProviderSelector ID="providerSelector" runat="server" ExcludeReadOnly="true" ProviderType="Users" UsersProviderIntendedUse="GroupsManagement" /><br />
			
			<asp:Panel ID="pnlGroupDetails" runat="server" meta:resourcekey="pnlGroupDetailsResource1">
		
				<asp:Literal ID="lblName" runat="server" Text="Name" EnableViewState="False" meta:resourcekey="lblNameResource2" /><br />
				<asp:TextBox ID="txtName" runat="server" CssClass="textbox" ValidationGroup="group" meta:resourcekey="txtNameResource1" />
				<asp:RequiredFieldValidator ID="rfvName" runat="server" ErrorMessage="Name is required"
					CssClass="resulterror" ControlToValidate="txtName" Display="Dynamic" ValidationGroup="group" meta:resourcekey="rfvNameResource1" />
				<asp:RegularExpressionValidator ID="revName" runat="server" ErrorMessage="Invalid Name" EnableClientScript="false"
					CssClass="resulterror" ControlToValidate="txtName" Display="Dynamic" ValidationGroup="group" meta:resourcekey="revNameResource1" />
				<asp:CustomValidator ID="cvName" runat="server" ErrorMessage="Name already in use"
					CssClass="resulterror" ControlToValidate="txtName" Display="Dynamic" ValidationGroup="group"
					OnServerValidate="cvName_ServerValidate" meta:resourcekey="cvNameResource1" /><br />
					
				<asp:Literal ID="lblDescription" runat="server" Text="Description" EnableViewState="False" meta:resourcekey="lblDescriptionResource2" /><br />
				<asp:TextBox ID="txtDescription" runat="server" CssClass="textbox" ValidationGroup="group" meta:resourcekey="txtDescriptionResource1" /><br />
			
			</asp:Panel>
			
			<div id="AclSelectorDiv">
				<h3><asp:Literal ID="lblGlobalPermissions" runat="server" Text="Global Permissions" meta:resourcekey="lblGlobalPermissionsResource1" /></h3>
				<st:AclActionsSelector ID="aclActionsSelector" runat="server" CurrentResource="Globals" />
			</div>
			
			<div id="ButtonsDiv">
				<asp:Button ID="btnSave" runat="server" Text="Save Group" ToolTip="Save modifications"
					CssClass="button" Visible="False" OnClick="btnSave_Click" ValidationGroup="group" 
					meta:resourcekey="btnSaveResource1" />
				<asp:Button ID="btnCreate" runat="server" Text="Create Group" ToolTip="Save the new Group"
					CssClass="button" OnClick="btnCreate_Click" ValidationGroup="group" 
					meta:resourcekey="btnCreateResource1" />
				<anthem:Button ID="btnDelete" runat="server" Text="Delete" ToolTip="Delete the Group"
					CssClass="button" Visible="False" OnClick="btnDelete_Click" CausesValidation="False"
					ValidationGroup="group" PreCallBackFunction="RequestConfirm" 
					meta:resourcekey="btnDeleteResource1" />
				<asp:Button ID="btnCancel" runat="server" Text="Cancel" ToolTip="Cancel and return to the Group list"
					CssClass="button" OnClick="btnCancel_Click" CausesValidation="False" 
					ValidationGroup="group" meta:resourcekey="btnCancelResource1" />
					
				<anthem:Label ID="lblResult" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="lblResultResource1" UpdateAfterCallBack="True" />
			</div>
	
		</div>
	</anthem:Panel>
	
	<anthem:HiddenField ID="txtCurrentName" runat="server" AutoUpdateAfterCallBack="True" UpdateAfterCallBack="True" />
	
	<div style="clear: both;"></div>

</asp:Content>
