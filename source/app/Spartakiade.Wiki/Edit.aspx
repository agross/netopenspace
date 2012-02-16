<%@ Page Language="C#" MasterPageFile="~/MasterPageSA.master" AutoEventWireup="true" CodeBehind="Edit.aspx.cs" Inherits="ScrewTurn.Wiki.Edit" ValidateRequest="false" culture="auto" meta:resourcekey="PageResource2" uiculture="auto" %>

<%@ Register TagPrefix="st" TagName="Editor" Src="~/Editor.ascx" %>
<%@ Register TagPrefix="st" TagName="Captcha" Src="~/Captcha.ascx" %>
<%@ Register TagPrefix="st" TagName="AttachmentManager" Src="~/AttachmentManager.ascx" %>

<asp:Content ID="CtnEdit" ContentPlaceHolderID="CphMasterSA" runat="server">

	<script type="text/javascript">
	<!--
	
		var submitted = false;
		function __UnloadPage(e) {
		    if (!submitted) {
		        if (document.getElementById('EditorDiv').getElementsByTagName('textarea')[0].value.length != 0) {
				    e.returnValue = " ";
				}
			}
		}

		function __SetSubmitted() {
			submitted = true;
        }
		
		function __RequestConfirmIfNotEmpty() {
		    if (document.getElementById('EditorDiv').getElementsByTagName('textarea')[0].value.length != 0) {
		      return(__RequestConfirm());
		    }
		}
		
	// -->
	</script>

	<asp:Panel ID="pnlCollisions" runat="server" Visible="False" 
		CssClass="collisionsmanagement" meta:resourcekey="pnlCollisionsResource1">
        <asp:Literal ID="lblConcurrentEditing" runat="server" Text="&lt;b&gt;Warning&lt;/b&gt;: this Page is being edited by another user" meta:resourcekey="lblConcurrentEditingResource1" />
        <asp:Literal ID="lblConcurrentEditingUsername" runat="server" meta:resourcekey="lblConcurrentEditingUsernameResource1" />.
        <asp:Literal ID="lblSaveDangerous" runat="server" Visible="False" Text="Saving this Page might result in a &lt;b&gt;data-loss&lt;/b&gt;." meta:resourcekey="lblSaveDangerousResource1" />
        <asp:Literal ID="lblSaveDisabled" runat="server" Visible="False" Text="The Administrators don't allow to save this Page." meta:resourcekey="lblSaveDisabledResource1" />
        <asp:Literal ID="lblRefreshLink" runat="server" meta:resourcekey="lblRefreshLinkResource1" />
	</asp:Panel>
	
	<asp:Panel ID="pnlAnonymous" runat="server" Visible="False" CssClass="anonymous" meta:resourcekey="pnlAnonymousResource1">
		<asp:Literal ID="lblIpLogged" runat="server" Text="Since you are not logged in, your IP Address will be used as Username." meta:resourcekey="lblIpLoggedResource1" />
	</asp:Panel>
	
	<asp:Panel ID="pnlDraft" runat="server" Visible="False" CssClass="draftmanagement" meta:resourcekey="pnlDraftResource1">
		<asp:Literal ID="lblDraftInfo" runat="server" Text="You are currently editing a previously saved <b>draft</b> of this page, edited by <b>##USER##</b> on <b>##DATETIME##</b> (##VIEWCHANGES##)." 
			meta:resourcekey="lblDraftInfoResource1" />
		<asp:Literal ID="lblDraftInfo2" runat="server" Text="If you think this content is ready for display, simply unckeck the 'Save as Draft' checkbox near the 'Save' button. Note: drafts are not versioned." 
			meta:resourcekey="lblDraftInfo2Resource1" /><br />
	</asp:Panel>
	
	<asp:Panel ID="pnlApprovalRequired" runat="server" Visible="False" CssClass="draftmanagement" meta:resourcekey="pnlApprovalRequiredResource1">
		<asp:Literal ID="lblApprovalRequiredInfo" runat="server" Text="Your changes to this page will be saved in a draft and they will not be published until an editor or administrator approves them." 
			EnableViewState="False" meta:resourcekey="lblApprovalRequiredInfoResource1" />
	</asp:Panel>
	
	<div id="EditNoticeDiv">
		<asp:Literal ID="lblEditNotice" runat="server" EnableViewState="False" meta:resourcekey="lblEditNoticeResource1" />
	</div>
	
	<div id="ButtonsDiv">
		<asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" ValidationGroup="nametitle" meta:resourcekey="btnSaveResource1" />
		<asp:Button ID="btnSaveAndContinue" runat="server" Text="Save &amp; Continue" OnClick="btnSave_Click" ValidationGroup="nametitle" meta:resourcekey="btnSaveAndContinueResource1" />
		<asp:Button ID="btnCancel" runat="server" Text="Cancel" CausesValidation="False" OnClick="btnCancel_Click" meta:resourcekey="btnCancelResource1" />
		<div id="SaveOptionsDiv">
			<anthem:CheckBox ID="chkMinorChange" runat="server" Text="Minor Change (no backup)" OnCheckedChanged="chkMinorChange_CheckedChanged"
				AutoCallBack="True" AutoUpdateAfterCallBack="True" meta:resourcekey="chkMinorChangeResource1" UpdateAfterCallBack="True" /><br />
			<anthem:CheckBox ID="chkSaveAsDraft" runat="server" Text="Save as Draft" OnCheckedChanged="chkSaveAsDraft_CheckedChanged"
				AutoCallBack="True" AutoUpdateAfterCallBack="True" meta:resourcekey="chkSaveAsDraftResource1" UpdateAfterCallBack="True" />
		</div>
		<div id="ResultDiv">
			<asp:Label ID="lblResult" runat="server" EnableViewState="False" meta:resourcekey="lblResultResource1" />
		</div>
	</div>

	<div id="PageNameAndTitleDiv">
		<anthem:Panel ID="pnlPageName" runat="server">
			<asp:Literal ID="lblName" runat="server" Text="Page Name (used for linking pages)" meta:resourcekey="lblNameResource1" /><br />
			<asp:TextBox ID="txtName" runat="server" CssClass="bigtextbox large" ToolTip="Type the name of the page here" meta:resourcekey="txtNameResource2" />
			<asp:RequiredFieldValidator ID="rfvName" runat="server" CssClass="resulterror" ErrorMessage="Name is required"
				Display="Dynamic" ControlToValidate="txtName" ValidationGroup="nametitle" meta:resourcekey="rfvNameResource1" />
			<asp:CustomValidator ID="cvName1" runat="server" CssClass="resulterror" ErrorMessage="Invalid Page Name"
				Display="Dynamic" ControlToValidate="txtName" OnServerValidate="cvName1_ServerValidate" ValidationGroup="nametitle" meta:resourcekey="cvName1Resource1" />
			<asp:CustomValidator ID="cvName2" runat="server" CssClass="resulterror" ErrorMessage="Page already exists"
				Display="Dynamic" ControlToValidate="txtName" OnServerValidate="cvName2_ServerValidate" ValidationGroup="nametitle" meta:resourcekey="cvName2Resource1" />
			<br />
		</anthem:Panel>
		<anthem:Panel ID="pnlManualName" runat="server" Visible="false">
			<anthem:LinkButton ID="btnManualName" runat="server" Text="Specify page name manually..."
				OnClick="btnManualName_Click" CssClass="small" meta:resourcekey="btnManualNameResource1" />
			<br />
		</anthem:Panel>
		<asp:Literal ID="lblTitle" runat="server" Text="Page Title" meta:resourcekey="lblTitleResource1" /><br />
		<asp:TextBox ID="txtTitle" runat="server" CssClass="bigtextbox large" ToolTip="Type the title of the page here" ValidationGroup="nametitle" 
			meta:resourcekey="txtTitleResource2" />
		<asp:RequiredFieldValidator ID="rfvTitle" runat="server" CssClass="resulterror" ErrorMessage="Title is required"
			Display="Dynamic" ControlToValidate="txtTitle" ValidationGroup="nametitle" meta:resourcekey="rfvTitleResource1" />
	</div>
	
	<div id="TemplatesDiv">
		<anthem:LinkButton ID="btnTemplates" runat="server" Text="Content Templates..." OnClick="btnTemplates_Click" 
			AutoUpdateAfterCallBack="True" meta:resourcekey="btnTemplatesResource1" CssClass="small" />
		
		<anthem:Panel ID="pnlTemplates" runat="server" Visible="False" AutoUpdateAfterCallBack="True" meta:resourcekey="pnlTemplatesResource1">
			<div id="TemplatesInternalDiv">
				<anthem:DropDownList ID="lstTemplates" runat="server" AutoCallBack="True" OnSelectedIndexChanged="lstTemplates_SelectedIndexChanged" 
					meta:resourcekey="lstTemplatesResource1" />
				<div id="TemplatePreviewDiv">
					<anthem:Label ID="lblTemplatePreview" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="lblTemplatePreviewResource1" 
						UpdateAfterCallBack="True" />
				</div>
				<small>
					<anthem:LinkButton ID="btnUseTemplate" runat="server" Text="Use Template" ToolTip="Use this Template (replace current content)"
						CausesValidation="False" AutoUpdateAfterCallBack="True" Visible="False" PreCallBackFunction="__RequestConfirmIfNotEmpty" OnClick="btnUseTemplate_Click" 
						meta:resourcekey="btnUseTemplateResource1" UpdateAfterCallBack="True" />
					&bull;
					<anthem:LinkButton ID="btnCancelTemplate" runat="server" Text="Cancel" ToolTip="Close the Templates toolbar"
						CausesValidation="False" OnClick="btnCancelTemplate_Click" meta:resourcekey="btnCancelTemplateResource1" />
				</small>
			</div>
		</anthem:Panel>
	</div>
	
	<anthem:Panel ID="pnlAutoTemplate" runat="server" Visible="False" CssClass="autotemplate" AutoUpdateAfterCallBack="True" 
		meta:resourcekey="pnlAutoTemplateResource1" UpdateAfterCallBack="True">
		<asp:Literal ID="lblAutoTemplate" runat="server" Text="The Content Template &quot;##TEMPLATE##&quot; was selected automatically. You can discard the content as well as select another Template using the link above." 
			meta:resourcekey="lblAutoTemplateResource1" />
		<anthem:LinkButton ID="btnAutoTemplateOK" runat="server" Text="Close" ToolTip="Close this message" OnClick="btnAutoTemplateOK_Click" 
			meta:resourcekey="btnAutoTemplateOKResource1" />
	</anthem:Panel>
	
	<div id="EditorDiv">
		<st:Editor ID="editor" runat="server" OnSelectedTabChanged="editor_SelectedTabChanged" />
	</div>
	
	<asp:Panel ID="pnlCaptcha" runat="server" CssClass="captcha" meta:resourcekey="pnlCaptchaResource1">
		<st:Captcha ID="captcha" runat="server" />
	</asp:Panel>
	
	<div id="CategoriesDiv">
		<div>
			<h3 class="separator"><asp:Literal ID="lblCategories" runat="server" Text="Page Categories" EnableViewState="False" meta:resourcekey="lblCategoriesResource1" /></h3>
			<div id="CategoriesListDiv">
				<anthem:CheckBoxList ID="lstCategories" runat="server" CssClass="medium h_short" RepeatLayout="Flow" AutoUpdateAfterCallBack="True" 
					meta:resourcekey="lstCategoriesResource1" UpdateAfterCallBack="True" />
			</div>
			<anthem:Panel ID="pnlCategoryCreation" runat="server" CssClass="categorycreation" AutoUpdateAfterCallBack="True" 
				meta:resourcekey="pnlCategoryCreationResource1" UpdateAfterCallBack="True">
				<asp:Literal ID="lblNewCategory" runat="server" Text="New Category" EnableViewState="False" meta:resourcekey="lblNewCategoryResource1" /><br />
				<anthem:TextBox ID="txtCategory" runat="server" CssClass="short" ToolTip="Type the name of the category here" ValidationGroup="category" 
					meta:resourcekey="txtCategoryResource2" />
				<anthem:Button ID="btnCreateCategory" runat="server" Text="Create" ValidationGroup="category" OnClick="btnCreateCategory_Click" 
					meta:resourcekey="btnCreateCategoryResource1" /><br />
				<asp:RequiredFieldValidator ID="rfvCategory" runat="server" ValidationGroup="category" ControlToValidate="txtCategory" Display="Dynamic"
					ErrorMessage="Name is required" meta:resourcekey="rfvCategoryResource1" />
				<asp:CustomValidator ID="cvCategory1" runat="server" ValidationGroup="category" ControlToValidate="txtCategory" Display="Dynamic"
					ErrorMessage="Invalid Name" OnServerValidate="cvCategory1_ServerValidate" meta:resourcekey="cvCategory1Resource1" />
				<asp:CustomValidator ID="cvCategory2" runat="server" ValidationGroup="category" ControlToValidate="txtCategory" Display="Dynamic"
					ErrorMessage="Category already exists" OnServerValidate="cvCategory2_ServerValidate" meta:resourcekey="cvCategory2Resource1" />
				<anthem:Label ID="lblCategoryResult" runat="server" meta:resourcekey="lblCategoryResultResource1" />
			</anthem:Panel>
		</div>
	</div>
	
	<div id="EditCommentDiv">
		<h3 class="separator"><asp:Literal ID="lblMeta" runat="server" Text="Meta Information" EnableViewState="False" meta:resourcekey="lblMetaResource1" /></h3>
		<asp:Literal ID="lblKeywords" runat="server" Text="Meta Keywords (separate with commas)" EnableViewState="False" meta:resourcekey="lblKeywordsResource1" /><br />
		<asp:TextBox ID="txtKeywords" runat="server" ToolTip="Type the keywords for this page here, separated with commas (optional)" meta:resourcekey="txtKeywordsResource2" /><br />
		<asp:Literal ID="lblDescription" runat="server" Text="Meta Description" EnableViewState="False" meta:resourcekey="lblDescriptionResource1" /><br />
		<asp:TextBox ID="txtDescription" runat="server" ToolTip="Type the description for this page here (optional)" meta:resourcekey="txtDescriptionResource2" />
		<asp:Literal ID="lblComment" runat="server" Text="Comment for this change" EnableViewState="False" meta:resourcekey="lblCommentResource1" /><br />
		<asp:TextBox ID="txtComment" runat="server" ToolTip="Type a comment for this change here (optional)" meta:resourcekey="txtCommentResource2" />
	</div>
	
	<div id="AttachmentsDiv">
		<h3 class="separator"><asp:Literal ID="lblAttachmentManager" runat="server" Text="Page Attachments Management" meta:resourcekey="lblAttachmentManagerResource1" /></h3>
		<st:AttachmentManager ID="attachmentManager" runat="server" />
	</div>
	
	<asp:Literal ID="lblSessionRefresh" runat="server" EnableViewState="False" meta:resourcekey="lblSessionRefreshResource1" />
	
	<script type="text/javascript">
	<!--		
		__GetServerElementById("btnSave").onclick = __SetSubmitted;
		if(__GetServerElementById("btnSaveAndContinue")) {
			__GetServerElementById("btnSaveAndContinue").onclick = __SetSubmitted;
		}
		__GetServerElementById("btnCancel").onclick = __SetSubmitted;
		if(__GetServerElementById("btnNewCategory")) {
		    __GetServerElementById("btnNewCategory").onclick = __SetSubmitted;
		}

		$(function() {
			$("#<%= txtTitle.ClientID %>").focus().keydown(function(event) {
				if(event.keyCode == 9 /* TAB */) {
					event.preventDefault();
					__FocusEditorWindow();
				}
			});
		});
	// -->
    </script>
	
	<asp:Literal ID="lblUnloadPage" runat="server" meta:resourcekey="lblUnloadPageResource1" />
	
	<div class="cleanup"></div>

</asp:Content>
