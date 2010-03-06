<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="ScrewTurn.Wiki.Category" Title="Untitled Page" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="Category.aspx.cs" %>

<asp:Content ID="ctnCategory" ContentPlaceHolderID="CphMaster" Runat="Server">

    <h1 class="pagetitlesystem"><asp:Literal ID="lblCategories" runat="server" Text="Page Categories" meta:resourcekey="lblCategoriesResource1" /></h1>
    <p><asp:Literal ID="lblDescription" runat="server" Text="The complete list of Page Categories of this Namespace." meta:resourcekey="lblDescriptionResource1" /></p> 
    <br />

    <asp:Literal ID="lblCatList" runat="server" meta:resourcekey="lblCatListResource1" />
</asp:Content>
