<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" ValidateRequest="false" Inherits="ScrewTurn.Wiki.Post" Title="Untitled Page" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="Post.aspx.cs" %>

<%@ Register TagPrefix="st" TagName="Captcha" Src="~/Captcha.ascx" %>
<%@ Register TagPrefix="st" TagName="Editor" Src="~/Editor.ascx" %>

<asp:Content ID="ctnPost" ContentPlaceHolderID="CphMaster" Runat="Server">

    <h1 class="pagetitlesystem"><asp:Literal ID="lblTitle" runat="server" Text="Post a Message" meta:resourcekey="lblTitleResource1" /></h1>
    
    <p><asp:Literal ID="lblSubject" runat="server" Text="Subject" meta:resourcekey="lblSubjectResource1" /></p>
    <asp:TextBox ID="txtSubject" runat="server" class="bigtextbox large" meta:resourcekey="txtSubjectResource1" />
    <br /><br />
    
    <st:Editor ID="editor" runat="server" />
    
    <div id="PostCaptchaDiv">
		<asp:Panel ID="pnlCaptcha" runat="server" style="float: left;">
			<st:Captcha ID="captcha" runat="server" />
		</asp:Panel>
		<div>
			<asp:Button ID="btnSend" runat="server" Text="Send" style="font-weight: bold;" OnClick="btnSend_Click" meta:resourcekey="btnSendResource1" />
			<asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" meta:resourcekey="btnCancelResource1" CausesValidation="false" />
			<asp:Label ID="lblResult" runat="server" meta:resourcekey="lblResultResource1" />
		</div>
    </div>
    
    <script type="text/javascript">
    <!--
    	$(function() {
    		$("#<%= txtSubject.ClientID %>").focus().keydown(function(event) {
    			if(event.keyCode == 9 /* TAB */) {
    				event.preventDefault();
    				__FocusEditorWindow();
    			}
    		});
    	});
    // -->
    </script>

</asp:Content>
