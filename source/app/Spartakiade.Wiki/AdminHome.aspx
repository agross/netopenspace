<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeBehind="AdminHome.aspx.cs" Inherits="ScrewTurn.Wiki.AdminHome" culture="auto" meta:resourcekey="PageResource2" uiculture="auto" %>

<asp:Content ID="ctnHead" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="ctnAdminHome" ContentPlaceHolderID="cphAdmin" runat="server">
	<script type="text/javascript">
	<!--
		function PreIndexRebuild() {
			if(RequestConfirm()) {
				document.getElementById("ProgressSpan").style["display"] = "";
				return true;
			}
			else return false;
		}

		function PostIndexRebuild() {
			document.getElementById("ProgressSpan").style["display"] = "none";
		}

		function PreLinksRebuild() {
			if(RequestConfirm()) {
				document.getElementById("OrphansProgressSpan").style["display"] = "";
				return true;
			}
			else return false;
		}

		function PostLinksRebuild() {
			document.getElementById("OrphansProgressSpan").style["display"] = "none";
		}
	// -->
	</script>

	<h2 class="sectiontitle"><asp:Literal ID="lblAdminHome" runat="server" Text="Administration Home" EnableViewState="False" meta:resourcekey="lblAdminHomeResource1" /></h2>
	
	<div id="BulkEmailDiv">
		<h2 class="separator"><asp:Literal ID="lblBulkEmail" runat="server" Text="Mass Email" EnableViewState="false" meta:resourcekey="lblBulkEmailResource1" /></h2>
		<asp:Literal ID="lblBulkEmailInfo" runat="server" Text="You can send an email message to all users of one or more groups." EnableViewState="false" meta:resourcekey="lblBulkEmailInfoResource1" />
		<br /><br />
		<asp:CheckBoxList ID="lstGroups" runat="server" CellSpacing="3" RepeatDirection="Horizontal" RepeatLayout="Table" RepeatColumns="2" />
		<br />
		<asp:Literal ID="lblSubject" runat="server" Text="Subject" EnableViewState="false" meta:resourcekey="lblSubjectResource1" /><br />
		<asp:TextBox ID="txtSubject" runat="server" CssClass="textbox" /><br />
		<asp:TextBox ID="txtBody" runat="server" TextMode="MultiLine" CssClass="body" />
		<br /><br />
		<asp:Button ID="btnSendBulkEmail" runat="server" Text="Send Mass Email" ValidationGroup="email" OnClick="btnSendBulkEmail_Click" meta:resourcekey="btnSendBulkEmailResource1" />
		<asp:RequiredFieldValidator ID="rfvSubject" runat="server" Display="Dynamic" CssClass="resulterror"
			ControlToValidate="txtSubject" ErrorMessage="Subject is required" ValidationGroup="email" meta:resourcekey="rfvSubjectResource1" />
		<asp:RequiredFieldValidator ID="rfvBody" runat="server" Display="Dynamic" CssClass="resulterror"
			ControlToValidate="txtBody" ErrorMessage="Body is required" ValidationGroup="email" meta:resourcekey="rfvBodyResource1" />
		<asp:CustomValidator ID="cvGroups" runat="server" Display="Dynamic" CssClass="resulterror"
			ErrorMessage="You must select at least one group" ValidationGroup="email" meta:resourcekey="cvGroupsResource1"
			OnServerValidate="cvGroups_ServerValidate" />
		<asp:Label ID="lblEmailResult" runat="server" />
	</div>
	
    <p>
        <asp:Literal ID="lblSystemStatusContent" runat="server" meta:resourcekey="lblSystemStatusContentResource1" />
        <br /><br />
        <asp:Button ID="btnClearCache" runat="server" Text="Clear Cache" OnClick="btnClearCache_Click" ToolTip="Clears the Cache" meta:resourcekey="btnClearCacheResource1" />
    </p>
    <br /><br />
    
    <h2 class="separator"><asp:Literal ID="lblMissingPages" runat="server" Text="Missing Pages" EnableViewState="False" meta:resourcekey="lblMissingPagesResource1" /></h2>
    <asp:Repeater ID="rptPages" runat="server" OnDataBinding="rptPages_DataBinding">
		<HeaderTemplate>
			<table class="generic" cellpadding="0" cellspacing="0">
				<thead>
				<tr class="tableheader">
					<th><asp:Literal ID="lblNamespace" runat="server" Text="Namespace" EnableViewState="False" meta:resourcekey="lblNamespaceResource1" /></th>
					<th><asp:Literal ID="lblPage" runat="server" Text="Page Name" EnableViewState="False" meta:resourcekey="lblPageResource1" /></th>
					<th><asp:Literal ID="lblLinkedIn" runat="server" Text="Linked in" EnableViewState="False" meta:resourcekey="lblLinkedInResource1" /></th>
				</tr>
				</thead>
				<tbody>
		</HeaderTemplate>
		<ItemTemplate>
			<tr class="tablerow">
				<td><a href='<%# Eval("NspacePrefix") %>Default.aspx' title='<%= ScrewTurn.Wiki.Properties.Messages.GoToMainPage %>' target="_blank"><%# Eval("Nspace") %></a></td>
				<td><a href='<%# Eval("NspacePrefix") %>Edit.aspx?Page=<%# ScrewTurn.Wiki.Tools.UrlEncode(Eval("Name") as string) %>' title='<%= ScrewTurn.Wiki.Properties.Messages.CreateThisPage %>' target="_blank"><%# ScrewTurn.Wiki.PluginFramework.NameTools.GetLocalName(Eval("Name") as string) %></a></td>
				<td><%# Eval("LinkingPages") %></td>
			</tr>
		</ItemTemplate>
		<AlternatingItemTemplate>
			<tr class="tablerowalternate">
				<td><a href='<%# Eval("NspacePrefix") %>Default.aspx' title='<%= ScrewTurn.Wiki.Properties.Messages.GoToMainPage %>' target="_blank"><%# Eval("Nspace") %></a></td>
				<td><a href='<%# Eval("NspacePrefix") %>Edit.aspx?Page=<%# ScrewTurn.Wiki.Tools.UrlEncode(Eval("Name") as string) %>' title='<%= ScrewTurn.Wiki.Properties.Messages.CreateThisPage %>' target="_blank"><%# ScrewTurn.Wiki.PluginFramework.NameTools.GetLocalName(Eval("Name") as string) %></a></td>
				<td><%# Eval("LinkingPages") %></td>
			</tr>
		</AlternatingItemTemplate>
		<FooterTemplate>
			</tbody>
			</table>
		</FooterTemplate>
    </asp:Repeater>
    <br /><br />
    
    <h2 class="separator"><asp:Literal ID="lblOrphanPages" runat="server" Text="Orphan Pages" EnableViewState="false" meta:resourcekey="lblOrphanPagesResource1" /></h2>
    <asp:Literal ID="lblOrphanPagesInfoPre" runat="server" Text="There seem to be " EnableViewState="false" meta:resourcekey="lblOrphanPagesInfoPreResource1" />
    <b><anthem:Label ID="lblOrphanPagesCount" runat="server" Text="0" AutoUpdateAfterCallBack="true" /></b>
    <asp:Literal ID="lblOrphanPagesInfoPost" runat="server" Text=" orphan pages in the wiki" EnableViewState="false" meta:resourcekey="lblOrphanPagesInfoPostResource1" />
    <small>(<asp:HyperLink ID="lnkPages" runat="server" Text="see Pages" ToolTip="Go to the Pages administration tab" NavigateUrl="~/AdminPages.aspx" meta:resourcekey="lnkPagesResource1" />)</small>.
    <br />
    <small><asp:Literal ID="lblOrphanPagesInfo" runat="server" Text="<b>Note</b>: a page is considered an <i>orphan</i> when it has no incoming links from other pages."
		EnableViewState="false" meta:resourcekey="lblOrphanPagesInfoResource1" /></small>
    <br /><br />
    
    <anthem:Button ID="btnRebuildPageLinks" runat="server" Text="Rebuild Page Links" ToolTip="Rebuild the links structure"
		PreCallBackFunction="PreLinksRebuild" PostCallBackFunction="PostLinksRebuild" meta:resourcekey="btnRebuildPageLinksResource1"
		OnClick="btnRebuildPageLinks_Click" />
    <span id="OrphansProgressSpan" style="display: none;">
		<img src="Images/Wait.gif" alt="Rebuilding..." />
		<img src="Images/Wait.gif" alt="Rebuilding..." />
		<img src="Images/Wait.gif" alt="Rebuilding..." />
    </span>
    <br /><br />
    
    <small><asp:Literal ID="lblRebuildPageLinksInfo" runat="server" meta:resourcekey="lblRebuildPageLinksInfoResource1"
		Text="<b>Warning</b>: rebuilding page links might take some time. Please do not close this screen while the links are being rebuilt." 
		EnableViewState="False" /></small>
	<br /><br />
    
    <h2 class="separator"><asp:Literal ID="lblIndexStatus" runat="server" Text="Search Index Status" EnableViewState="False" meta:resourcekey="lblIndexStatusResource1" /></h2>
    <anthem:Repeater ID="rptIndex" runat="server" OnDataBinding="rptIndex_DataBinding" OnItemCommand="rptIndex_ItemCommand" 
		AutoUpdateAfterCallBack="True">
		<HeaderTemplate>
			<table class="generic" cellpadding="0" cellspacing="0">
				<thead>
				<tr class="tableheader">
					<th><asp:Literal ID="lblProvider" runat="server" Text="Provider" EnableViewState="False" meta:resourcekey="lblProviderResource1" /></th>
					<th><asp:Literal ID="lblDocCount" runat="server" Text="Docs" EnableViewState="False" meta:resourcekey="lblDocCountResource1" /></th>
					<th><asp:Literal ID="lblWordCount" runat="server" Text="Words" EnableViewState="False" meta:resourcekey="lblWordCountResource1" /></th>
					<th><asp:Literal ID="lblOccurrenceCount" runat="server" Text="Matches" EnableViewState="False" meta:resourcekey="lblOccurrenceCountResource1" /></th>
					<th><asp:Literal ID="lblSize" runat="server" Text="Size" EnableViewState="False" meta:resourcekey="lblSizeResource1" /></th>
					<th><asp:Literal ID="lblStatus" runat="server" Text="Status" EnableViewState="False" meta:resourcekey="lblStatusResource1" /></th>
					<th>&nbsp;</th>
				</tr>
				</thead>
				<tbody>
		</HeaderTemplate>
		<ItemTemplate>
			<tr class="tablerow">
				<td><%# Eval("Provider") %></td>
				<td><%# Eval("Documents") %></td>
				<td><%# Eval("Words") %></td>
				<td><%# Eval("Occurrences") %></td>
				<td><%# Eval("Size") %></td>
				<td><%# ((bool)Eval("IsOK") ? ScrewTurn.Wiki.Properties.Messages.OK : "<span class=\"resulterror\">" + ScrewTurn.Wiki.Properties.Messages.Corrupted + "</span>")%></td>
				<td><anthem:LinkButton ID="btnRebuild" runat="server" Text="Rebuild" ToolTip="Rebuild this index" CommandName="Rebuild" CommandArgument='<%# Eval("ProviderType") %>'
					PreCallBackFunction="PreIndexRebuild" PostCallBackFunction="PostIndexRebuild" meta:resourcekey="btnRebuildResource1" /></td>
			</tr>
		</ItemTemplate>
		<AlternatingItemTemplate>
			<tr class="tablerowalternate">
				<td><%# Eval("Provider") %></td>
				<td><%# Eval("Documents") %></td>
				<td><%# Eval("Words") %></td>
				<td><%# Eval("Occurrences") %></td>
				<td><%# Eval("Size") %></td>
				<td><%# ((bool)Eval("IsOK") ? ScrewTurn.Wiki.Properties.Messages.OK : "<span class=\"resulterror\">" + ScrewTurn.Wiki.Properties.Messages.Corrupted + "</span>")%></td>
				<td><anthem:LinkButton ID="btnRebuild" runat="server" Text="Rebuild" ToolTip="Rebuild this index" CommandName="Rebuild" CommandArgument='<%# Eval("ProviderType") %>'
					PreCallBackFunction="PreIndexRebuild" PostCallBackFunction="PostIndexRebuild" meta:resourcekey="btnRebuildResource2" /></td>
			</tr>
		</AlternatingItemTemplate>
		<FooterTemplate>
			</tbody>
			</table>
		</FooterTemplate>
    </anthem:Repeater>
    <br />
    <span id="ProgressSpan" style="display: none;">
		<img src="Images/Wait.gif" alt="Rebuilding..." />
		<img src="Images/Wait.gif" alt="Rebuilding..." />
		<img src="Images/Wait.gif" alt="Rebuilding..." />
    </span>
    <small>
		<asp:Literal ID="lblRebuildIndexInfo" runat="server" 
			Text="<b>Warning</b>: rebuilding a search index might take some time. Please do not close this screen while the index is being rebuilt. After the index is rebuilt, it is recommended to restart the application." 
			EnableViewState="False" meta:resourcekey="lblRebuildIndexInfoResource1" />
	</small>
    <br /><br /><br />
    
    <h2 class="separator"><asp:Literal ID="lblAppShutdown" runat="server" Text="Web Application Shutdown" meta:resourcekey="lblAppShutdownResource1" /></h2>
    <asp:Literal ID="lblAppShutdownInfo" runat="server" 
		Text="You can force a shutdown-and-restart cycle of the Web Application. You will be asked to confirm the restart twice, then the Web Application will restart at the first subsequent request.&lt;br /&gt;&lt;b&gt;Warning&lt;/b&gt;: all the open sessions will be lost, and users may experience errors.&lt;br /&gt;&lt;b&gt;Note&lt;/b&gt;: the restart will affect only this Web Application." 
		meta:resourcekey="lblAppShutdownInfoResource1" />
    <br /><br />
    <div id="ShutdownDiv" class="warning">
        <asp:Button ID="btnShutdownConfirm" runat="server" Text="Shutdown Application" OnClientClick="javascript:return RequestConfirm();"
			OnClick="btnShutdownConfirm_Click" meta:resourcekey="btnShutdownConfirmResource2" />
    </div>
    
    <div style="clear: both;"></div>
</asp:Content>
