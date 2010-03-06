<%@ Page Language="C#" MasterPageFile="~/MasterPageSA.master" AutoEventWireup="true" Inherits="ScrewTurn.Wiki.UserProfile" Title="Untitled Page" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="Profile.aspx.cs" %>

<%@ Register TagPrefix="st" TagName="LanguageSelector" Src="~/LanguageSelector.ascx" %>

<asp:Content ID="CtnProfile" ContentPlaceHolderID="CphMasterSA" Runat="Server">
    <script type="text/javascript">
    <!-- 
        function cvPassword_ClientValidate(source, args) {
	        var txtP1 = __GetServerElementById("txtPassword1").value
			var txtP2 = __GetServerElementById("txtPassword2").value
			var bValid = true;
				  
			if((txtP1.length > 0) && (txtP2.length > 0)) {
		        bValid = (txtP1 == txtP2);
		    }
				  
            args.IsValid = bValid;
		}
				
		function cvEmail_ClientValidate(source, args) {
		    var txtE1 = __GetServerElementById("txtEmail1").value
			var txtE2 = __GetServerElementById("txtEmail2").value
			var bValid = true;
				  
		    if((txtE1.length > 0) && (txtE2.length > 0)) {
			    bValid = (txtE1 == txtE2);
		    }
				  
            args.IsValid = bValid;
		}
    // -->
    </script>
    
    <h1 class="pagetitlesystem"><asp:Literal ID="lblTitle" runat="server" meta:resourcekey="lblTitleResource1" Text="User Profile" EnableViewState="False" /></h1>
   
    <p><asp:Literal ID="lblDescription" runat="server" meta:resourcekey="lblDescriptionResource1" Text="Welcome to your Profile, " EnableViewState="False" />
        <b><asp:Literal ID="lblUsername" runat="server" meta:resourcekey="lblUsernameResource1" /></b>.
        <asp:Literal ID="lblGroups" runat="server" Text="You are member of the following groups:" EnableViewState="False" meta:resourcekey="lblGroupsResource1" />
        <asp:Literal ID="lblGroupsList" runat="server" meta:resourcekey="lblGroupsListResource1" />.<br />
        <asp:Literal ID="lblInfo" runat="server" meta:resourcekey="lblInfoResource1" EnableViewState="False" Text="Here you can edit your Profile settings, such as Email address and Password. You cannot change your Username." />
    </p> 
    <br />
    
    <asp:Panel ID="pnlUserData" runat="server" meta:resourcekey="pnlDetailsResource1">
    
		<h2 class="separator"><asp:Literal ID="lblNotifications" runat="server" Text="Email Notification Settings" EnableViewState="False" meta:resourcekey="lblNotificationsResource1" /></h2>
		
		<table cellpadding="0" cellspacing="0">
			<tr>
				<td style="width: 40%; padding-right: 20px; vertical-align: top;">
					<asp:Literal ID="lblPageChangesInfo" runat="server" Text="Receive an email notification whenever a <b>page</b> in the following namespaces is updated (only pages you have access to):" 
						EnableViewState="False" meta:resourcekey="lblPageChangesInfoResource2" />
					<br /><br />
					<asp:CheckBoxList ID="lstPageChanges" runat="server" meta:resourcekey="lstPageChangesResource1" />
				</td>
				<td style="width: 40%; padding-left: 20px; vertical-align: top;">
					<asp:Literal ID="lblDiscussionMessagesInfo" runat="server" Text="Receive an email notification whenever a <b>message</b> is posted for a page in the following namespaces (only discussions you have access to):" 
						EnableViewState="False" meta:resourcekey="lblDiscussionMessagesInfoResource2" />
					<br /><br />
					<asp:CheckBoxList ID="lstDiscussionMessages" runat="server" meta:resourcekey="lstDiscussionMessagesResource1" />
				</td>
			</tr>
			<tr>
				<td colspan="2" style="vertical-align: top; padding-top: 20px;">
					<anthem:Button ID="btnSaveNotifications" runat="server" Text="Save" OnClick="btnSaveNotifications_Click" CausesValidation="False"
						meta:resourcekey="btnSaveNotificationsResource1" />
					<anthem:Label ID="lblNotificationsResult" runat="server" meta:resourcekey="lblNotificationsResultResource1" 
						AutoUpdateAfterCallBack="True" UpdateAfterCallBack="True" />
				</td>
			</tr>
		</table>
		<br />
		
		<h2 class="separator"><asp:Literal ID="lblLanguageTimeZone" runat="server" Text="Language and Time Zone" EnableViewState="False" 
			meta:resourcekey="lblLanguageTimeZoneResource1" /></h2>
		<st:LanguageSelector ID="languageSelector" runat="server" />
		<br /><br />
		<asp:Button ID="btnSaveLanguage" runat="server" Text="Save" OnClick="btnSaveLanguage_Click" meta:resourcekey="btnSaveLanguageResource1" />
		<asp:Label ID="lblLanguageResult" runat="server" meta:resourcekey="lblLanguageResultResource1" />
		<br /><br />
		
	</asp:Panel>
	
	<asp:Panel ID="pnlAccount" runat="server" 
		meta:resourcekey="pnlAccountResource1">
   
		<h2 class="separator"><asp:Literal ID="lblEditEmailPassword" runat="server" 
			Text="Edit Display Name, Email and Password" EnableViewState="False" 
			meta:resourcekey="lblEditEmailPasswordResource1" /></h2>
		
		<table cellpadding="0" cellspacing="4">
			<tr>
				<td><p style="text-align: right;"><asp:Literal ID="lblDisplayName" runat="server" 
						Text="Display Name" EnableViewState="False" 
						meta:resourcekey="lblDisplayNameResource1" /></p></td>
				<td>
					<asp:TextBox ID="txtDisplayName" runat="server" Width="200px" ValidationGroup="vgDisplayName"
						ToolTip="Type here a display name for your account" CausesValidation="True" 
						meta:resourcekey="txtDisplayNameResource1" />
					<asp:RegularExpressionValidator EnableClientScript="False" ID="rxvDisplayName" 
						CssClass="resulterror" Display="Dynamic" ValidationGroup="vgDisplayName"
						runat="server" ControlToValidate="txtDisplayName" EnableTheming="False" 
						ErrorMessage="Invalid Display Name" meta:resourcekey="rxvDisplayNameResource1" />
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>
					<asp:Button ID="btnSaveDisplayName" runat="server" Text="Save Display Name" OnClick="btnSaveDisplayName_Click"
						ToolTip="Click here to save your Display Name" ValidationGroup="vgDisplayName" 
						meta:resourcekey="btnSaveDisplayNameResource1" />
					<asp:Label ID="lblSaveDisplayNameResult" runat="server" 
						meta:resourcekey="lblSaveDisplayNameResultResource1" />
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td><p style="text-align: right;"><asp:Literal ID="lblEmail1" runat="server" meta:resourcekey="lblEmail1Resource1" Text="Email" EnableViewState="False" />: </p></td>
				<td>
					<asp:TextBox ID="txtEmail1" runat="server" Width="200px" meta:resourcekey="txtEmail1Resource1" ToolTip="Type here your Email address" CausesValidation="True" ValidationGroup="vgEmail" />
					<asp:RequiredFieldValidator ID="rfvEmail1" runat="server" ControlToValidate="txtEmail1"
						ValidationGroup="vgEmail" ErrorMessage="Email is required" CssClass="resulterror" 
						Display="Dynamic" meta:resourcekey="rfvEmail1Resource1" />
					<asp:RegularExpressionValidator ID="rxvEmail1" runat="server" ControlToValidate="txtEmail1"
						ValidationExpression="^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})$"
						ValidationGroup="vgEmail" ErrorMessage="Invalid Email address" CssClass="resulterror" 
						Display="Dynamic" meta:resourcekey="rxvEmail1Resource1" />
					<asp:CustomValidator ID="cvEmail1" runat="server" ClientValidationFunction="cvEmail_ClientValidate"
						ControlToValidate="txtEmail1" OnServerValidate="cvEmail1_ServerValidate"
						ValidationGroup="vgEmail" ErrorMessage="Email addresses are not equal" 
						CssClass="resulterror" Display="Dynamic" meta:resourcekey="cvEmail1Resource1" />
				</td>
			</tr>
			<tr>
				<td><p style="text-align: right;"><asp:Literal ID="lblEmail2" runat="server" meta:resourcekey="lblEmail2Resource1" Text="Email (repeat)" EnableViewState="False" />: </p></td>
				<td><asp:TextBox ID="txtEmail2" runat="server" Width="200px" meta:resourcekey="txtEmail2Resource1" ToolTip="Repeat your Email address" CausesValidation="True" ValidationGroup="vgEmail" />
					<asp:RequiredFieldValidator ID="rfvEmail2" runat="server" ControlToValidate="txtEmail2"
						ValidationGroup="vgEmail" ErrorMessage="Email is required" CssClass="resulterror" 
						Display="Dynamic" meta:resourcekey="rfvEmail2Resource1" />
					<asp:CustomValidator ID="cvEmail2" runat="server" ClientValidationFunction="cvEmail_ClientValidate"
						ControlToValidate="txtEmail2" OnServerValidate="cvEmail2_ServerValidate"
						ValidationGroup="vgEmail" ErrorMessage="Email addresses are not equal" 
						CssClass="resulterror" Display="Dynamic" meta:resourcekey="cvEmail2Resource1" />
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>
					<asp:Button ID="btnSaveEmail" runat="server" Text="Save Email" OnClick="btnSaveEmail_Click" meta:resourcekey="btnSaveEmailResource1"
						ToolTip="Click here to save your Email address" ValidationGroup="vgEmail" />
					<asp:Label ID="lblSaveEmailResult" runat="server" meta:resourcekey="lblSaveEmailResultResource1" />
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td><p style="text-align: right;"><asp:Literal ID="lblOldPassword" runat="server" meta:resourcekey="lblOldPasswordResource1" Text="Old Password" EnableViewState="False" />: </p></td>
				<td><asp:TextBox ID="txtOldPassword" runat="server" Width="200px" TextMode="Password" meta:resourcekey="txtOldPasswordResource1" ToolTip="Type here your current Password" CausesValidation="True" ValidationGroup="vgPassword" />
					<asp:RequiredFieldValidator ID="rfvOldPassword" runat="server" ControlToValidate="txtOldPassword"
						ValidationGroup="vgPassword" ErrorMessage="Old Password is required" CssClass="resulterror" 
						Display="Dynamic" meta:resourcekey="rfvOldPasswordResource1" />
					<asp:CustomValidator ID="cvOldPassword" runat="server" ControlToValidate="txtOldPassword"
						EnableTheming="False" OnServerValidate="cvOldPassword_ServerValidate" ValidationGroup="vgPassword"
						ErrorMessage="Incorrect Password" CssClass="resulterror" Display="Dynamic" 
						meta:resourcekey="cvOldPasswordResource1" />
				</td>
			</tr>
			<tr>
				<td><p style="text-align: right;"><asp:Literal ID="lblPassword1" runat="server" meta:resourcekey="lblPassword1Resource1" Text="Password" EnableViewState="False" />: </p></td>
				<td><asp:TextBox ID="txtPassword1" runat="server" Width="200px" TextMode="Password" meta:resourcekey="txtPassword1Resource1" ToolTip="Type here your new Password" CausesValidation="True" ValidationGroup="vgPassword" />
					<asp:RequiredFieldValidator ID="rfvPassword1" runat="server" ControlToValidate="txtPassword1"
						ValidationGroup="vgPassword" ErrorMessage="Password is required" CssClass="resulterror" 
						Display="Dynamic" meta:resourcekey="rfvPassword1Resource1" />
					<asp:RegularExpressionValidator ID="rxvPassword1" runat="server" ControlToValidate="txtPassword1"
						ValidationExpression="^(\w{8,})$" ValidationGroup="vgPassword" 
						ErrorMessage="Invalid Password" CssClass="resulterror" Display="Dynamic" 
						meta:resourcekey="rxvPassword1Resource1" />
					<asp:CustomValidator ID="cvPassword1" runat="server" ClientValidationFunction="cvPassword_ClientValidate"
						ControlToValidate="txtPassword1" OnServerValidate="cvPassword1_ServerValidate" ValidationGroup="vgPassword"
						ErrorMessage="Passwords are not equal" CssClass="resulterror" Display="Dynamic" 
						meta:resourcekey="cvPassword1Resource1" />
				</td>
			</tr>
			<tr>
				<td><p style="text-align: right;"><asp:Literal ID="lblPassword2" runat="server" meta:resourcekey="lblPassword2Resource1" Text="Password (repeat)" EnableViewState="False" />: </p></td>
				<td><asp:TextBox ID="txtPassword2" runat="server" Width="200px" TextMode="Password" meta:resourcekey="txtPassword2Resource1" ToolTip="Repeat your new Password" CausesValidation="True" ValidationGroup="vgPassword" />
					<asp:RequiredFieldValidator ID="rfvPassword2" runat="server" ControlToValidate="txtPassword2"
						ValidationGroup="vgPassword" ErrorMessage="Password is required" CssClass="resulterror" 
						Display="Dynamic" meta:resourcekey="rfvPassword2Resource1" />
					<asp:CustomValidator ID="cvPassword2" runat="server" ClientValidationFunction="cvPassword_ClientValidate"
						ControlToValidate="txtPassword2" OnServerValidate="cvPassword2_ServerValidate" ValidationGroup="vgPassword"
						ErrorMessage="Passwords are not equal" CssClass="resulterror" Display="Dynamic" 
						meta:resourcekey="cvPassword2Resource1" />
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>
					<asp:Button ID="btnSavePassword" runat="server" Text="Save Password" OnClick="btnSavePassword_Click" meta:resourcekey="btnSavePasswordResource1" ToolTip="Click here to save your new Password" /> 
					<asp:Label ID="lblSavePasswordResult" runat="server" meta:resourcekey="lblSavePasswordResultResource1" />
				</td>
			</tr>
		</table>
	   
		<br />
		<h2 class="separator"><asp:Literal ID="lblDeleteAccount" runat="server" Text="Delete Account" meta:resourcekey="lblDeleteAccountResource1" EnableViewState="False" /></h2>
		<p><asp:Literal ID="lblDeleteAccountInfo" runat="server" EnableViewState="False" meta:resourcekey="lblDeleteAccountInfoResource1"
			Text="You can delete your account by clicking on the Delete Account button and then confirming with the Confirm button.<br /><b>Warning</b>: the operation is irreversible." /></p>
		<br /> 
		<anthem:Button ID="btnDeleteAccount" runat="server" Text="Delete Account" OnClick="btnDeleteAccount_Click"
			meta:resourcekey="btnDeleteAccountResource1" CausesValidation="False" 
			AutoUpdateAfterCallBack="True" UpdateAfterCallBack="True" />
		<anthem:Button ID="btnConfirm" runat="server" Text="Confirm" Enabled="False" OnClick="btnConfirm_Click"
			meta:resourcekey="btnConfirmResource1" CausesValidation="False" 
			AutoUpdateAfterCallBack="True" PreCallBackFunction="__RequestConfirm" 
			UpdateAfterCallBack="True" />
    
    </asp:Panel>
    
    <asp:Panel ID="pnlNoChanges" runat="server" Visible="False" 
		meta:resourcekey="pnlNoChangesResource1">
		<br />
		<i>
			<asp:Literal ID="lblNoChanges" runat="server" 
			Text="Current system settings do not allow any change to your personal information." 
			EnableViewState="False" meta:resourcekey="lblNoChangesResource1" />
		</i>
    </asp:Panel>

</asp:Content>
