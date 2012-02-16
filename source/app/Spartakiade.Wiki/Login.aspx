<%@ Page Language="C#" MasterPageFile="~/MasterPageSA.master" AutoEventWireup="true" Inherits="ScrewTurn.Wiki.Login" Title="Untitled Page" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" EnableSessionState="True" Codebehind="Login.aspx.cs" %>

<asp:Content ID="CtnLogin" ContentPlaceHolderID="CphMasterSA" Runat="Server">

    <h1 class="pagetitlesystem"><asp:Literal ID="lblTitle" runat="server" meta:resourcekey="lblTitleResource1" Text="Login" /></h1>    
    <asp:MultiView ID="mlvLogin" runat="server" ActiveViewIndex="1">
        <asp:View ID="viwLogout" runat="server">
            <asp:Literal ID="lblLogout" runat="server" Text="you are currently logged in. To logout, please click on the Logout button." meta:resourcekey="lblLogoutResource1" />
            <br /><br />
            <asp:Button ID="btnLogout" runat="server" Text="Logout" meta:resourcekey="btnLogoutResource1" OnClick="btnLogout_Click" ToolTip="Click to Logout" />
        </asp:View>
        <asp:View ID="viwLogin" runat="server">
			<asp:Literal ID="lblDescription" runat="server" meta:resourcekey="lblDescriptionResource1"
				Text="Here you can login to the wiki. Don't you have an account? You can <a href=&quot;Register.aspx&quot; title=&quot;Create a new Account&quot;>create one</a>." />
			<br /><br />
            <table>
                <tr>
                    <td><p style="text-align: right;"><asp:Literal ID="lblUsername" runat="server" meta:resourcekey="lblUsernameResource1" Text="Username" />:</p></td>
                    <td><asp:TextBox ID="txtUsername" runat="server" Width="200px" meta:resourcekey="txtUsernameResource1" ToolTip="Type here your Username" /></td>
                </tr> 
                <tr>
                    <td><p style="text-align: right;">
                        <asp:Literal ID="lblPassword" runat="server" meta:resourcekey="lblPasswordResource1" Text="Password" />:</p></td>
                    <td><asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Width="200px" meta:resourcekey="txtPasswordResource1" ToolTip="Type here your Password" /></td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td><asp:CheckBox ID="chkRemember" runat="server" Text="Remember me" meta:resourcekey="chkRememberResource1" ToolTip="Check this if you want the system to remember you next time" /></td>
                </tr>
                <tr>
                    <td style="height: 24px">&nbsp;</td>
                    <td style="height: 24px">
                        <asp:Button ID="btnLogin" runat="server" Text="Login" meta:resourcekey="btnLoginResource1" OnClick="btnLogin_Click" ToolTip="Click to Login" CausesValidation="False" />
                        <a href="Login.aspx?PasswordReset=1"><asp:Literal ID="lblLostPassword" runat="server" meta:resourcekey="lblLostPasswordResource1" /></a>
                    </td>
                </tr>
            </table>
            
            <script type="text/javascript">
            <!--
                __GetServerElementById("txtUsername").focus();
            // -->
            </script>
            
        </asp:View>
        
        <asp:View ID="viwResetPassword" runat="server">
            <h3 class="separator"><asp:Literal ID="lblResetPassword" runat="server" Text="Reset Password" EnableViewState="False" meta:resourcekey="lblResetPasswordResource1" /></h3>
            <asp:Literal ID="lblResetPasswordInformation" runat="server" EnableViewState="False" meta:resourcekey="lblResetPasswordInformationResource1"
				Text="If you forgot your Password, please insert your Username <b>or</b> Email address, then click on the Reset Password button.<br />You will receive an email with a link to reset your password." />
            <br /><br />
            <table>
				<tr>
					<td>
						<p style="text-align: right;"><asp:Literal runat="server" ID="lblUsernameReset" Text="Username" meta:resourcekey="lblUsernameResetResource1" EnableViewState="False" />:</p>
					</td>
					<td><asp:TextBox ID="txtUsernameReset" runat="server" Width="200px" meta:resourcekey="txtUsernameResetResource1" /></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td><b>--- <asp:Literal ID="lblOr" runat="server" Text="or" EnableViewState="False" meta:resourcekey="lblOrResource1" /> ---</b></td>
				</tr>
				<tr>
					<td>
						<p style="text-align: right;"><asp:Literal runat="server" ID="lblEmailReset" Text="Email" meta:resourcekey="lblEmailResetResource1" EnableViewState="False" />:</p>
					</td>
					<td><asp:TextBox ID="txtEmailReset" runat="server" Width="200px" meta:resourcekey="txtEmailResetResource1" /></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td><asp:Button ID="btnResetPassword" runat="server" Text="Reset Password" OnClick="btnResetPassword_Click"	meta:resourcekey="btnResetPasswordResource1" CausesValidation="False" /></td>
				</tr>
			</table>
        </asp:View>
        
        <asp:View ID="viwResetPassword2" runat="server">
			<h3 class="separator"><asp:Literal ID="lblResetPassword2" runat="server" Text="Reset Password" EnableViewState="False" meta:resourcekey="lblResetPassword2Resource1" /></h3>
			<asp:Literal ID="lblResetPassword2Info" runat="server" Text="Please enter your new password twice." EnableViewState="False" meta:resourcekey="lblResetPassword2InfoResource1" />
			<br /><br />
			<table>
				<tr>
					<td>
						<p style="text-align: right;"><asp:Literal ID="lblNewPassword1" runat="server" Text="Password" EnableViewState="False" meta:resourcekey="lblNewPassword1Resource1" /></p>
					</td>
					<td>
						<asp:TextBox ID="txtNewPassword1" runat="server" Width="200px" TextMode="Password" meta:resourcekey="txtNewPassword1Resource1" />
						<asp:RequiredFieldValidator ID="rfvNewPassword1" runat="server" Display="Dynamic" ValidationGroup="reset" CssClass="resulterror"
							ControlToValidate="txtNewPassword1" ErrorMessage="Password is required" meta:resourcekey="rfvNewPassword1Resource1" />
						<asp:RegularExpressionValidator ID="rxNewPassword1" runat="server" Display="Dynamic" ValidationGroup="reset" CssClass="resulterror"
							ControlToValidate="txtNewPassword1" ErrorMessage="Invalid Password" meta:resourcekey="rxNewPassword1Resource1" />
					</td>
				</tr>
				<tr>
					<td>
						<p style="text-align: right;"><asp:Literal ID="lblNewPassword2" runat="server" Text="Password (repeat)" EnableViewState="False" meta:resourcekey="lblNewPassword2Resource1" /></p>
					</td>
					<td>
						<asp:TextBox ID="txtNewPassword2" runat="server" Width="200px" TextMode="Password" meta:resourcekey="txtNewPassword2Resource1" />
						<asp:RequiredFieldValidator ID="rfvNewPassword2" runat="server" Display="Dynamic" ValidationGroup="reset" CssClass="resulterror"
							ControlToValidate="txtNewPassword2" ErrorMessage="Password is required" meta:resourcekey="rfvNewPassword2Resource1" />
						<asp:RegularExpressionValidator ID="rxNewPassword2" runat="server" Display="Dynamic" ValidationGroup="reset" CssClass="resulterror"
							ControlToValidate="txtNewPassword2" ErrorMessage="Invalid Password" meta:resourcekey="rxNewPassword2Resource1" />
						<asp:CustomValidator ID="cvNewPasswords" runat="server" Display="Dynamic" ValidationGroup="reset"
							ControlToValidate="txtNewPassword2" ErrorMessage="Passwords are not equal" CssClass="resulterror"
							OnServerValidate="cvNewPasswords_ServerValidate" meta:resourcekey="cvNewPasswordsResource1" />
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td><asp:Button ID="btnSaveNewPassword" runat="server" Text="Save New Password" OnClick="btnSaveNewPassword_Click" ValidationGroup="reset" meta:resourcekey="btnSaveNewPasswordResource1" /></td>
				</tr>
			</table>
        </asp:View>
    </asp:MultiView>
    <br />
    <asp:Label ID="lblResult" runat="server" meta:resourcekey="lblResultResource1" />
   
</asp:Content>

