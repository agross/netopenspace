<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeBehind="AdminContent.aspx.cs" Inherits="ScrewTurn.Wiki.AdminContent" ValidateRequest="false" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" %>

<%@ Register TagPrefix="st" TagName="Editor" Src="~/Editor.ascx" %>

<asp:Content ID="ctnHead" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="ctnContent" ContentPlaceHolderID="cphAdmin" runat="server">
	<h2 class="sectiontitle"><asp:Literal ID="lblContent" runat="server" Text="Content Editing" EnableViewState="False" meta:resourcekey="lblContentResource1" /></h2>
	
	<asp:Panel ID="pnlList" runat="server" meta:resourcekey="pnlListResource1">
		<asp:Literal ID="lblNamespace" runat="server" Text="Namespace" EnableViewState="False" meta:resourcekey="lblNamespaceResource1" />
		<asp:DropDownList ID="lstNamespace" runat="server" meta:resourcekey="lstNamespaceResource1" />
		<br /><br />
		
		<div id="PageLayoutElements">
			<h3><asp:Literal ID="lblPageLayout" runat="server" Text="Page Layout Elements (Namespace-Specific)" EnableViewState="False" meta:resourcekey="lblPageLayoutResource1" /></h3>
			<br />
			
			<table id="LayoutTable">
				<tr>
					<td colspan="2" id="HtmlHeadTd"><asp:LinkButton ID="btnHtmlHead" runat="server" Text="HTML Head" ToolTip="Edit the HTML Head tag" OnClick="btn_Click" meta:resourcekey="btnHtmlHeadResource1" /></td>
				</tr>
				<tr>
					<td colspan="2" id="HeaderTd"><asp:LinkButton ID="btnHeader" runat="server" Text="Header" ToolTip="Edit the global header" OnClick="btn_Click" meta:resourcekey="btnHeaderResource1" /></td>
				</tr>
				<tr>
					<td rowspan="3" id="SidebarTd"><asp:LinkButton ID="btnSidebar" runat="server" Text="Sidebar" ToolTip="Edit the sidebar (menu)" OnClick="btn_Click" meta:resourcekey="btnSidebarResource1" /></td>
					<td id="PageHeaderTd"><asp:LinkButton ID="btnPageHeader" runat="server" Text="Page Header" ToolTip="Edit the page header" OnClick="btn_Click" meta:resourcekey="btnPageHeaderResource1" /></td>
				</tr>
				<tr>
					<td id="PageContentTd"><asp:Literal ID="lblPageContent" runat="server" Text="Page Content" EnableViewState="False" meta:resourcekey="lblPageContentResource1" /></td>
				</tr>
				<tr>
					<td id="PageFooterTd"><asp:LinkButton ID="btnPageFooter" runat="server" Text="Page Footer" ToolTip="Edit the page footer" OnClick="btn_Click" meta:resourcekey="btnPageFooterResource1" /></td>
				</tr>
				<tr>
					<td colspan="2" id="FooterTd"><asp:LinkButton ID="btnFooter" runat="server" Text="Footer" ToolTip="Edit the global footer" OnClick="btn_Click" meta:resourcekey="btnFooterResource1" /></td>
				</tr>
			</table>
			<br />
			<span class="small">
				<asp:Literal ID="lblInfo" runat="server" Text="<b>Note</b>: the actual layout of your current theme might differ from the one displayed here." EnableViewState="False" meta:resourcekey="lblInfoResource1" />
			</span>
		</div>
		
		<div id="OtherElements">
			<h3><asp:Literal ID="lblOther" runat="server" Text="Other Elements" EnableViewState="False" meta:resourcekey="lblOtherResource1" /></h3>
			<br />
			<ul class="spaced">
				<li><asp:LinkButton ID="btnEditingPageNotice" runat="server" Text="Editing Page Notice (Namespace-specific)" ToolTip="Edit" OnClick="btn_Click" meta:resourcekey="btnEditingPageNoticeResource1" /><br />
					<span class="small"><asp:Literal ID="lblEditingPageNoticeInfo" runat="server" Text="The message displayed on top of the editing page." EnableViewState="False" meta:resourcekey="lblEditingPageNoticeInfoResource1" /></span></li>
				<li><asp:LinkButton ID="btnAccountActivationMessage" runat="server" Text="Account Activation Message (Global)" ToolTip="Edit" OnClick="btn_Click" meta:resourcekey="btnAccountActivationMessageResource1" /><br />
					<span class="small"><asp:Literal ID="lblAccountActivationMessageInfo" runat="server" Text="The email message sent to a newly registered user that have to activate her account." EnableViewState="False" meta:resourcekey="lblAccountActivationMessageInfoResource1" /></span></li>
				<li><asp:LinkButton ID="btnPasswordResetProcedureMessage" runat="server" Text="Password Reset Procedure Message (Global)" ToolTip="Edit" OnClick="btn_Click" meta:resourcekey="btnPasswordResetProcedureMessageResource1" /><br />
					<span class="small"><asp:Literal ID="lblPasswordResetProcedureMessageInfo" runat="server" Text="The email message sent to when a user want to reset her password." EnableViewState="False" meta:resourcekey="lblPasswordResetProcedureMessageInfoResource1" /></span></li>
				<li><asp:LinkButton ID="btnLoginNotice" runat="server" Text="Login Notice (Global)" ToolTip="Edit" OnClick="btn_Click" meta:resourcekey="btnLoginNoticeResource1" /><br />
					<span class="small"><asp:Literal ID="lblLoginNoticeInfo" runat="server" Text="The message replacing the information at the top of the login screen (if not empty)." EnableViewState="False" meta:resourcekey="lblLoginNoticeInfoResource1" /></span></li>
				<li><asp:LinkButton ID="btnAccessDeniedNotice" runat="server" Text="Access Denied Notice (Global)" ToolTip="Edit" OnClick="btn_Click" meta:resourcekey="btnAccessDeniedNoticeResource1" /><br />
					<span class="small"><asp:Literal ID="lblAccessDeniedNoticeInfo" runat="server" Text="The message replacing the information at the top of the access denied page (if not empty)." EnableViewState="False" meta:resourcekey="lblAccessDeniedNoticeInfoResource1" /></span></li>
				<li><asp:LinkButton ID="btnRegisterNotice" runat="server" Text="Register Notice (Global)" ToolTip="Edit" OnClick="btn_Click" meta:resourcekey="btnRegisterNoticeResource1" /><br />
					<span class="small"><asp:Literal ID="lblRegisterNoticeInfo" runat="server" Text="The message replacing the information at the top of the register screen (if not empty)." EnableViewState="False" meta:resourcekey="lblRegisterNoticeInfoResource1" /></span></li>
				<li><asp:LinkButton ID="btnPageChangeMessage" runat="server" Text="Page Change Message (Global)" ToolTip="Edit" OnClick="btn_Click" meta:resourcekey="btnPageChangeMessageResource1" /><br />
					<span class="small"><asp:Literal ID="lblPageChangeMessageInfo" runat="server" Text="The email message sent to users when a page is modified." EnableViewState="False" meta:resourcekey="lblPageChangeMessageInfoResource1" /></span></li>
				<li><asp:LinkButton ID="btnDiscussionChangeMessage" runat="server" Text="Discussion Change Message (Global)" ToolTip="Edit" OnClick="btn_Click" meta:resourcekey="btnDiscussionChangeMessageResource1" /><br />
					<span class="small"><asp:Literal ID="lblDiscussionChangeMessageInfo" runat="server" Text="The email message sent to users when a new message is posted to a discussion." EnableViewState="False" meta:resourcekey="lblDiscussionChangeMessageInfoResource1" /></span></li>
				<li><asp:LinkButton ID="btnApproveDraftMessage" runat="server" Text="Approve Draft Message (Global)" ToolTip="Edit" OnClick="btn_Click" meta:resourcekey="btnApproveDraftMessageResource1" /><br />
					<span class="small"><asp:Literal ID="lblApproveDraftMessageInfo" runat="server" Text="The email message sent to editor/administrators when a page draft requires approval." EnableViewState="False" meta:resourcekey="lblApproveDraftMessageInfoResource1" /></span></li>
			</ul>
		</div>
	</asp:Panel>
	
	<asp:Panel ID="pnlEditor" runat="server" Visible="False" meta:resourcekey="pnlEditorResource1">
		<asp:Panel ID="pnlInlineTools" runat="server">
			<div id="InlineToolsDiv">
				<!-- RESX!!! -->
				<asp:Literal ID="lblCopyFrom" runat="server" Text="Copy content from: " meta:resourcekey="lblCopyFromResource1" />
				<asp:DropDownList ID="lstCopyFromNamespace" runat="server" />
				<asp:LinkButton ID="btnCopyFrom" runat="server" meta:resourcekey="btnCopyFromResource1"
					Text="Go" ToolTip="Copy the content of the same layout area from the selected Namespace"
					OnClick="btnCopyFrom_Click"
					OnClientClick="javascript:return RequestConfirm();" />
			</div>
		</asp:Panel>
		
		<st:Editor ID="editor" runat="server" />
		
		<div id="ButtonsDiv">
			<asp:Button ID="btnSave" runat="server" Text="Save" ToolTip="Save the content" OnClick="btnSave_Click" meta:resourcekey="btnSaveResource1" />
			<asp:Button ID="btnCancel" runat="server" Text="Cancel" ToolTip="Cancel and return" OnClick="btnCancel_Click" meta:resourcekey="btnCancelResource1" />
		</div>
	</asp:Panel>
	
	<asp:HiddenField ID="txtCurrentButton" runat="server" />
	
	<div style="clear: both;"></div>
	
</asp:Content>
