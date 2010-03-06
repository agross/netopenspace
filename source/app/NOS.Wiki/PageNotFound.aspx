<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="ScrewTurn.Wiki.PageNotFound" Title="Untitled Page" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="PageNotFound.aspx.cs" %>

<asp:Content ID="ctnNotFound" ContentPlaceHolderID="CphMaster" Runat="Server">
    <h1 class="pagetitlesystem"><asp:Literal ID="lblTitle" runat="server" Text="Page Not Found" meta:resourcekey="lblTitleResource1" /></h1>
    <p><asp:Literal ID="lblDescription" runat="server" Text='The Page "##PAGENAME##" was not found.' meta:resourcekey="lblDescriptionResource1" /></p> 
    <br />
    
    <asp:Literal ID="lblSearchResults" runat="server" />
</asp:Content>
