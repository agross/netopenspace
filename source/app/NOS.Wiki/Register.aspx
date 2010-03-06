<%@ Page Language="C#" MasterPageFile="~/MasterPageSA.master" AutoEventWireup="true" Inherits="ScrewTurn.Wiki.Register" Title="Untitled Page" EnableSessionState="True" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="Register.aspx.cs" %>
<%@ Register TagPrefix="st" TagName="Captcha" Src="~/Captcha.ascx" %>

<asp:Content ID="CtnRegister" ContentPlaceHolderID="CphMasterSA" Runat="Server">

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
    <div class="warning"><asp:Literal ID="lblAccountActivationMode" runat="server" meta:resourcekey="lblAccountActivationModeResource1" /></div>
    <p><asp:Label ID="lblResult" runat="server" meta:resourcekey="lblResultResource1" /></p>
     
    <asp:Panel ID="pnlRegister" runat="server" 
		meta:resourcekey="pnlRegisterResource1">
        <br /><br /> 
        <table width="600" cellpadding="0" cellspacing="4">
            <tr>
                <td><p style="text-align: right;"><asp:Literal ID="lblUsername" runat="server" meta:resourcekey="lblUsernameResource1" Text="Username" />:</p></td>
                <td><asp:TextBox ID="txtUsername" runat="server" Width="200px" meta:resourcekey="txtUsernameResource1" ToolTip="Type here your Username" CausesValidation="True" />
                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server" 
						CssClass="resulterror" Display="Dynamic"
						ControlToValidate="txtUsername" EnableTheming="False" ErrorMessage="Username is required" 
						meta:resourcekey="rfvUsernameResource1" />
				    <asp:RegularExpressionValidator EnableClientScript="False" ID="rxvUserName" 
						runat="server" ControlToValidate="txtUsername" EnableTheming="False" CssClass="resulterror" 
						Display="Dynamic" ErrorMessage="Invalid Username" 
						meta:resourcekey="rxvUserNameResource1" />
				    <asp:CustomValidator ID="cvUsername" runat="server"  CssClass="resulterror" Display="Dynamic"
						ControlToValidate="txtUsername" EnableTheming="False" ErrorMessage="Username already exists" 
						OnServerValidate="cvUsername_ServerValidate" EnableClientScript="False" 
						meta:resourcekey="cvUsernameResource1" />
				</td>
            </tr>
            <tr>
				<td><p style="text-align: right"><asp:Literal ID="lblDisplayName" runat="server" 
						Text="Display Name" meta:resourcekey="lblDisplayNameResource1" />:</p></td>
				<td><asp:TextBox ID="txtDisplayName" runat="server" Width="200px" 
						ToolTip="Type here a display name for your account" CausesValidation="True" 
						meta:resourcekey="txtDisplayNameResource1" />
					<asp:RegularExpressionValidator EnableClientScript="False" ID="rxvDisplayName" 
						CssClass="resulterror" Display="Dynamic"
						runat="server" ControlToValidate="txtDisplayName" EnableTheming="False" 
						ErrorMessage="Invalid Display Name" 
						meta:resourcekey="rxvDisplayNameResource1" />
				</td>
            </tr>
            <tr>
                <td><p style="text-align: right;"><asp:Literal ID="lblEmail1" runat="server" meta:resourcekey="lblEmail1Resource1" Text="Email" />:</p></td>
                <td><asp:TextBox ID="txtEmail1" runat="server" Width="200px" meta:resourcekey="txtEmail1Resource1" ToolTip="Type here your Email address" CausesValidation="True" />
                    <asp:RequiredFieldValidator ID="rfvEmail1" runat="server" 
						CssClass="resulterror" Display="Dynamic"
						ControlToValidate="txtEmail1" EnableTheming="False" ErrorMessage="Email is required" 
						meta:resourcekey="rfvEmail1Resource1" />
					<asp:RegularExpressionValidator ID="rxvEmail1" runat="server" 
						CssClass="resulterror" Display="Dynamic" EnableClientScript="false"
						ControlToValidate="txtEmail1" EnableTheming="False" ErrorMessage="Invalid Email" 
						meta:resourcekey="rxvEmail1Resource1" />
				    <asp:CustomValidator ID="cvEmail1" runat="server" ControlToValidate="txtEmail1" 
						EnableTheming="False" ClientValidationFunction="cvEmail_ClientValidate" 
						CssClass="resulterror" Display="Dynamic"
				        ErrorMessage="Emails are not equal" OnServerValidate="cvEmail1_ServerValidate" 
						meta:resourcekey="cvEmail1Resource1" />
				</td>
            </tr>
            <tr>
                <td><p style="text-align: right;"><asp:Literal ID="lblEmail2" runat="server" meta:resourcekey="lblEmail2Resource1" Text="Email (repeat)" />:</p></td>
                <td><asp:TextBox ID="txtEmail2" runat="server" Width="200px" meta:resourcekey="txtEmail2Resource1" ToolTip="Repeat your Email address" CausesValidation="True" />
                    <asp:RequiredFieldValidator ID="rfvEmail2" runat="server" EnableClientScript="false"
						ControlToValidate="txtEmail2" EnableTheming="False" CssClass="resulterror" Display="Dynamic"
					    ErrorMessage="Email is required" meta:resourcekey="rfvEmail2Resource1" />
					<asp:CustomValidator ID="cvEmail2" runat="server" ControlToValidate="txtEmail2" 
						CssClass="resulterror" Display="Dynamic"
						EnableTheming="False" ClientValidationFunction="cvEmail_ClientValidate"
					    ErrorMessage="Emails are not equal" OnServerValidate="cvEmail2_ServerValidate" 
						meta:resourcekey="cvEmail2Resource1" />
			    </td>
            </tr>
            <tr>
                <td><p style="text-align: right;"><asp:Literal ID="lblPassword1" runat="server" meta:resourcekey="lblPassword1Resource1" Text="Password" />:</p></td>
                <td><asp:TextBox ID="txtPassword1" runat="server" TextMode="Password" Width="200px" meta:resourcekey="txtPassword1Resource1" ToolTip="Type here your Password" CausesValidation="True" />
                    <asp:RequiredFieldValidator ID="rfvPassword1" runat="server" 
						CssClass="resulterror" Display="Dynamic"
						ControlToValidate="txtPassword1" EnableTheming="False"
					    ErrorMessage="Password is required" meta:resourcekey="rfvPassword1Resource1" />
					<asp:RegularExpressionValidator EnableClientScript="False" ID="rxvPassword1" 
						CssClass="resulterror" Display="Dynamic"
						runat="server" ControlToValidate="txtPassword1" EnableTheming="False" 
						ErrorMessage="Invalid Password" meta:resourcekey="rxvPassword1Resource1" />
					<asp:CustomValidator ID="cvPassword1" runat="server" CssClass="resulterror" Display="Dynamic"
						ControlToValidate="txtPassword1" EnableTheming="False" ClientValidationFunction="cvPassword_ClientValidate"
					    ErrorMessage="Passwords are not equal" OnServerValidate="cvPassword1_ServerValidate" 
						meta:resourcekey="cvPassword1Resource1" />
			    </td>
            </tr>
            <tr>
                <td><p style="text-align: right;"><asp:Literal ID="lblPassword2" runat="server" meta:resourcekey="lblPassword2Resource1" Text="Password (repeat)" />:</p></td>
                <td><asp:TextBox ID="txtPassword2" runat="server" TextMode="Password" Width="200px" meta:resourcekey="txtPassword2Resource1" ToolTip="Repeat your Password" CausesValidation="True" />
                    <asp:RequiredFieldValidator ID="rfvPassword2" runat="server" 
						CssClass="resulterror" Display="Dynamic"
						ControlToValidate="txtPassword2" EnableTheming="False" ErrorMessage="Password is required" 
						meta:resourcekey="rfvPassword2Resource1" />
					<asp:CustomValidator ID="cvPassword2" runat="server" CssClass="resulterror" Display="Dynamic"
						ControlToValidate="txtPassword2" EnableTheming="False" ClientValidationFunction="cvPassword_ClientValidate"
					    ErrorMessage="Passwords are not equal" OnServerValidate="cvPassword2_ServerValidate" 
						meta:resourcekey="cvPassword2Resource1" />
			    </td>
            </tr>
            <tr>
                <td style="vertical-align: top;"><p style="text-align: right;"><asp:Literal ID="lblCaptcha" runat="server" Text="Control Text (case sensitive)" meta:resourcekey="lblCaptchaResource1" />:</p></td>
                <td><st:Captcha ID="captcha" runat="server" /></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td><asp:Button ID="btnRegister" runat="server" Text="Create Account" OnClick="btnRegister_Click" meta:resourcekey="btnRegisterResource1" ToolTip="Click here to create your Account" /></td>
            </tr>
       </table>
   </asp:Panel>
     
</asp:Content>

