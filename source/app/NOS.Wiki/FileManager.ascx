<%@ Control Language="C#" AutoEventWireup="true" Inherits="ScrewTurn.Wiki.FileManager" Codebehind="FileManager.ascx.cs" %>

<%@ Register TagPrefix="st" TagName="PermissionsManager" Src="~/PermissionsManager.ascx" %>

<asp:Literal ID="lblStrings" runat="server" meta:resourcekey="lblStringsResource1" />

<script type="text/javascript">
<!--
    function ConfirmDeletion() {
        return confirm(ConfirmMessage);
    }
    function ShowUploadProgress() {
    	document.getElementById("UploadProgressSpan").style["display"] = "";
    	document.getElementById("UploadButtonSpan").style["display"] = "none";
    	return true;
    }

    function OpenPopupImageEditor(file) {
       	var settings = "center=yes,resizable=yes,dialog,status=no,scrollbars=no,width=560,height=400";
       	window.open(CurrentNamespace + (CurrentNamespace != "" ? "." : "") + "ImageEditor.aspx?File=" + file, "Popup", settings);
       	return false;
    }
// -->
</script>

<div id="MainFileManagerDiv">

	<div id="DirectoriesDiv">
		<anthem:DropDownList ID="lstProviders" runat="server" AutoPostBack="True" OnSelectedIndexChanged="lstProviders_SelectedIndexChanged" meta:resourcekey="lstProvidersResource1" />
		<anthem:LinkButton ID="lnkRoot" runat="server" Text="[..]" ToolTip="/" OnClick="lnkRoot_Click" meta:resourcekey="lnkRootResource1" />
		<anthem:Label ID="lblRoot" runat="server" Text="/" meta:resourcekey="lblRootResource1" />
		<anthem:PlaceHolder ID="plhDirectory" runat="server" AutoUpdateAfterCallBack="True" />
	</div>

	<anthem:Panel ID="pnlRename" runat="server" Visible="False" AutoUpdateAfterCallBack="True" meta:resourcekey="pnlRenameResource1">
		<div id="ItemRenameDiv">
			<h3 class="separator"><asp:Literal ID="lblRename" runat="server" Text="Rename file/directory" meta:resourcekey="lblRenameResource1" /></h3>
			<anthem:Label ID="lblItem" runat="server" meta:resourcekey="lblItemResource1" /><br />
			<anthem:TextBox ID="txtNewName" runat="server" Width="200px" meta:resourcekey="txtNewNameResource1" /><br />
			<anthem:Button ID="btnRename" runat="server" Text="Rename" OnClick="btnRename_Click" meta:resourcekey="btnRenameResource1" />
			<anthem:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" meta:resourcekey="btnCancelResource1" />
			<anthem:Label ID="lblRenameResult" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="lblRenameResultResource1" />
		</div>
	</anthem:Panel>

	<anthem:Repeater ID="rptItems" runat="server" AutoUpdateAfterCallBack="True"
		OnDataBinding="rptItems_DataBinding" OnItemCommand="rptItems_ItemCommand">
		<HeaderTemplate>
			<table id="FileManagerTable" class="generic" cellpadding="0" cellspacing="0">
				<thead>
				<tr class="tableheader">
					<th>&nbsp;</th>
					<th><asp:Literal ID="lblName" runat="server" Text="Name" EnableViewState="False" meta:resourcekey="lblNameResource1" /></th>
					<th><asp:Literal ID="lblSize" runat="server" Text="Size" EnableViewState="False" meta:resourcekey="lblSizeResource1" /></th>
					<th><asp:Literal ID="lblDownloads" runat="server" Text="Downloads" EnableViewState="False" meta:resourcekey="lblDownloadsResource1" /></th>
					<th><asp:Literal ID="lblLink" runat="server" Text="Link" EnableViewState="False" meta:resourcekey="lblLinkResource1" /></th>
					<th>&nbsp;</th>
				</tr>
				</thead>
				<tbody>
		</HeaderTemplate>
		<ItemTemplate>
			<tr class="tablerow">
				<td><img src="Images/<%# (string)((string)Eval("Type") == "D" ? "Dir.png" : "File.png") %>" alt="-" /></td>
				<td><a style='<%# (Eval("WikiMarkupLink") == "&nbsp;" ? "display: none;" : "") %><%# ((bool)Eval("CanDownload") ? "" : "text-decoration: line-through;") %>'
						href='<%# ((bool)Eval("CanDownload") ? (string)Eval("Link") : "#") %>' title="<%# ScrewTurn.Wiki.Properties.Messages.Download %>"><%# Eval("Name") %></a>
					<anthem:LinkButton ID="lnkDir" Visible='<%# Eval("Type") == "D" %>' 
						runat="server" Text='<%# Eval("Name") %>' style='<%# ((bool)Eval("CanDownload") ? "" : "text-decoration: line-through;") %>'
						CommandName="Dir" CommandArgument='<%# Eval("Name") %>' meta:resourcekey="lnkDirResource1" /></td>
				<td><%# Eval("Size") %></td>
				<td><%# Eval("Downloads") %></td>
				<td><%# Eval("WikiMarkupLink") %></td>
				<td>
					<anthem:LinkButton ID="btnRename" runat="server" Visible='<%# (bool)Eval("CanDelete") %>' Text="Rename" CommandName="Rename" ToolTip="Rename this Item" CommandArgument='<%# Eval("FullPath") %>' meta:resourcekey="btnRenameResource2" />
					&bull;
					<anthem:LinkButton ID="btnDelete" runat="server" Visible='<%# (bool)Eval("CanDelete") %>' Text="Delete" CommandName="Delete" ToolTip="Delete this Item" CommandArgument='<%# Eval("FullPath") %>' OnClientClick="javascript:if(!ConfirmDeletion()) return false;" meta:resourcekey="btnDeleteResource1" />
					<%# ((bool)Eval("Editable") ? "&bull; <a href=\"#\" onclick=\"javascript:return OpenPopupImageEditor('" + Eval("FullPath") + "');\">" + ScrewTurn.Wiki.Properties.Messages.Edit + "</a>" : "")%>
				</td>
			</tr>
		</ItemTemplate>
		<AlternatingItemTemplate>
			<tr class="tablerowalternate">
				<td><img src="Images/<%# (string)((string)Eval("Type") == "D" ? "Dir.png" : "File.png") %>" alt="-" /></td>
				<td><a style='<%# (Eval("WikiMarkupLink") == "&nbsp;" ? "display: none;" : "") %><%# ((bool)Eval("CanDownload") ? "" : "text-decoration: line-through;") %>'
						href='<%# ((bool)Eval("CanDownload") ? (string)Eval("Link") : "#") %>' title="<%# ScrewTurn.Wiki.Properties.Messages.Download %>"><%# Eval("Name") %></a>
					<anthem:LinkButton ID="lnkDir" Visible='<%# Eval("Type") == "D" %>' 
						runat="server" Text='<%# Eval("Name") %>' style='<%# ((bool)Eval("CanDownload") ? "" : "text-decoration: line-through;") %>'
						CommandName="Dir" CommandArgument='<%# Eval("Name") %>' meta:resourcekey="lnkDirResource2" /></td>
				<td><%# Eval("Size") %></td>
				<td><%# Eval("Downloads") %></td>
				<td><%# Eval("WikiMarkupLink") %></td>
				<td>
					<anthem:LinkButton ID="btnRename" runat="server" Visible='<%# (bool)Eval("CanDelete") %>' Text="Rename" CommandName="Rename" ToolTip="Rename this Item" CommandArgument='<%# Eval("FullPath") %>' meta:resourcekey="btnRenameResource3" />
					&bull;
					<anthem:LinkButton ID="btnDelete" runat="server" Visible='<%# (bool)Eval("CanDelete") %>' Text="Delete" CommandName="Delete" ToolTip="Delete this Item" CommandArgument='<%# Eval("FullPath") %>' OnClientClick="javascript:if(!ConfirmDeletion()) return false;" meta:resourcekey="btnDeleteResource2" />
					<%# ((bool)Eval("Editable") ? "&bull; <a href=\"#\" onclick=\"javascript:return OpenPopupImageEditor('" + Eval("FullPath") + "');\">" + ScrewTurn.Wiki.Properties.Messages.Edit + "</a>" : "")%>
				</td>
			</tr>
		</AlternatingItemTemplate>
		<FooterTemplate>
			</tbody>
			</table>
		</FooterTemplate>
	</anthem:Repeater>
	<br />
	<anthem:Label ID="lblNoList" runat="server" CssClass="resulterror" Text="You cannot list the contents of this directory." Visible="False" 
		AutoUpdateAfterCallBack="True" meta:resourcekey="lblNoListResource1" />

