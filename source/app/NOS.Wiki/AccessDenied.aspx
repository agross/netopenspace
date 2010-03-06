<%@ Page Language="C#" MasterPageFile="~/MasterPageSA.master" AutoEventWireup="true" Inherits="ScrewTurn.Wiki.AccessDenied" Title="Untitled Page" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="AccessDenied.aspx.cs" %>

<asp:Content ID="CtnAccessDenied" ContentPlaceHolderID="CphMasterSA" Runat="Server">

    <h1 class="pagetitlesystem"><asp:Literal ID="lblTitle" runat="server" meta:resourcekey="lblTitleResource1" Text="Access Denied" EnableViewState="false" /></h1>
    <asp:Literal ID="lblDescription" runat="server" meta:resourcekey="lblDescriptionResource1" Text="You do not have access to this page." EnableViewState="false" />

</asp:Content>
