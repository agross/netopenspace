<%@ Control Language="C#" AutoEventWireup="true" Inherits="ScrewTurn.Wiki.AttachmentManager" Codebehind="AttachmentManager.ascx.cs" %>

<asp:Literal ID="lblStrings" runat="server" meta:resourcekey="lblStringsResource1" />

<script type="text/javascript">
<!--
    function ConfirmDeletion() {
        return confirm(ConfirmMessage);
    }
    function ShowUploadProgress() {
    	document.getElementById("UploadProgressSpan").style["display"] = "";
    	document.getElementById("UploadButtonSpan").style["display"] = "none";
    	
    	// Suppress "Navigate away?" message in Edit.aspx
    	__SetSubmitted();
        return true;
    }

    function OpenPopupImageEditor(file, page) {
    	var settings = "center=yes,resizable=yes,dialog,status=no,scrollbars=no,width=560,height=400";
    	window.open(CurrentNamespace + "ImageEditor.aspx?File=" + file + "&Page=" + page, "Popup", settings);
    	return false;
    }
// -->
</script>

<div id="MainAttachmentManagerDiv">

	<div id="DirectoriesDiv">
		<anthem:DropDownList ID="lstProviders" runat="server" AutoCallBack="True" OnSelectedIndexChanged="lstProviders_SelectedIndexChanged" meta:resourcekey="lstProvidersResource1" />
		<anthem:LinkButton ID="btnRefresh" runat="server" Text="Refresh" OnClick="btnRefresh_Click" meta:resourcekey="btnRefreshResource1" />
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

	<anthem:Repeater ID="rptItems" runat="server" AutoUpdateAfterCallBack="true"
		OnDataBinding="rptItems_DataBinding" OnItemCommand="rptItems_ItemCommand">
		<HeaderTemplate>
			<table id="AttachmentManagerTable" class="generic" cellpadding="0" cellspacing="0">
				<thead>
				<tr class="tableheader">
					<th>&nbsp;</th>
					<th><asp:Literal ID="lblName" runat="server" Text="Name" EnableViewState="False" meta:resourcekey="lblNameResource1" /></th>
					<th><asp:Literal ID="lblSize" runat="server" Text="Size" EnableViewState="False" meta:resourcekey="lblSizeResource1" /></th>
					<th><asp:Literal ID="lblDownloads" runat="server" Text="Downloads" EnableViewState="False" meta:resourcekey="lblDownloadsResource1" /></th>
					<th>&nbsp;</th>
				</tr>
				</thead>
				<tbody>
		</HeaderTemplate>
		<ItemTemplate>
			<tr class="tablerow">
				<td><img src="Images/File.png" alt="-" /></td>
				<td><a href='<%# Eval("Link") %>' title="<%# ScrewTurn.Wiki.Properties.Messages.Download %>" style='<%# ((bool)Eval("CanDownload") ? "" : "text-decoration: line-through;") %>'><%# Eval("Name") %></a></td>
				<td><%# Eval("Size") %></td>
				<td><%# Eval("Downloads") %></td>
				<td>
					<anthem:LinkButton ID="btnRename" runat="server" Visible='<%# (bool)Eval("CanDelete") %>' Text="Rename" CommandName="Rename" ToolTip="Rename this Attachment" CommandArgument='<%# Eval("Name") %>' meta:resourcekey="btnRenameResource2" />
					&bull;
					<anthem:LinkButton ID="btnDelete" runat="server" Visible='<%# (bool)Eval("CanDelete") %>' Text="Delete" CommandName="Delete" ToolTip="Delete this Attachment" CommandArgument='<%# Eval("Name") %>' PreCallBackFunction="ConfirmDeletion" meta:resourcekey="btnDeleteResource1" />
					<%# ((bool)Eval("Editable") ? "&bull; <a href=\"#\" onclick=\"javascript:return OpenPopupImageEditor('" + Eval("Name") + "', '" + Eval("Page") + "');\">" + ScrewTurn.Wiki.Properties.Messages.Edit + "</a>" : "")%>
				</td>
			</tr>
		</ItemTemplate>
		<AlternatingItemTemplate>
			<tr class="tablerowalternate">
				<td><img src="Images/File.png" alt="-" /></td>
				<td><a href='<%# Eval("Link") %>' title="<%# ScrewTurn.Wiki.Properties.Messages.Download %>" style='<%# ((bool)Eval("CanDownload") ? "" : "text-decoration: line-through;") %>'><%# Eval("Name") %></a></td>
				<td><%# Eval("Size") %></td>
				<td><%# Eval("Downloads") %></td>
				<td>
					<anthem:LinkButton ID="btnRename" runat="server" Visible='<%# (bool)Eval("CanDelete") %>' Text="Rename" CommandName="Rename" ToolTip="Rename this Attachment" CommandArgument='<%# Eval("Name") %>' meta:resourcekey="btnRenameResource3" />
					&bull;
					<anthem:LinkButton ID="btnDelete" runat="server" Visible='<%# (bool)Eval("CanDelete") %>' Text="Delete" CommandName="Delete" ToolTip="Delete this Attachment" CommandArgument='<%# Eval("Name") %>' PreCallBackFunction="ConfirmDeletion" meta:resourcekey="btnDeleteResource2" />
					<%# ((bool)Eval("Editable") ? "&bull; <a href=\"#\" onclick=\"javascript:return OpenPopupImageEditor('" + Eval("Name") + "', '" + Eval("Page") + "');\">" + ScrewTurn.Wiki.Properties.Messages.Edit + "</a>" : "")%>
				</td>
			</tr>
		</AlternatingItemTemplate>
		<FooterTemplate>
			</tbody>
			</table>
		</FooterTemplate>
	</anthem:Repeater>

</div>

<div id="UploadAttachmentDiv">
    <p class="small"><asp:Literal ID="lblUploadFilesInfo" runat="server" Text="You can upload attachments for the current Page up to $1. Allowed file types are: $2." meta:resourcekey="lblUploadFilesInfoResource1" /></p>
    <br />
    <asp:CheckBox ID="chkOverwrite" runat="server" Text="Overwrite existing attachment" meta:resourcekey="chkOverwriteResource1" /><br />
    <asp:FileUpload ID="fileUpload" runat="server" meta:resourcekey="fileUploadResource1" />
    <span id="UploadButtonSpan">
    <asp:Button ID="btnUpload" runat="server" Text="Upload" OnClick="btnUpload_Click"
		OnClientClick="javascript:return ShowUploadProgress();" meta:resourcekey="btnUploadResource1" />
	</span>
    <asp:Label ID="lblNoUpload" runat="server" CssClass="small" Text="<br />Save the page before uploading" meta:resourcekey="lblNoUploadResource1" />
    <span id="UploadProgressSpan" style="display: none;"><img src="Images/Wait.gif" alt="Uploading..." /></span>
    <asp:Label ID="lblUploadResult" runat="server" meta:resourcekey="lblUploadResultResource1" />
</div>

<div class="cleanup"></div>