</div>

<div id="FileManagementControlsDiv">
<anthem:Panel ID="pnlNewDirectory" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="pnlNewDirectoryResource1">
	<div id="NewDirectoryDiv">
		<h3 class="separator"><asp:Literal ID="lblNewDirectoryTitle" runat="server" Text="Create New Directory" EnableViewState="False" meta:resourcekey="lblNewDirectoryTitleResource1" /></h3>
		<asp:Literal ID="lblDirectoryName" runat="server" Text="Directory Name" EnableViewState="False" meta:resourcekey="lblDirectoryNameResource1" /><br />
		<anthem:TextBox ID="txtNewDirectoryName" runat="server" meta:resourcekey="txtNewDirectoryNameResource1" />
		<anthem:Button ID="btnNewDirectory" runat="server" Text="Create" OnClick="btnNewDirectory_Click" meta:resourcekey="btnNewDirectoryResource1" />
		<anthem:Label ID="lblNewDirectoryResult" runat="server" meta:resourcekey="lblNewDirectoryResultResource1" />
	</div>
</anthem:Panel>
	
<anthem:Panel ID="pnlUpload" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="pnlUploadResource1">
	<div id="UploadDiv">
		<h3 class="separator"><asp:Literal ID="lblUploadFiles" runat="server" Text="Upload Files" EnableViewState="False" meta:resourcekey="lblUploadFilesResource1" /></h3>
		<p class="small"><asp:Literal ID="lblUploadFilesInfo" runat="server" Text="You can upload files up to $1. Allowed file types are: $2." 
			meta:resourcekey="lblUploadFilesInfoResource1" /></p>
		<br />
		<asp:CheckBox ID="chkOverwrite" runat="server" Text="Overwrite existing file" meta:resourcekey="chkOverwriteResource1" /><br />
		<asp:FileUpload ID="fileUpload" runat="server" meta:resourcekey="fileUploadResource1" />
		<span id="UploadButtonSpan">
		<asp:Button ID="btnUpload" runat="server" Text="Upload" OnClick="btnUpload_Click" meta:resourcekey="btnUploadResource1"
			OnClientClick="javascript:return ShowUploadProgress();" />
		</span>
		<span id="UploadProgressSpan" style="display: none;"><img src="Images/Wait.gif" alt="Uploading..." /></span>
		<asp:Label ID="lblUploadResult" runat="server" meta:resourcekey="lblUploadResultResource1" />
	</div>
</anthem:Panel>

<div class="cleanupright"></div>

<anthem:Panel ID="pnlPermissions" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="pnlPermissionsResource1">
	<div id="PermissionsDiv">
		<h3 class="separator"><asp:Literal ID="lblManagePermissions" runat="server" Text="Manage Permissions" EnableViewState="False" 
			meta:resourcekey="lblManagePermissionsResource1" /></h3>
		<st:PermissionsManager ID="permissionsManager" runat="server" CurrentResourceType="Directories" />
	</div>
</anthem:Panel>
</div>

<div class="cleanup"></div>
