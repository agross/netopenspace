<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageSA.Master" AutoEventWireup="true" CodeBehind="User.aspx.cs" Inherits="ScrewTurn.Wiki.User" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" %>

<asp:Content ID="ctnUser" ContentPlaceHolderID="CphMasterSA" runat="server">

	<h1 class="pagetitlesystem"><asp:Literal ID="lblTitle" runat="server" Text="##NAME## - User's Details" meta:resourcekey="lblTitleResource1" /></h1>
	
	<div id="UserGravatarDiv">
		<asp:Literal ID="lblGravatar" runat="server" EnableViewState="False" meta:resourcekey="lblGravatarResource1" />
	</div>
	
	<asp:Literal ID="lblActivity" runat="server" Text="Recent activity by this user:" EnableViewState="False" meta:resourcekey="lblActivityResource1" />
	<br /><br />
	
	<asp:Literal ID="lblNoActivity" runat="server" Text="<i>No recent activity</i>" Visible="False" EnableViewState="False" meta:resourcekey="lblNoActivityResource1" />
	<asp:Literal ID="lblRecentActivity" runat="server" EnableViewState="False" meta:resourcekey="lblRecentActivityResource1" />
	
	<asp:Panel ID="pnlMessage" runat="server" meta:resourcekey="pnlMessageResource1">
		<div id="EmailMessageDiv">
			<h2 class="separator"><asp:Literal ID="lblMessageTitle" runat="server" Text="Send a Message" EnableViewState="False" meta:resourcekey="lblMessageTitleResource1" /></h2>
			<asp:Literal ID="lblMessageInfo" runat="server" Text="You can send an email message to this user. <b>Note</b>: your email address won't be disclosed." EnableViewState="False" meta:resourcekey="lblMessageInfoResource1" />
			<br /><br />
			
			<asp:Literal ID="lblSubject" runat="server" Text="Subject" EnableViewState="False" meta:resourcekey="lblSubjectResource1" /><br />
			<asp:TextBox ID="txtSubject" runat="server" CssClass="bigtextbox large" meta:resourcekey="txtSubjectResource1" /><br />
			<asp:TextBox ID="txtBody" runat="server" TextMode="MultiLine" CssClass="body" meta:resourcekey="txtBodyResource1" /><br />
			<asp:Button ID="btnSend" runat="server" Text="Send" OnClick="btnSend_Click" meta:resourcekey="btnSendResource1" />
			<asp:RequiredFieldValidator ID="rfvSubject" runat="server" Display="Dynamic" CssClass="resulterror" ControlToValidate="txtSubject"
				ErrorMessage="Subject is required" meta:resourcekey="rfvSubjectResource1" />
			<asp:RequiredFieldValidator ID="rfvBody" runat="server" Display="Dynamic" 
				CssClass="resulterror" ControlToValidate="txtBody" ErrorMessage="Body is required" meta:resourcekey="rfvBodyResource1" />
			<asp:Label ID="lblSendResult" runat="server" meta:resourcekey="lblSendResultResource1" />
		</div>
		
	</asp:Panel>

</asp:Content>
