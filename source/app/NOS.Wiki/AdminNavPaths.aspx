<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeBehind="AdminNavPaths.aspx.cs" Inherits="ScrewTurn.Wiki.AdminNavPaths" culture="auto" meta:resourcekey="PageResource2" uiculture="auto" %>

<asp:Content ID="ctnHead" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="ctnNavPaths" ContentPlaceHolderID="cphAdmin" runat="server">
	<h2 class="sectiontitle"><asp:Literal ID="lblNavPaths" runat="server" Text="Navigation Paths" EnableViewState="False" meta:resourcekey="lblNavPathsResource1" /></h2>
	
	<anthem:Panel ID="pnlList" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="pnlListResource1" UpdateAfterCallBack="True">
		<anthem:Button ID="btnNewNavPath" runat="server" Text="New Nav. Path" ToolTip="Create a new Navigation Path" CssClass="rightaligned" OnClick="btnNewNavPath_Click" 
			AutoUpdateAfterCallBack="True" meta:resourcekey="btnNewNavPathResource1" />
		
		<div id="NamespaceSelectorDiv">
			<asp:Literal ID="lblNamespace" runat="server" Text="Namespace" EnableViewState="False" meta:resourcekey="lblNamespaceResource1" /><br />
			<anthem:DropDownList ID="lstNamespace" runat="server" AutoCallBack="True" Width="150px" OnSelectedIndexChanged="lstNamespace_SelectedIndexChanged" meta:resourcekey="lstNamespaceResource1" />
		</div>
		<div id="NavPathsListContainerDiv">
			<anthem:Repeater ID="rptNavPaths" runat="server"
				OnDataBinding="rptNavPaths_DataBinding" OnItemCommand="rptNavPaths_ItemCommand">
				<HeaderTemplate>
					<table cellpadding="0" cellspacing="0" class="generic">
						<thead>
						<tr class="tableheader">
							<th><asp:Literal ID="lblName" runat="server" EnableViewState="False" meta:resourcekey="lblNameResource1" Text="Name" /></th>
							<th><asp:Literal ID="lblPages" runat="server" EnableViewState="False" meta:resourcekey="lblPagesResource1" Text="Pages" /></th>
							<th><asp:Literal ID="lblProvider" runat="server" EnableViewState="False" meta:resourcekey="lblProviderResource1" Text="Provider" /></th>
							<th>&nbsp;</th>
						</tr>
						</thead>
						<tbody>
				</HeaderTemplate>
				<ItemTemplate>
					<tr class='tablerow<%# Eval("AdditionalClass") %>'>
						<td><%# ScrewTurn.Wiki.PluginFramework.NameTools.GetLocalName((string)Eval("FullName")) %></td>
						<td><%# Eval("Pages") %></td>
						<td><%# Eval("Provider") %></td>
						<td><anthem:LinkButton ID="btnSelect" runat="server" CommandArgument='<%# Eval("FullName") %>' CommandName="Select" meta:resourcekey="btnSelectResource2" Text="Select" Visible='<%# (bool)Eval("CanSelect") %>' /></td>
					</tr>
				</ItemTemplate>
				<AlternatingItemTemplate>
					<tr class='tablerowalternate<%# Eval("AdditionalClass") %>'>
						<td><%# ScrewTurn.Wiki.PluginFramework.NameTools.GetLocalName((string)Eval("FullName")) %></td>
						<td><%# Eval("Pages") %></td>
						<td><%# Eval("Provider") %></td>
						<td><anthem:LinkButton ID="btnSelect" runat="server" Visible='<%# (bool)Eval("CanSelect") %>' Text="Select" CommandName="Select" CommandArgument='<%# Eval("FullName") %>' meta:resourcekey="btnSelectResource1" /></td>
					</tr>
				</AlternatingItemTemplate>
				<FooterTemplate>
					</tbody>
					</table>
				</FooterTemplate>
			</anthem:Repeater>
		</div>
	</anthem:Panel>
	
	<anthem:Panel ID="pnlEditNavPath" runat="server" AutoUpdateAfterCallBack="True" 
		Visible="False" meta:resourcekey="pnlEditNavPathResource1">
		<div id="EditNavPathDiv">
			<h2 class="separator"><asp:Literal ID="lblEditTitle" runat="server" Text="Navigation Paths Details" EnableViewState="False" meta:resourcekey="lblEditTitleResource1" /></h2>
			
			<asp:Literal ID="lblName" runat="server" Text="Name" EnableViewState="False" meta:resourcekey="lblNameResource2" /><br />
			<anthem:TextBox ID="txtName" runat="server" CssClass="textbox" ValidationGroup="navpath" meta:resourcekey="txtNameResource1" />
			<anthem:RequiredFieldValidator ID="rfvName" runat="server" 
				ErrorMessage="Name is required" AutoUpdateAfterCallBack="True"
				CssClass="resulterror" ControlToValidate="txtName" Display="Dynamic" 
				ValidationGroup="navpath" meta:resourcekey="rfvNameResource1" />
			<anthem:CustomValidator ID="cvName1" runat="server" ErrorMessage="Invalid Name" 
				OnServerValidate="cvName1_ServerValidate" AutoUpdateAfterCallBack="True"
				CssClass="resulterror" ControlToValidate="txtName" Display="Dynamic" 
				ValidationGroup="navpath" meta:resourcekey="cvName1Resource1" />
			<anthem:CustomValidator ID="cvName2" runat="server" 
				ErrorMessage="Navigation Path already exists" 
				OnServerValidate="cvName2_ServerValidate" AutoUpdateAfterCallBack="True"
				CssClass="resulterror" ControlToValidate="txtName" Display="Dynamic" 
				ValidationGroup="navpath" meta:resourcekey="cvName2Resource1" /><br /><br />
				
			<anthem:TextBox ID="txtPageName" runat="server" CssClass="textbox" AutoUpdateAfterCallBack="True" meta:resourcekey="txtPageNameResource1" />
			<anthem:Button ID="btnSearch" runat="server" Text="Search" ToolTip="Search for a Page" OnClick="btnSearch_Click" meta:resourcekey="btnSearchResource1" /><br />
			<anthem:DropDownList ID="lstAvailablePage" runat="server" CssClass="dropdown" meta:resourcekey="lstAvailablePageResource1" />
			<anthem:Button ID="btnAdd" runat="server" Text="Add" ToolTip="Add the selected Page to the list"
				Enabled="False" AutoUpdateAfterCallBack="True" OnClick="btnAdd_Click" meta:resourcekey="btnAddResource1" /><br />
			
			<div id="NavPathPagesListDiv">
				<anthem:ListBox ID="lstPages" runat="server" CssClass="listbox" AutoCallBack="True" AutoUpdateAfterCallBack="true"
					OnSelectedIndexChanged="lstPages_SelectedIndexChanged" meta:resourcekey="lstPagesResource1" />
			</div>
			<anthem:Button ID="btnUp" runat="server" Text="Up" Enabled="False" 
				AutoUpdateAfterCallBack="True" OnClick="btnUp_Click" meta:resourcekey="btnUpResource1" /><br />
			<anthem:Button ID="btnDown" runat="server" Text="Down" Enabled="False" 
				AutoUpdateAfterCallBack="True" OnClick="btnDown_Click" meta:resourcekey="btnDownResource1" /><br />
			<anthem:Button ID="btnRemove" runat="server" Text="Remove" Enabled="False" 
				AutoUpdateAfterCallBack="True" OnClick="btnRemove_Click" meta:resourcekey="btnRemoveResource1" />
				
			<div id="ButtonsDiv">
				<asp:Button ID="btnSave" runat="server" Text="Save Nav. Path" ToolTip="Save modifications"
					CssClass="button" Visible="False" ValidationGroup="navpath" OnClick="btnSave_Click" meta:resourcekey="btnSaveResource1" />
				<asp:Button ID="btnCreate" runat="server" Text="Create Nav. Path" ToolTip="Save the new Navigation Path"
					CssClass="button" ValidationGroup="navpath" OnClick="btnCreate_Click" meta:resourcekey="btnCreateResource1" />
				<anthem:Button ID="btnDelete" runat="server" Text="Delete" ToolTip="Delete the Navigation Path"
					CssClass="button" Visible="False" CausesValidation="False" OnClick="btnDelete_Click"
					ValidationGroup="account" PreCallBackFunction="RequestConfirm" meta:resourcekey="btnDeleteResource1" />
				<asp:Button ID="btnCancel" runat="server" Text="Cancel" ToolTip="Cancel and return to the Navigation Path list"
					CssClass="button" CausesValidation="False" ValidationGroup="account" OnClick="btnCancel_Click" meta:resourcekey="btnCancelResource1" />
					
				<anthem:Label ID="lblResult" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="lblResultResource1" />
			</div>
		</div>
	</anthem:Panel>
	
	<anthem:HiddenField ID="txtCurrentNavPath" runat="server" AutoUpdateAfterCallBack="True" />
	
	<div style="clear: both;"></div>
	
</asp:Content>
