<%@ Control Language="C#" AutoEventWireup="true" Inherits="ScrewTurn.Wiki.Captcha" Codebehind="Captcha.ascx.cs" %>

<div class="globalcaptcha">
	<asp:Image ID="imgCaptcha" runat="server" AlternateText="CAPTCHA" ImageUrl="Captcha.aspx" /><br />
	<asp:TextBox ID="txtCaptcha" runat="server" ToolTip="Copy here the text displayed above (case sensitive)" ValidationGroup="captcha" meta:resourcekey="txtCaptchaResource1" />
	<asp:RequiredFieldValidator ID="rfvCaptcha" runat="server" ControlToValidate="txtCaptcha" EnableTheming="False" ValidationGroup="captcha"
		ErrorMessage="ScrewTurn.Wiki.Properties.Messages.RequiredField" meta:resourcekey="rfvCaptchaResource1"><img src="Images/InputError.png" alt="*" /></asp:RequiredFieldValidator>
	<asp:CustomValidator ID="cvCaptcha" runat="server" ControlToValidate="txtCaptcha" EnableTheming="False" ValidationGroup="captcha"
		ErrorMessage="ScrewTurn.Wiki.Properties.Messages.WrongControlText"	OnServerValidate="cvCaptcha_ServerValidate" EnableClientScript="False" meta:resourcekey="cvCaptchaResource1"><img src="Images/InputError.png" alt="*" /></asp:CustomValidator>
</div>