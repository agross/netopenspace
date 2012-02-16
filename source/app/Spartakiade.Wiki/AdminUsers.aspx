<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeBehind="AdminUsers.aspx.cs" Inherits="ScrewTurn.Wiki.AdminUsers" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" %>

<%@ Register TagPrefix="st" TagName="ProviderSelector" Src="~/ProviderSelector.ascx" %>
<%@ Register TagPrefix="st" TagName="AclActionsSelector" Src="~/AclActionsSelector.ascx" %>
<%@ Register TagPrefix="st" TagName="PageSelector" Src="~/PageSelector.ascx" %>

<asp:Content ID="ctnHead" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="ctnAdminUsers" ContentPlaceHolderID="cphAdmin" runat="server">
	<script type="text/javascript">
	<!--
		function PreBulkDelete() {
			if(RequestConfirm()) {
				document.getElementById("BulkDeleteProgressSpan").style["display"] = "";
				return true;
			}
			else return false;
		}

		function PostBulkDelete() {
			document.getElementById("BulkDeleteProgressSpan").style["display"] = "none";
			return true;
		}
	// -->
	</script>

	<h2 class="sectiontitle"><asp:Literal ID="lblAccounts" runat="server" Text="User Accounts" EnableViewState="False" meta:resourcekey="lblAccountsResource1" /></h2>
	
	<anthem:Panel ID="pnlList" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="pnlListResource1" UpdateAfterCallBack="True">
		<div class="rightaligned">
			<anthem:Button ID="btnNewUser" runat="server" Text="New User" ToolTip="Create a new User" OnClick="btnNewUser_Click"
				meta:resourcekey="btnNewUserResource1" />
			<br /><br /><br /><br />
			<h2 class="separator"><asp:Literal ID="lblBulkDeleteTitle" runat="server" Text="Bulk Delete" EnableViewState="false" meta:resourcekey="lblBulkDeleteTitleResource1" /></h2>
			<asp:Literal ID="lblBulkDelete" runat="server" Text="Delete all <b>inactive</b> accounts older than <b>1 month</b>.<br />Please backup your data before proceeding."
				EnableViewState="false" meta:resourcekey="lblBulkDeleteResource1" />
			<br /><br />
			<anthem:Button ID="btnBulkDelete" runat="server" Text="Delete" ToolTip="Delete old inactive accounts now" OnClick="btnBulkDelete_Click"
				meta:resourcekey="btnBulkDeleteResource1" PreCallBackFunction="PreBulkDelete" PostCallBackFunction="PostBulkDelete" />
			<span id="BulkDeleteProgressSpan" style="display: none;">
				<img src="Images/Wait.gif" alt="Deleting..." />
			</span>
			<br />
			<anthem:Label ID="lblBulkDeleteResult" runat="server" AutoUpdateAfterCallBack="true" />
		</div>
	
		<asp:Literal ID="lblFilter" runat="server" Text="Display: " EnableViewState="False" meta:resourcekey="lblFilterResource1" />
		<anthem:CheckBox ID="chkActive" runat="server" Text="Active Accounts" Checked="True" AutoCallBack="True" OnCheckedChanged="chkFilter_CheckedChanged" meta:resourcekey="chkActiveResource1" />
		<anthem:CheckBox ID="chkInactive" runat="server" Text="Inactive Accounts" Checked="True" AutoCallBack="True" OnCheckedChanged="chkFilter_CheckedChanged" meta:resourcekey="chkInactiveResource1" />
		
		<anthem:TextBox ID="txtFilter" runat="server" CssClass="searchtextbox" ToolTip="Filter Accounts by Username" meta:resourcekey="txtFilterResource1" />
		<anthem:ImageButton ID="btnFilter" runat="server" ToolTip="Apply Filter" ImageUrl="~/Images/Filter.png"
			ImageUrlDuringCallBack="~/Images/Filter.png" EnableViewState="False" CssClass="imagebutton" OnClick="btnFilter_Click" 
			meta:resourcekey="btnFilterResource1" />
		
		<div id="PageSelectorDiv">
			<st:PageSelector ID="pageSelector" runat="server" PageSize='<%# PageSize %>' OnSelectedPageChanged="pageSelector_SelectedPageChanged" />
		</div>
	
		<div id="UsersListContainerDiv">
			<anthem:Repeater ID="rptAccounts" runat="server" AutoUpdateAfterCallBack="true"
				OnDataBinding="rptAccounts_DataBinding" OnItemCommand="rptAccounts_ItemCommand">
				<HeaderTemplate>
					<table cellpadding="0" cellspacing="0" class="generic">
						<thead>
						<tr class="tableheader">
							<th><asp:Literal ID="lblUsername" runat="server" EnableViewState="False" meta:resourcekey="lblUsernameResource1" Text="Username" /></th>
							<th><asp:Literal ID="lblDisplayName" runat="server" EnableViewState="False" meta:resourcekey="lblDisplayNameResource1" Text="Display Name" /></th>
							<th><asp:Literal ID="lblEmail" runat="server" EnableViewState="False" meta:resourcekey="lblEmailResource1" Text="Email" /></th>
							<th><asp:Literal ID="lblMemberOf" runat="server" EnableViewState="False" meta:resourcekey="lblMemberOfResource1" Text="Member of" /></th>
							<th><asp:Literal ID="lblRegDateTime" runat="server" EnableViewState="False" meta:resourcekey="lblRegDateTimeResource1" Text="Reg. Date/Time" /></th>
							<th><asp:Literal ID="lblProvider" runat="server" EnableViewState="False" meta:resourcekey="lblProviderResource1" Text="Provider" /></th>
							<th>&nbsp;</th>
						</tr>
						</thead>
						<tbody>
				</HeaderTemplate>
				<ItemTemplate>
					<tr class='tablerow<%# Eval("AdditionalClass") %>'>
						<td><a href='User.aspx?Username=<%# Eval("Username") %>' target="_blank" title='<%= ScrewTurn.Wiki.Properties.Messages.SendAMessage %>'><%# Eval("Username") %></a></td>
						<td><%# Eval("DisplayName") %></td>
						<td><a href='mailto:<%# Eval("Email") %>' title='<%# Eval("Email") %>'><%# Eval("Email") %></a></td>
						<td><%# Eval("MemberOf") %></td>
						<td><%# Eval("RegDateTime") %></td>
						<td><%# Eval("Provider") %></td>
						<td><anthem:LinkButton ID="btnSelect" runat="server" Text="Select" ToolTip="Select this Account" CommandName="Select" 
								CommandArgument='<%# Eval("Username") %>' meta:resourcekey="btnSelectResource1" /></td>
					</tr>
				</ItemTemplate>
				<AlternatingItemTemplate>
					<tr class='tablerowalternate<%# Eval("AdditionalClass") %>'>
						<td><a href='User.aspx?Username=<%# Eval("Username") %>' target="_blank" title='<%= ScrewTurn.Wiki.Properties.Messages.SendAMessage %>'><%# Eval("Username") %></a></td>
						<td><%# Eval("DisplayName") %></td>
						<td><a href='mailto:<%# Eval("Email") %>' title='<%# Eval("Email") %>'><%# Eval("Email") %></a></td>
						<td><%# Eval("MemberOf") %></td>
						<td><%# Eval("RegDateTime") %></td>
						<td><%# Eval("Provider") %></td>
						<td><anthem:LinkButton ID="btnSelect" runat="server" Text="Select" ToolTip="Select this Account" CommandName="Select"
								CommandArgument='<%# Eval("Username") %>' meta:resourcekey="btnSelectResource1" /></td>
					</tr>
				</AlternatingItemTemplate>
				<FooterTemplate>
					</tbody>
					</table>
				</FooterTemplate>
			</anthem:Repeater>
		</div>
	</anthem:Panel>
	
	<anthem:Panel ID="pnlEditAccount" runat="server" AutoUpdateAfterCallBack="True" Visible="False" meta:resourcekey="pnlEditAccountResource1" UpdateAfterCallBack="True">
		<div id="EditAccountDiv">
			<h2 class="separator"><asp:Literal ID="lblEditTitle" runat="server" Text="Account Details" EnableViewState="False" meta:resourcekey="lblEditTitleResource1" /></h2>
		
			<asp:Literal ID="lblProvider" runat="server" Text="Provider" EnableViewState="False" meta:resourcekey="lblProviderResource2" /><br />
			<st:ProviderSelector ID="providerSelector" runat="server" ExcludeReadOnly="true" ProviderType="Users" UsersProviderIntendedUse="AccountsManagement"
				AutoPostBack="true" OnSelectedProviderChanged="providerSelector_SelectedProviderChanged" /><br />
				
			<asp:Panel ID="pnlAccountDetails" runat="server" meta:resourcekey="pnlAccountDetailsResource1">
		
				<asp:Literal ID="lblUsername" runat="server" Text="Username" EnableViewState="False" meta:resourcekey="lblUsernameResource2" /><br />
				<asp:TextBox ID="txtUsername" runat="server" CssClass="textbox" ValidationGroup="account" meta:resourcekey="txtUsernameResource1" />
				<asp:RequiredFieldValidator ID="rfvUsername" runat="server" ErrorMessage="Username is required"
					CssClass="resulterror" ControlToValidate="txtUsername" Display="Dynamic" ValidationGroup="account" meta:resourcekey="rfvUsernameResource1" />
				<asp:RegularExpressionValidator ID="revUsername" runat="server" ErrorMessage="Invalid Username" EnableClientScript="false"
					CssClass="resulterror" ControlToValidate="txtUsername" Display="Dynamic" ValidationGroup="account" meta:resourcekey="revUsernameResource1" />
				<asp:CustomValidator ID="cvUsername" runat="server" ErrorMessage="Username already in use"
					CssClass="resulterror" ControlToValidate="txtUsername" Display="Dynamic" ValidationGroup="account"
					OnServerValidate="cvUsername_ServerValidate" meta:resourcekey="cvUsernameResource1" /><br />
				
				<asp:Literal ID="lblDisplayName" runat="server" Text="Display Name" EnableViewState="False" meta:resourcekey="lblDisplayNameResource2" /><br />
				<asp:TextBox ID="txtDisplayName" runat="server" CssClass="textbox" ValidationGroup="account" meta:resourcekey="txtDisplayNameResource1" />
				<asp:RegularExpressionValidator ID="revDisplayName" runat="server" ErrorMessage="Invalid Display Name" EnableClientScript="false"
					CssClass="resulterror" ControlToValidate="txtDisplayName" Display="Dynamic" ValidationGroup="account" meta:resourcekey="revDisplayNameResource1" /><br />
				
				<asp:Literal ID="lblPassword1" runat="server" Text="Password" EnableViewState="False" meta:resourcekey="lblPassword1Resource1" /><br />
				<asp:TextBox ID="txtPassword1" runat="server" TextMode="Password" CssClass="textbox" ValidationGroup="account" meta:resourcekey="txtPassword1Resource1" />
				<asp:RequiredFieldValidator ID="rfvPassword1" runat="server" ErrorMessage="Password is required"
					CssClass="resulterror" ControlToValidate="txtPassword1" Display="Dynamic" ValidationGroup="account" meta:resourcekey="rfvPassword1Resource1" />
				<asp:RegularExpressionValidator ID="revPassword1" runat="server" ErrorMessage="Invalid Password" EnableClientScript="false"
					CssClass="resulterror" ControlToValidate="txtPassword1" Display="Dynamic" ValidationGroup="account" meta:resourcekey="revPassword1Resource1" /><br />
					
				<asp:Literal ID="lblPassword2" runat="server" Text="Password (repeat)" EnableViewState="False" meta:resourcekey="lblPassword2Resource1" /><br />
				<asp:TextBox ID="txtPassword2" runat="server" TextMode="Password" CssClass="textbox" ValidationGroup="account" meta:resourcekey="txtPassword2Resource1" />
				<asp:CustomValidator ID="cvPassword2" runat="server" ErrorMessage="Passwords must be equal"
					CssClass="resulterror" ControlToValidate="txtPassword2" Display="Dynamic" ValidationGroup="account"
					OnServerValidate="cvPassword2_ServerValidate" ValidateEmptyText="True" meta:resourcekey="cvPassword2Resource1" /><br />
				
				<asp:Literal ID="lblEmail" runat="server" Text="Email" EnableViewState="False" meta:resourcekey="lblEmailResource2" /><br />
				<asp:TextBox ID="txtEmail" runat="server" CssClass="textbox" ValidationGroup="account" meta:resourcekey="txtEmailResource1" />
				<asp:RequiredFieldValidator ID="rfvEmail" runat="server" ErrorMessage="Email is required"
					CssClass="resulterror" ControlToValidate="txtEmail" Display="Dynamic" ValidationGroup="account" meta:resourcekey="rfvEmailResource1" />
				<asp:RegularExpressionValidator ID="revEmail" runat="server" ErrorMessage="Invalid Email" EnableClientScript="false"
					CssClass="resulterror" ControlToValidate="txtEmail" Display="Dynamic" ValidationGroup="account" meta:resourcekey="revEmailResource1" /><br />
				
				<asp:CheckBox ID="chkSetActive" runat="server" Text="Active" Checked="True" ToolTip="If checked, allows the user to login" meta:resourcekey="chkSetActiveResource1" /><br />
				
				<asp:Label ID="lblPasswordInfo" runat="server" Text="Leave Password fields blank to keep the current password."
					CssClass="verticalpadding block" Visible="False" meta:resourcekey="lblPasswordInfoResource1" />
					
			</asp:Panel>
			
			<div id="AclSelectorDiv">
				<h3><asp:Literal ID="lblGlobalPermissions" runat="server" Text="Global Permissions" meta:resourcekey="lblGlobalPermissionsResource1" /></h3>
				<st:AclActionsSelector ID="aclActionsSelector" runat="server" CurrentResource="Globals" />
			</div>
			<div id="MembershipDiv">
				<h3><asp:Literal ID="lblMembership" runat="server" Text="Group Membership" meta:resourcekey="lblMembershipResource1" /></h3>
				<asp:CheckBoxList ID="lstGroups" runat="server" meta:resourcekey="lstGroupsResource1" />
			</div>
			
			<div id="ButtonsDiv">
				<asp:Button ID="btnSave" runat="server" Text="Save Account" ToolTip="Save modifications"
					CssClass="button" Visible="False" OnClick="btnSave_Click" ValidationGroup="account" meta:resourcekey="btnSaveResource1" />
				<asp:Button ID="btnCreate" runat="server" Text="Create Account" ToolTip="Save the new Account"
					CssClass="button" OnClick="btnCreate_Click" ValidationGroup="account" meta:resourcekey="btnCreateResource1" />
				<anthem:Button ID="btnDelete" runat="server" Text="Delete" ToolTip="Delete the Account"
					CssClass="button" Visible="False" OnClick="btnDelete_Click" CausesValidation="False"
					ValidationGroup="account" PreCallBackFunction="RequestConfirm" meta:resourcekey="btnDeleteResource1" />
				<asp:Button ID="btnCancel" runat="server" Text="Cancel" ToolTip="Cancel and return to the Account list"
					CssClass="button" OnClick="btnCancel_Click" CausesValidation="False" ValidationGroup="account" meta:resourcekey="btnCancelResource1" />
					
				<anthem:Label ID="lblResult" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="lblResultResource1" UpdateAfterCallBack="True" />
			</div>
		</div>
	</anthem:Panel>
	
	<anthem:HiddenField ID="txtCurrentUsername" runat="server" AutoUpdateAfterCallBack="True" UpdateAfterCallBack="True" />
	
	<div style="clear: both;"></div>
	
</asp:Content>
