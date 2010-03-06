<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeBehind="AdminNamespaces.aspx.cs" Inherits="ScrewTurn.Wiki.AdminNamespaces" culture="auto" meta:resourcekey="PageResource3" uiculture="auto" %>

<%@ Register TagPrefix="st" TagName="ProviderSelector" Src="~/ProviderSelector.ascx" %>
<%@ Register TagPrefix="st" TagName="PermissionsManager" Src="~/PermissionsManager.ascx" %>

<asp:Content ID="ctnHead" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="ctnNamespaces" ContentPlaceHolderID="cphAdmin" runat="server">
	<h2 class="sectiontitle"><asp:Literal ID="lblNamespaces" runat="server" Text="Namespaces" EnableViewState="False" meta:resourcekey="lblNamespacesResource1" /></h2>
	
	<anthem:Panel ID="pnlList" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="pnlListResource1" UpdateAfterCallBack="True">
		<anthem:Button ID="btnNewNamespace" runat="server" Text="New Namespace" ToolTip="Create a new Namespace" CssClass="rightaligned" OnClick="btnNewNamespace_Click" meta:resourcekey="btnNewNamespaceResource1" />
		
		<div id="NamespacesListContainerDiv">
			<anthem:Repeater ID="rptNamespaces" runat="server" OnDataBinding="rptNamespaces_DataBinding" OnItemCommand="rptNamespaces_ItemCommand">
				<HeaderTemplate>
					<table cellpadding="0" cellspacing="0" class="generic">
						<thead>
						<tr class="tableheader">
							<th><asp:Literal ID="lblName" runat="server" EnableViewState="False" meta:resourcekey="lblNameResource1" Text="Name" /></th>
							<th><asp:Literal ID="lblDefaultPage" runat="server" EnableViewState="False" meta:resourcekey="lblDefaultPageResource1" Text="Default Page" /></th>
							<th><asp:Literal ID="lblPages" runat="server" EnableViewState="False" meta:resourcekey="lblPagesResource1" Text="Pages" /></th>
							<th><asp:Literal ID="lblCategories" runat="server" EnableViewState="False" meta:resourcekey="lblCategoriesResource1" Text="Categories" /></th>
							<th><asp:Literal ID="lblTheme" runat="server" EnableViewState="False" meta:resourcekey="lblThemeResource1" Text="Theme" /></th>
							<th><asp:Literal ID="lblProvider" runat="server" EnableViewState="False" meta:resourcekey="lblProviderResource1" Text="Provider" /></th>
							<th>&nbsp;</th>
						</tr>
						</thead>
						<tbody>
				</HeaderTemplate>
				<ItemTemplate>
					<tr class='tablerow<%# Eval("AdditionalClass") %>'>
						<td><a href='<%# Eval("DefaultPage") %><%= ScrewTurn.Wiki.Settings.PageExtension %>' title='<%= ScrewTurn.Wiki.Properties.Messages.GoToMainPage %>' target="_blank"><%# Eval("Name") %></a></td>
						<td><%# ScrewTurn.Wiki.PluginFramework.NameTools.GetLocalName((string)Eval("DefaultPage")) %></td>
						<td><%# Eval("PageCount") %></td>
						<td><%# Eval("CategoryCount") %></td>
						<td><%# Eval("Theme") %></td>
						<td><%# Eval("Provider") %></td>
						<td>
							<anthem:LinkButton ID="btnSelect" runat="server" Text="Select" ToolTip="Select this Namespace for editing" CommandName="Select" CommandArgument='<%# Eval("Name") %>' meta:resourcekey="btnSelectResource1" />
							&bull;
							<anthem:LinkButton ID="btnPerms" runat="server" Visible='<%# (bool)Eval("CanSetPermissions") %>' Text="Permissions" ToolTip="Manage permissions for this Namespace" CommandName="Perms" CommandArgument='<%# Eval("Name") %>' meta:resourcekey="btnPermsResource1" />
						</td>
					</tr>
				</ItemTemplate>
				<AlternatingItemTemplate>
					<tr class='tablerowalternate<%# Eval("AdditionalClass") %>'>
						<td><a href='<%# Eval("DefaultPage") %><%= ScrewTurn.Wiki.Settings.PageExtension %>' title='<%= ScrewTurn.Wiki.Properties.Messages.GoToMainPage %>' target="_blank"><%# Eval("Name") %></a></td>
						<td><%# ScrewTurn.Wiki.PluginFramework.NameTools.GetLocalName((string)Eval("DefaultPage")) %></td>
						<td><%# Eval("PageCount") %></td>
						<td><%# Eval("CategoryCount") %></td>
						<td><%# Eval("Theme") %></td>
						<td><%# Eval("Provider") %></td>
						<td>
							<anthem:LinkButton ID="btnSelect" runat="server" Text="Select" ToolTip="Select this Namespace for editing" CommandName="Select" CommandArgument='<%# Eval("Name") %>' meta:resourcekey="btnSelectResource2" />
							&bull;
							<anthem:LinkButton ID="btnPerms" runat="server" Visible='<%# (bool)Eval("CanSetPermissions") %>' Text="Permissions" ToolTip="Manage permissions for this Namespace" CommandName="Perms" CommandArgument='<%# Eval("Name") %>' meta:resourcekey="btnPermsResource2" />
						</td>
					</tr>
				</AlternatingItemTemplate>
				<FooterTemplate>
					</tbody>
					</table>
				</FooterTemplate>
			</anthem:Repeater>
		</div>
	</anthem:Panel>
	
	<anthem:Panel ID="pnlEditNamespace" runat="server" AutoUpdateAfterCallBack="True" Visible="False" 
		meta:resourcekey="pnlEditNamespaceResource1" UpdateAfterCallBack="True">
		<div id="EditNamespaceDiv">
			<h2 class="separator"><asp:Literal ID="lblEditTitle" runat="server" Text="Namespace Details" EnableViewState="False" meta:resourcekey="lblEditTitleResource1" /></h2>
		
			<asp:Literal ID="lblProvider" runat="server" Text="Provider" EnableViewState="False" meta:resourcekey="lblProviderResource2" /><br />
			<st:ProviderSelector ID="providerSelector" runat="server" ExcludeReadOnly="true" ProviderType="Pages" /><br />
			
			<asp:Literal ID="lblName" runat="server" Text="Name" EnableViewState="False" meta:resourcekey="lblNameResource2" /><br />
			<asp:TextBox ID="txtName" runat="server" CssClass="textbox" ValidationGroup="group" meta:resourcekey="txtNameResource1" />
			<asp:RequiredFieldValidator ID="rfvName" runat="server" ErrorMessage="Name is required"
				CssClass="resulterror" ControlToValidate="txtName" Display="Dynamic" ValidationGroup="namespace" meta:resourcekey="rfvNameResource1" />
			<asp:CustomValidator ID="cvName" runat="server" ErrorMessage="Namespace already exists"
				CssClass="resulterror" ControlToValidate="txtName" Display="Dynamic" ValidationGroup="namespace"
				OnServerValidate="cvName_ServerValidate" meta:resourcekey="cvNameResource1" />
			<asp:CustomValidator ID="cvName2" runat="server" ErrorMessage="Invalid Name"
				CssClass="resulterror" ControlToValidate="txtName" Display="Dynamic" ValidationGroup="namespace"
				OnServerValidate="cvName2_ServerValidate" meta:resourcekey="cvName2Resource1" /><br />
			
			<asp:Literal ID="lblDefaultPage" runat="server" Text="Default Page" EnableViewState="False" meta:resourcekey="lblDefaultPageResource2" /><br />
			<asp:DropDownList ID="lstDefaultPage" runat="server" CssClass="dropdown" meta:resourcekey="lstDefaultPageResource1" /><br />
			<asp:Label ID="lblDefaultPageInfo" runat="server" Text="The default page will be created automatically with name 'MainPage'."
				Visible="False" CssClass="injectedmessage" meta:resourcekey="lblDefaultPageInfoResource1" />
			
			<asp:Literal ID="lblTheme" runat="server" Text="Theme" EnableViewState="False" meta:resourcekey="lblThemeResource2" /><br />
			<asp:DropDownList ID="lstTheme" runat="server" CssClass="dropdown" meta:resourcekey="lstThemeResource1" /><br />
			
			<div id="ButtonsDiv">
				<asp:Button ID="btnSave" runat="server" Text="Save Namespace" ToolTip="Save modifications"
					CssClass="button" Visible="False" OnClick="btnSave_Click" ValidationGroup="namespace" meta:resourcekey="btnSaveResource1" />
				<asp:Button ID="btnCreate" runat="server" Text="Create Namespace" ToolTip="Save the new Namespace"
					CssClass="button" OnClick="btnCreate_Click" ValidationGroup="namespace" meta:resourcekey="btnCreateResource1" />
				<anthem:Button ID="btnDelete" runat="server" Text="Delete" ToolTip="Delete the Namespace"
					CssClass="button" Visible="False" OnClick="btnDelete_Click" CausesValidation="False"
					ValidationGroup="namespace" PreCallBackFunction="RequestConfirm" meta:resourcekey="btnDeleteResource1" />
				<asp:Button ID="btnCancel" runat="server" Text="Cancel" ToolTip="Cancel and return to the Namespace list"
					CssClass="button" OnClick="btnCancel_Click" CausesValidation="False" ValidationGroup="namespace" meta:resourcekey="btnCancelResource1" />
					
				<anthem:Label ID="lblResult" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="lblResultResource1" UpdateAfterCallBack="True" />
				
				<br /><br />
				<anthem:Panel ID="pnlDelete" runat="server" Visible="False" 
					AutoUpdateAfterCallBack="True" CssClass="warning" meta:resourcekey="pnlDeleteResource1" UpdateAfterCallBack="True">
					<asp:Literal ID="lblConfirmDeletion" runat="server" EnableViewState="False"
						Text="Are you sure you want to premanently delete the selected Namespace? Doing so, all the data contained in it will be lost." 
						meta:resourcekey="lblConfirmDeletionResource1" /><br /><br />
					<anthem:Button ID="btnConfirmDeletion" runat="server" 
						Text="Confirm Namespace Deletion" PreCallBackFunction="RequestConfirm"
						OnClick="btnConfirmDeletion_Click" meta:resourcekey="btnConfirmDeletionResource1" />
				</anthem:Panel>
			</div>
			
			<h3 class="separator"><asp:Literal ID="lblRename" runat="server" Text="Rename this Namespace" EnableViewState="False" meta:resourcekey="lblRenameResource1" /></h3>
			<asp:Literal ID="lblRenameInfo" runat="server" 
				Text="<b>Warning</b>: renaming a namespace will break all existing inter-namespace links." 
				EnableViewState="False" meta:resourcekey="lblRenameInfoResource1" />
			<br /><br />
			
			<asp:Literal ID="lblNewName" runat="server" Text="New Name" EnableViewState="False" meta:resourcekey="lblNewNameResource1" /><br />
			<anthem:TextBox ID="txtNewName" runat="server" ValidationGroup="rename" meta:resourcekey="txtNewNameResource1" />
			<anthem:Button ID="btnRename" runat="server" Text="Rename" PreCallBackFunction="RequestConfirm" OnClick="btnRename_Click" 
				ValidationGroup="rename" meta:resourcekey="btnRenameResource1" />
			<asp:RequiredFieldValidator ID="rfvNewName" runat="server" Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtNewName" ErrorMessage="New Name is required" ValidationGroup="rename" meta:resourcekey="rfvNewNameResource1" />
			<asp:CustomValidator ID="cvNewName" runat="server" ErrorMessage="Namespace already exists"
				CssClass="resulterror" ControlToValidate="txtName" Display="Dynamic" ValidationGroup="rename"
				OnServerValidate="cvNewName_ServerValidate" meta:resourcekey="cvNewNameResource1" />
			<asp:CustomValidator ID="cvNewName2" runat="server" ErrorMessage="Invalid Name"
				CssClass="resulterror" ControlToValidate="txtName" Display="Dynamic" ValidationGroup="rename"
				OnServerValidate="cvNewName2_ServerValidate" meta:resourcekey="cvNewName2Resource1" /><br />
			
			<anthem:Label ID="lblRenameResult" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="lblRenameResultResource1" UpdateAfterCallBack="True" />
		</div>
	</anthem:Panel>
	
	<anthem:Panel ID="pnlPermissions" runat="server" AutoUpdateAfterCallBack="True" 
		Visible="False" meta:resourcekey="pnlPermissionsResource1" UpdateAfterCallBack="True">
	
		<h2 class="separator">
			<asp:Literal ID="lblNamespacePermissions" runat="server" Text="Namespace Permissions" EnableViewState="False" meta:resourcekey="lblNamespacePermissionsResource1" />
			(<asp:Literal ID="lblNamespaceName" runat="server" meta:resourcekey="lblNamespaceNameResource1" />)
		</h2>
		
		<asp:Literal ID="lblInheritanceInfo" runat="server" 
			Text="<b>Note</b>: sub-namespaces always inherit permissions from the <b>root</b> namespace.<br />Changing the permissions in the <b>root</b> namespace does not change the permissions explicitly set in sub-namespaces." 
			EnableViewState="False" meta:resourcekey="lblInheritanceInfoResource1" />
				
		<div id="PermissionsTemplatesDiv">
			<a href="#" onclick="javascript:document.getElementById('PermissionsTemplatesContainerDiv').style['display'] = ''; return false;">
				<asp:Literal ID="lblPermissionsTemplates" runat="server" Text="Permissions Templates" EnableViewState="False" meta:resourcekey="lblPermissionsTemplatesResource1" />...
			</a>
			<div id="PermissionsTemplatesContainerDiv" style="display: none;">
				<br />
				<ul>
					<li>
						<anthem:LinkButton ID="btnPublic" runat="server" Text="Public" ToolTip="Use this Template" PreCallBackFunction="RequestConfirm" 
							OnClick="btnPublic_Click" meta:resourcekey="btnPublicResource1" /><br />
						<small>
							<asp:Literal ID="lblPublicInfo" runat="server" Text="Anyone, including anonymous users, can <b>edit</b> pages, registered users can also <b>create</b> pages and <b>manage</b> categories." 
								EnableViewState="False" meta:resourcekey="lblPublicInfoResource1" />
						</small>
					</li>
					<li>
						<anthem:LinkButton ID="btnNormal" runat="server" Text="Normal" 
							ToolTip="Use this Template" PreCallBackFunction="RequestConfirm" 
							OnClick="btnNormal_Click" meta:resourcekey="btnNormalResource1" /><br />
						<small>
							<asp:Literal ID="lblNormalInfo" runat="server" 
								Text="Registered Users can <b>edit</b> and <b>create</b> pages and <b>manage</b> categories." 
								EnableViewState="False" meta:resourcekey="lblNormalInfoResource1" />
						</small>
					</li>
					<li>
						<anthem:LinkButton ID="btnPrivate" runat="server" Text="Private" ToolTip="Use this Template" PreCallBackFunction="RequestConfirm" 
							OnClick="btnPrivate_Click" meta:resourcekey="btnPrivateResource1" /><br />
							<small>
								<asp:Literal ID="lblPrivateInfo" runat="server" 
									Text="Only registered users can <b>view</b> pages (and also <b>create</b> and <b>edit</b> them as well as <b>manage</b> categories)." 
									EnableViewState="False" meta:resourcekey="lblPrivateInfoResource1" />
							</small>
					</li>
				</ul>
				<br />
				<small>
					<asp:Literal ID="lblPermissionsTemplatesInfo" runat="server" 
						Text="<b>Warning</b>: setting a template will replace all existing permissions for the default user groups." 
						EnableViewState="False" meta:resourcekey="lblPermissionsTemplatesInfoResource1" />
				</small>
			</div>
		</div>
	
		<st:PermissionsManager ID="permissionsManager" runat="server" CurrentResourceType="Namespaces" />
		
		<div id="ButtonsDiv2">
			<asp:Button ID="btnBack" runat="server" Text="Back" ToolTip="Back to the Namespace list" OnClick="btnBack_Click" meta:resourcekey="btnBackResource1" />
		</div>
	
	</anthem:Panel>
	
	<anthem:HiddenField ID="txtCurrentNamespace" runat="server" AutoUpdateAfterCallBack="True" UpdateAfterCallBack="True" />
	
	<div style="clear: both;"></div>

</asp:Content>
