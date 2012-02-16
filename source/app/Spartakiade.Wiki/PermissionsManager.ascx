<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PermissionsManager.ascx.cs" Inherits="ScrewTurn.Wiki.PermissionsManager" %>

<%@ Register TagPrefix="st" TagName="AclActionsSelector" Src="~/AclActionsSelector.ascx" %>

<div id="PermissionsManagerDiv">
	
	<div id="SubjectsDiv">
	
		<asp:Literal ID="lblSubjects" runat="server" Text="User Accounts and User Groups" EnableViewState="False" meta:resourcekey="lblSubjectsResource1" /><br />
		<anthem:ListBox ID="lstSubjects" runat="server" AutoCallBack="True" AutoUpdateAfterCallBack="True"
			OnSelectedIndexChanged="lstSubjects_SelectedIndexChanged" CssClass="listbox" meta:resourcekey="lstSubjectsResource1" UpdateAfterCallBack="True" />
		
	</div>
	
	<div id="SubjectsManagementDiv">
		<anthem:Button ID="btnRemove" runat="server" Text="Remove" ToolTip="Remove entries for the selected subject"
			Enabled="False" OnClick="btnRemove_Click" PreCallBackFunction="RequestConfirm" meta:resourcekey="btnRemoveResource1" />
		<br /><br />
		
		<anthem:TextBox ID="txtNewSubject" runat="server" CssClass="textbox" meta:resourcekey="txtNewSubjectResource1" />
		<anthem:Button ID="btnSearch" runat="server" Text="Search" ToolTip="Search for a User or Group to add" OnClick="btnSearch_Click" meta:resourcekey="btnSearchResource1" /><br />
		<anthem:DropDownList ID="lstFoundSubjects" runat="server" CssClass="dropdown" meta:resourcekey="lstFoundSubjectsResource1" />
		<anthem:Button ID="btnAdd" runat="server" Text="Add" ToolTip="Add the selected subject" Enabled="False" OnClick="btnAdd_Click" meta:resourcekey="btnAddResource1" /><br />
		<anthem:Label ID="lblAddResult" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="lblAddResultResource1" UpdateAfterCallBack="True" />
	</div>
	
	<div class="cleanupleft"></div>
	
	<div id="AclSelectorDiv">
	
		<h3><asp:Literal ID="lblPermissionsFor" runat="server" Text="Permissions for:" EnableViewState="False" meta:resourcekey="lblPermissionsForResource1" />
		<asp:Literal ID="lblSelectedSubject" runat="server" meta:resourcekey="lblSelectedSubjectResource1" /></h3>
		
		<st:AclActionsSelector ID="aclActionsSelector" runat="server" />
	
	</div>

	<div id="InternalButtonsDiv">
		<anthem:Button ID="btnSave" runat="server" Text="Save Permissions" ToolTip="Save this Subject's permissions" Enabled="False" OnClick="btnSave_Click" meta:resourcekey="btnSaveResource1" />
		<anthem:Label ID="lblSaveResult" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="lblSaveResultResource1" UpdateAfterCallBack="True" />
	</div>

</div>
