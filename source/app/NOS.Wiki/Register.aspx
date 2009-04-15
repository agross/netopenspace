<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="ScrewTurn.Wiki.Register" Title="Untitled Page" EnableSessionState="True" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" %>
<%@ Register TagPrefix="st" TagName="Captcha" Src="~/Captcha.ascx" %>
<%@ Register TagPrefix="nos" TagName="AutoRegistration" Src="~/AutoRegistration.ascx" %>

<asp:Content ID="CtnRegister" ContentPlaceHolderID="CphMaster" Runat="Server">

    <script type="text/javascript">
    <!--
    
        function cvPassword_ClientValidate(source, args) {
			var txtP1 = __GetServerElementById("txtPassword1").value;
			var txtP2 = __GetServerElementById("txtPassword2").value;
			var bValid = true;
				  
			if((txtP1.length > 0) && (txtP2.length > 0) ) {
			    bValid = (txtP1 == txtP2);
			}
				  
            args.IsValid = bValid;
		}
				
		function cvEmail_ClientValidate(source, args) {
			var txtE1 = __GetServerElementById("txtEmail1").value;
			var txtE2 = __GetServerElementById("txtEmail2").value;
			var bValid = true;
				  
			if((txtE1.length > 0) && (txtE2.length > 0) ) {
			    bValid = (txtE1 == txtE2);
		    }
				  
            args.IsValid = bValid;
		}
				
    // -->
    </script>
    
    <h1 class="pagetitlesystem"><asp:Literal ID="lblTitle" runat="server" meta:resourcekey="lblTitleResource1" Text="Create a new Account" /></h1>
   
    <p><asp:Literal ID="lblRegisterDescription" runat="server" Text="Here you can create a new Account for this Wiki.<br /><b>Note</b>: all the fields are mandatory. The Email address will not be published in any way, but it will be visible to the Administrators." meta:resourcekey="lblRegisterDescriptionResource1" /></p>
    <br />
    <div class="warning"><asp:Literal ID="lblAccountActivationMode" runat="server" /></div>
    <p><asp:Label ID="lblResult" runat="server" meta:resourcekey="lblResultResource1" /></p>
     
    <asp:Panel ID="pnlRegister" runat="server">
        <br /><br /> 
        <table width="100%" cellpadding="0" cellspacing="4">
			<colgroup>
				<col width="30%" />
				<col width="*" />
			</colgroup>
            <tr>
                <td><p style="text-align: right;"><asp:Literal ID="lblUsername" runat="server" meta:resourcekey="lblUsernameResource1" Text="Username" />:</p></td>
                <td><asp:TextBox ID="txtUsername" runat="server" Width="200px" meta:resourcekey="txtUsernameResource1" ToolTip="Type here your Username" CausesValidation="True" />
                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUsername" EnableTheming="False"
						ErrorMessage="Resources.Messages.RequiredField"><img src="Images/InputError.png" alt="*" /></asp:RequiredFieldValidator>
				    <asp:RegularExpressionValidator EnableClientScript="false" ID="rxvUserName" runat="server" ControlToValidate="txtUsername" EnableTheming="False" 
				        ErrorMessage="Resources.Messages.InvalidUsername" ValidationExpression="^(\w[\w\ !$%^\.\(\)]{3,25})$"><img src="Images/InputError.png" alt="*" /></asp:RegularExpressionValidator>
				    <asp:CustomValidator ID="cvUsername" runat="server" ControlToValidate="txtUsername" EnableTheming="False"
				        ErrorMessage="Resources.Messages.UsernameAlreadyExists" OnServerValidate="cvUsername_ServerValidate" EnableClientScript="false"><img src="Images/InputError.png" alt="*" /></asp:CustomValidator>
				</td>
            </tr>
            <tr>
                <td><p style="text-align: right;"><asp:Literal ID="lblEmail1" runat="server" meta:resourcekey="lblEmail1Resource1" Text="Email" />:</p></td>
                <td><asp:TextBox ID="txtEmail1" runat="server" Width="200px" meta:resourcekey="txtEmail1Resource1" ToolTip="Type here your Email address" CausesValidation="True" />
                    <asp:RequiredFieldValidator ID="rfvEmail1" runat="server" ControlToValidate="txtEmail1" EnableTheming="False"
					    ErrorMessage="Resources.Messages.RequiredField"><img src="Images/InputError.png" alt="*" /></asp:RequiredFieldValidator>
					<asp:RegularExpressionValidator ID="rxvEmail1" runat="server" ControlToValidate="txtEmail1" EnableTheming="False"
					    ErrorMessage="Resources.Messages.InvalidEmail" ValidationExpression="^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})$"><img src="Images/InputError.png" alt="*" /></asp:RegularExpressionValidator>
				    <asp:CustomValidator ID="cvEmail1" runat="server" ControlToValidate="txtEmail1" EnableTheming="False" ClientValidationFunction="cvEmail_ClientValidate"
				        ErrorMessage="Resources.Messages.PasswordsNotEqual" OnServerValidate="cvEmail1_ServerValidate"><img src="Images/InputError.png" alt="*" /></asp:CustomValidator>
				</td>
            </tr>
            <tr>
                <td><p style="text-align: right;"><asp:Literal ID="lblEmail2" runat="server" meta:resourcekey="lblEmail2Resource1" Text="Email (repeat)" />:</p></td>
                <td><asp:TextBox ID="txtEmail2" runat="server" Width="200px" meta:resourcekey="txtEmail2Resource1" ToolTip="Repeat your Email address" CausesValidation="True" />
                    <asp:RequiredFieldValidator ID="rfvEmail2" runat="server" ControlToValidate="txtEmail2" EnableTheming="False"
					    ErrorMessage="Resources.Messages.RequiredField"><img src="Images/InputError.png" alt="*" /></asp:RequiredFieldValidator>
					<asp:CustomValidator ID="cvEmail2" runat="server" ControlToValidate="txtEmail2" EnableTheming="False" ClientValidationFunction="cvEmail_ClientValidate"
					    ErrorMessage="Resources.Messages.PasswordsNotEqual" OnServerValidate="cvEmail2_ServerValidate"><img src="Images/InputError.png" alt="*" /></asp:CustomValidator>
			    </td>
            </tr>
            <tr>
                <td><p style="text-align: right;"><asp:Literal ID="lblPassword1" runat="server" meta:resourcekey="lblPassword1Resource1" Text="Password" />:</p></td>
                <td><asp:TextBox ID="txtPassword1" runat="server" TextMode="Password" Width="200px" meta:resourcekey="txtPassword1Resource1" ToolTip="Type here your Password" CausesValidation="True" />
                    <asp:RequiredFieldValidator ID="rfvPassword1" runat="server" ControlToValidate="txtPassword1" EnableTheming="False"
					    ErrorMessage="Resources.Messages.RequiredField"><img src="Images/InputError.png" alt="*" /></asp:RequiredFieldValidator>
					<asp:RegularExpressionValidator EnableClientScript="false" ID="rxvPassword1" runat="server" ControlToValidate="txtPassword1" EnableTheming="False"
					    ErrorMessage="Resources.Messages.InvalidPassword" ValidationExpression="^(\w{8,})$"><img src="Images/InputError.png" alt="*" /></asp:RegularExpressionValidator>
					<asp:CustomValidator ID="cvPassword1" runat="server" ControlToValidate="txtPassword1" EnableTheming="False" ClientValidationFunction="cvPassword_ClientValidate"
					    ErrorMessage="Resources.Messages.PasswordsNotEqual" OnServerValidate="cvPassword1_ServerValidate"><img src="Images/InputError.png" alt="*" /></asp:CustomValidator>
			    </td>
            </tr>
            <tr>
                <td><p style="text-align: right;"><asp:Literal ID="lblPassword2" runat="server" meta:resourcekey="lblPassword2Resource1" Text="Password (repeat)" />:</p></td>
                <td><asp:TextBox ID="txtPassword2" runat="server" TextMode="Password" Width="200px" meta:resourcekey="txtPassword2Resource1" ToolTip="Repeat your Password" CausesValidation="True" />
                    <asp:RequiredFieldValidator ID="rfvPassword2" runat="server" ControlToValidate="txtPassword2" EnableTheming="False"
					    ErrorMessage="Resources.Messages.RequiredField"><img src="Images/InputError.png" alt="*" /></asp:RequiredFieldValidator>
					<asp:CustomValidator ID="cvPassword2" runat="server" ControlToValidate="txtPassword2" EnableTheming="False" ClientValidationFunction="cvPassword_ClientValidate"
					    ErrorMessage="Resources.Messages.PasswordsNotEqual" OnServerValidate="cvPassword2_ServerValidate"><img src="Images/InputError.png" alt="*" /></asp:CustomValidator>
			    </td>
            </tr>
            <nos:AutoRegistration ID="AutoRegistration" runat="server" />
            <tr>
                <td style="vertical-align: top;"><p style="text-align: right;"><asp:Literal ID="lblCaptcha" runat="server" Text="Control Text (case sensitive):" meta:resourcekey="lblCaptchaResource1" /></p></td>
                <td><st:Captcha ID="captcha" runat="server" /></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td><asp:Button ID="btnRegister" runat="server" Text="Create Account" OnClick="btnRegister_Click" meta:resourcekey="btnRegisterResource1" ToolTip="Click here to create your Account" /></td>
            </tr>
			<tr>
				<td>
				</td>
				<td>
					<asp:ValidationSummary ID="vsNewAccount" runat="server" CssClass="resulterror" Width="100%" />
				</td>
			</tr>
       </table>
   </asp:Panel>
     
</asp:Content>

