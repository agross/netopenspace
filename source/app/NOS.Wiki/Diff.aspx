<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="ScrewTurn.Wiki.Diff" Title="Untitled Page" Codebehind="Diff.aspx.cs" %>

<asp:Content ID="ctnDiff" ContentPlaceHolderID="CphMaster" Runat="Server">

	<h1 class="pagetitlesystem">
		<asp:Literal ID="lblBack" runat="server" EnableViewState="false" /> -
		<asp:Literal ID="lblTitle" runat="server" EnableViewState="false" />
	</h1>
	<br />
	
    <asp:Literal ID="lblDiff" runat="server" EnableViewState="false" />

</asp:Content>
