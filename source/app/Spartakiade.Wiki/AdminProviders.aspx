<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeBehind="AdminProviders.aspx.cs" Inherits="ScrewTurn.Wiki.AdminProviders" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" %>

<%@ Register TagPrefix="st" TagName="ProviderSelector" Src="~/ProviderSelector.ascx" %>

<asp:Content ID="ctnHead" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="ctnProviders" ContentPlaceHolderID="cphAdmin" runat="server">
	<script type="text/javascript">
	<!--
		function __ShowUploadProgress() {
			document.getElementById("UploadProgressSpan").style["display"] = "";
			return true;
		}
		function __HideUploadProgress() {
			document.getElementById("UploadProgressSpan").style["display"] = "none";
			return true;
		}
	// -->
	</script>

	<h2 class="sectiontitle"><asp:Literal ID="lblProviders" runat="server" Text="Providers" EnableViewState="False" meta:resourcekey="lblProvidersResource1" /></h2>

	<anthem:Panel ID="pnlList" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="pnlListResource1" UpdateAfterCallBack="True">
		<asp:Literal ID="lblDisplay" runat="server" Text="Display" EnableViewState="False" meta:resourcekey="lblDisplayResource1" />:
		<anthem:RadioButton ID="rdoPages" runat="server" Text="Pages Providers" GroupName="type" Checked="True" AutoCallBack="True" OnCheckedChanged="rdo_CheckedChanged" meta:resourcekey="rdoPagesResource1" />
		<anthem:RadioButton ID="rdoUsers" runat="server" Text="Users Providers" GroupName="type" AutoCallBack="True" OnCheckedChanged="rdo_CheckedChanged" meta:resourcekey="rdoUsersResource1" />
		<anthem:RadioButton ID="rdoFiles" runat="server" Text="Files Providers" GroupName="type" AutoCallBack="True" OnCheckedChanged="rdo_CheckedChanged" meta:resourcekey="rdoFilesResource1" />
		<anthem:RadioButton ID="rdoCache" runat="server" Text="Cache Providers" GroupName="type" AutoCallBack="True" OnCheckedChanged="rdo_CheckedChanged" meta:resourcekey="rdoCacheResource1" />
		<anthem:RadioButton ID="rdoFormatter" runat="server" Text="Formatter Providers" GroupName="type" AutoCallBack="True" OnCheckedChanged="rdo_CheckedChanged" meta:resourcekey="rdoFormatterResource1" />
		<br />
		
		<div id="ProvidersListContainerDiv">
			<anthem:Repeater ID="rptProviders" runat="server"
				OnDataBinding="rptProviders_DataBinding" OnItemCommand="rptProviders_ItemCommand">
				<HeaderTemplate>
					<table cellpadding="0" cellspacing="0" class="generic">
						<thead>
						<tr class="tableheader">
							<th><asp:Literal ID="lblName" runat="server" EnableViewState="False" meta:resourcekey="lblNameResource1" Text="Name" /></th>
							<th><asp:Literal ID="lblVersion" runat="server" EnableViewState="False" meta:resourcekey="lblVersionResource1" Text="Ver." /></th>
							<th><asp:Literal ID="lblAuthor" runat="server" EnableViewState="False" meta:resourcekey="lblAuthorResource1" Text="Author" /></th>
							<th><asp:Literal ID="lblUpdateStatus" runat="server" EnableViewState="false" meta:resourcekey="lblUpdateStatusResource1" Text="Update Status" /></th>
							<th>&nbsp;</th>
						</tr>
						</thead>
						<tbody>
				</HeaderTemplate>
				<ItemTemplate>
					<tr class='tablerow<%# Eval("AdditionalClass") %>'>
						<td><%# Eval("Name") %></td>
						<td><%# Eval("Version") %></td>
						<td><a href='<%# Eval("AuthorUrl") %>' target="_blank"><%# Eval("Author") %></a></td>
						<td><%# Eval("UpdateStatus") %></td>
						<td><anthem:LinkButton ID="btnSelect" runat="server" CommandArgument='<%# Eval("TypeName") %>' CommandName="Select" meta:resourcekey="btnSelectResource2" Text="Select" /></td>
					</tr>
				</ItemTemplate>
				<AlternatingItemTemplate>
					<tr class='tablerowalternate<%# Eval("AdditionalClass") %>'>
						<td><%# Eval("Name") %></td>
						<td><%# Eval("Version") %></td>
						<td><a href='<%# Eval("AuthorUrl") %>' target="_blank"><%# Eval("Author") %></a></td>
						<td><%# Eval("UpdateStatus") %></td>
						<td><anthem:LinkButton ID="btnSelect" runat="server" Text="Select" CommandName="Select" CommandArgument='<%# Eval("TypeName") %>' meta:resourcekey="btnSelectResource1" /></td>
					</tr>
				</AlternatingItemTemplate>
				<FooterTemplate>
					</tbody>
					</table>
				</FooterTemplate>
			</anthem:Repeater>
		</div>
		
		<anthem:Panel ID="pnlProviderDetails" runat="server" AutoUpdateAfterCallBack="True" Visible="False" meta:resourcekey="pnlProviderDetailsResource1">
			<div id="EditProviderDiv">
				<h3><asp:Literal ID="lblProviderName" runat="server" meta:resourcekey="lblProviderNameResource1" /></h3>
				<b><asp:Literal ID="lblProviderDll" runat="server" meta:resourcekey="lblProviderDllResource1" /></b>
				<br /><br />
				
				<asp:Literal ID="lblConfigurationStringTitle" runat="server" Text="Configuration String" EnableViewState="False" meta:resourcekey="lblConfigurationStringTitleResource1" />
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="#" onclick="javascript:document.getElementById('ProviderConfigHelpDiv').style['display'] = ''; return false;">
				<asp:Literal ID="lblConfigHelp" runat="server" Text="Help" EnableViewState="False" meta:resourcekey="lblConfigHelpResource1" /></a>
				<br />
				<anthem:TextBox ID="txtConfigurationString" runat="server" TextMode="MultiLine" CssClass="config" meta:resourcekey="txtConfigurationStringResource1" />
				<br />
				<anthem:Button ID="btnSave" runat="server" Text="Save" ToolTip="Save the Configuration String" OnClick="btnSave_Click" meta:resourcekey="btnSaveResource1" />
				<anthem:Button ID="btnDisable" runat="server" Text="Disable" ToolTip="Disable the Provider" OnClick="btnDisable_Click" PreCallBackFunction="RequestConfirm" meta:resourcekey="btnDisableResource1" />
				<anthem:Button ID="btnEnable" runat="server" Text="Enable" ToolTip="Enable the Provider" Visible="False" OnClick="btnEnable_Click" PreCallBackFunction="RequestConfirm" meta:resourcekey="btnEnableResource1" />
				<anthem:Button ID="btnUnload" runat="server" Text="Unload" ToolTip="Unloads the Provider" OnClick="btnUnload_Click" PreCallBackFunction="RequestConfirm" meta:resourcekey="btnUnloadResource1" />
				<anthem:Button ID="btnCancel" runat="server" Text="Cancel" ToolTip="Deselect the Provider" OnClick="btnCancel_Click" meta:resourcekey="btnCancelResource1" />
				<br /><br />
				<anthem:Label ID="lblCannotDisable" runat="server" CssClass="small" Text="Cannot disable the provider because it is the default provider or,<br />in case of a Pages Provider, it manages the default page of the root namespace"
					meta:resourcekey="lblCannotDisableResource1"/><br />
				<anthem:Label ID="lblResult" runat="server" meta:resourcekey="lblResultResource1" />
				
				<div id="ProviderConfigHelpDiv" style="display: none;">
					<anthem:Label ID="lblProviderConfigHelp" runat="server" meta:resourcekey="lblProviderConfigHelpResource1" />
				</div>
			</div>
		</anthem:Panel>
		
		<div id="ProvidersUpdateDiv">
		
			<script type="text/javascript">
			<!--
				function __ShowUpdateProgress() {
					if (RequestConfirm()) {
						document.getElementById("ProvidersUpdateProgress").style["display"] = "";
						return true;
					}
					else return false;
				}

				function __HideUpdateProgress() {
					document.getElementById("ProvidersUpdateProgress").style["display"] = "none";
				}
			// -->
			</script>
			
			<anthem:Button ID="btnAutoUpdateProviders" runat="server" Text="Auto-update Providers" ToolTip="Automatically update all installed providers, of all types"
				PreCallBackFunction="__ShowUpdateProgress" PostCallBackFunction="__HideUpdateProgress" OnClick="btnAutoUpdateProviders_Click" meta:resourcekey="btnAutoUpdateProvidersResource1" />
			<span id="ProvidersUpdateProgress" style="display: none;">
				<img src="Images/Wait.gif" alt="..." />
			</span>
			<anthem:Label ID="lblAutoUpdateResult" runat="server" AutoUpdateAfterCallBack="true" />
			
		</div>
		
	</anthem:Panel>
	
	<anthem:HiddenField ID="txtCurrentProvider" runat="server" AutoUpdateAfterCallBack="True" />
	
	<div style="clear: both;"></div>
	
	<br />
	<h2 class="separator"><asp:Literal ID="lblDefaultProvidersTitle" runat="server" Text="Default Providers" EnableViewState="False" meta:resourcekey="lblDefaultProvidersTitleResource1" /></h2>
				
	<div class="defaultprov">
		<asp:Literal ID="lblDefaultProvPages" runat="server" Text="Pages Provider" EnableViewState="False" meta:resourcekey="lblDefaultProvPagesResource1" /><br />
		<st:ProviderSelector ID="lstPagesProvider" runat="server" ProviderType="Pages" ExcludeReadOnly="true" />
	</div>
	<div class="defaultprov">
		<asp:Literal ID="lblDefaultProvUsers" runat="server" Text="Users Provider" EnableViewState="False" meta:resourcekey="lblDefaultProvUsersResource1" /><br />
		<st:ProviderSelector ID="lstUsersProvider" runat="server" ProviderType="Users" ExcludeReadOnly="true" />
	</div>
	<div class="defaultprov">
		<asp:Literal ID="lblDefaultProvFiles" runat="server" Text="Files Provider" EnableViewState="False" meta:resourcekey="lblDefaultProvFilesResource1" /><br />
		<st:ProviderSelector ID="lstFilesProvider" runat="server" ProviderType="Files" ExcludeReadOnly="true" />
	</div>
	<div class="defaultprov">
		<asp:Literal ID="lblDefaultProvCache" runat="server" Text="Cache Provider" EnableViewState="False" meta:resourcekey="lblDefaultProvCacheResource1" /><br />
		<st:ProviderSelector ID="lstCacheProvider" runat="server" ProviderType="Cache" ExcludeReadOnly="true" />
	</div>
	<div class="defaultprovbutton">
		<anthem:Button ID="btnSaveDefaultProviders" runat="server" Text="Save" OnClick="btnSaveDefaultProviders_Click" meta:resourcekey="btnSaveDefaultProvidersResource1" />
		<anthem:Label ID="lblDefaultProvidersResult" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="lblDefaultProvidersResultResource1" />
	</div>
	
	<div style="clear: both;"></div>
	
	<br />
	<h2 class="separator"><asp:Literal ID="lblUploadProvidersTitle" runat="server" Text="Providers DLLs Management" EnableViewState="False" meta:resourcekey="lblUploadProvidersTitleResource1" /></h2>
	
	<h4><asp:Literal ID="lblUploadNewDll" runat="server" Text="Upload new DLL" EnableViewState="False" meta:resourcekey="lblUploadNewDllResource1" /></h4>
	<anthem:FileUpload ID="upDll" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="upDllResource1" />
	<anthem:Button ID="btnUpload" runat="server" Text="Upload" OnClick="btnUpload_Click" EnabledDuringCallBack="False"
		PreCallBackFunction="__ShowUploadProgress" PostCallBackFunction="__HideUploadProgress" meta:resourcekey="btnUploadResource1" />
	<span id="UploadProgressSpan" style="display: none;"><img src="Images/Wait.gif" alt="Uploading..." /></span><br />
	<anthem:Label ID="lblUploadResult" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="lblUploadResultResource1" />
	
	<div id="DllsListContainerDiv">
		<anthem:DropDownList ID="lstDlls" runat="server" AutoCallBack="True" AutoUpdateAfterCallBack="True" OnSelectedIndexChanged="lstDlls_SelectedIndexChanged" meta:resourcekey="lstDllsResource1" />
		<anthem:Button ID="btnDeleteDll" runat="server" Text="Delete" PreCallBackFunction="RequestConfirm" AutoUpdateAfterCallBack="True" OnClick="btnDeleteDll_Click" Enabled="False" meta:resourcekey="btnDeleteDllResource1" />
		<br />
		<anthem:Label ID="lblDllResult" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="lblDllResultResource1" />
	</div>
	
	<div id="DllNoticeDiv">
		<small>
			<asp:Literal ID="lblUploadInfo" runat="server" EnableViewState="False"
				Text="<b>Note</b>: removing a DLL won't disable the Providers it contains until the next wiki restart,<br />but uploading a new DLL will automatically load the Providers it contains." 
				meta:resourcekey="lblUploadInfoResource1" />
		</small>
	</div>
	
	<div style="clear: both;"></div>
	
	<br />
	<h2 class="separator"><asp:Literal ID="lblDataMigration" runat="server" Text="Data Migration" EnableViewState="False" meta:resourcekey="lblDataMigrationResource1" /></h2>
	<asp:Literal ID="lblMigrationInfo" runat="server" EnableViewState="False"		
		Text="<b>Note 1</b>: always perform a full backup of all your data before performing a migration.<br /><b>Note 2</b>: migrations usually take several minutes to complete: during this time, do not perform any other activity in the wiki, and do not close this page.<br /><b>Note 3</b>: the destination provider should be completely empty: if it contains any data, it might cause consistency issues. Refer to the target provider's documentation for details.<br /><b>Timeouts</b>: it is strongly suggested that you increase the executionTimeout parameter in web.config before migrating data." 
		meta:resourcekey="lblMigrationInfoResource2" />
	<br /><br />
	
	<h4><asp:Literal ID="lblMigratePages" runat="server" Text="Migrate Pages and related data" EnableViewState="False" meta:resourcekey="lblMigratePagesResource1" /></h4>
	<anthem:DropDownList ID="lstPagesSource" runat="server" AutoCallBack="True" AutoUpdateAfterCallBack="True"
		OnSelectedIndexChanged="lstPagesSource_SelectedIndexChanged" meta:resourcekey="lstPagesSourceResource1" />
	<img src="Images/ArrowRight.png" alt="->" />
	<anthem:DropDownList ID="lstPagesDestination" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="lstPagesDestinationResource1"  />
	<anthem:Button ID="btnMigratePages" runat="server" Text="Migrate" Enabled="False" EnabledDuringCallBack="False" AutoUpdateAfterCallBack="True"
		PreCallBackFunction="RequestConfirm" OnClick="btnMigratePages_Click" meta:resourcekey="btnMigratePagesResource1" />
	<anthem:Label ID="lblMigratePagesResult" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="lblMigratePagesResultResource1" />
	<br />
	<br />
	
	<h4><asp:Literal ID="lblMigrateUsers" runat="server" Text="Migrate Users and related data" EnableViewState="False" meta:resourcekey="lblMigrateUsersResource1" /></h4>
	<anthem:DropDownList ID="lstUsersSource" runat="server" AutoCallBack="True" AutoUpdateAfterCallBack="True"
		OnSelectedIndexChanged="lstUsersSource_SelectedIndexChanged" meta:resourcekey="lstUsersSourceResource1" />
	<img src="Images/ArrowRight.png" alt="->" />
	<anthem:DropDownList ID="lstUsersDestination" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="lstUsersDestinationResource1" />
	<anthem:Button ID="btnMigrateUsers" runat="server" Text="Migrate" Enabled="False" EnabledDuringCallBack="False"
		AutoUpdateAfterCallBack="True" PreCallBackFunction="RequestConfirm" OnClick="btnMigrateUsers_Click" meta:resourcekey="btnMigrateUsersResource1" />
	<anthem:Label ID="lblMigrateUsersResult" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="lblMigrateUsersResultResource1" />
	<br />
	<span class="small">
		<asp:Literal ID="lblMigrateUsersInfo" runat="server" 
			Text="<b>Note</b>: migrating user accounts will reset all their passwords (an email notice will be sent to all users)." 
			EnableViewState="False" meta:resourcekey="lblMigrateUsersInfoResource1" />
	</span>	
	<br /><br />
	
	<h4><asp:Literal ID="lblMigrateFiles" runat="server" Text="Migrate Files and related data" EnableViewState="False" meta:resourcekey="lblMigrateFilesResource1" /></h4>
	<anthem:DropDownList ID="lstFilesSource" runat="server" AutoCallBack="True" AutoUpdateAfterCallBack="True"
		OnSelectedIndexChanged="lstFilesSource_SelectedIndexChanged" meta:resourcekey="lstFilesSourceResource1" />
	<img src="Images/ArrowRight.png" alt="->" />
	<anthem:DropDownList ID="lstFilesDestination" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="lstFilesDestinationResource1"  />
	<anthem:Button ID="btnMigrateFiles" runat="server" Text="Migrate" Enabled="False" EnabledDuringCallBack="False"
		AutoUpdateAfterCallBack="True" PreCallBackFunction="RequestConfirm" OnClick="btnMigrateFiles_Click" meta:resourcekey="btnMigrateFilesResource1" />
	<anthem:Label ID="lblMigrateFilesResult" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="lblMigrateFilesResultResource1" />
	<br /><br />
	
	<h4><asp:Literal ID="lblCopySettings" runat="server" Text="Copy Settings and related data" EnableViewState="False" meta:resourcekey="lblCopySettingsResource1" /></h4>
	<anthem:Label ID="lblSettingsSource" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="lblSettingsSourceResource1"  />
	<img src="Images/ArrowRight.png" alt="->" />
	<anthem:DropDownList ID="lstSettingsDestination" runat="server" AutoUpdateAfterCallBack="True" AutoCallBack="True"
		OnSelectedIndexChanged="lstSettingsDestination_SelectedIndexChanged" meta:resourcekey="lstSettingsDestinationResource1" />
	<anthem:Button ID="btnCopySettings" runat="server" Text="Copy" Enabled="False" EnabledDuringCallBack="False"
		AutoUpdateAfterCallBack="True" PreCallBackFunction="RequestConfirm" OnClick="btnCopySettings_Click" meta:resourcekey="btnCopySettingsResource1" />
	<anthem:Label ID="lblCopySettingsResult" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="lblCopySettingsResultResource1" /><br />
	<span class="small">
		<asp:Literal ID="lblCopySettingsInfo" runat="server" EnableViewState="False"
			Text="<b>Note</b>: in order to be detected, the destination Provider must be uploaded using the upload tool.<br />Log and recent changes will not be copied." 
			meta:resourcekey="lblCopySettingsInfoResource1" />
	</span>
	<br /><br />
	<div id="CopySettingsConfigDiv">
		<asp:Literal ID="lblCopySettingsDestinationConfig" runat="server" Text="Destination Settings Provider Configuration string (if needed)" EnableViewState="false" /><br />
		<anthem:TextBox ID="txtSettingsDestinationConfig" runat="server" TextMode="MultiLine" CssClass="config" />
	</div>
	
	<div style="clear: both;"></div>
	
</asp:Content>
