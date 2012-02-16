<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="ScrewTurn.Wiki.NavPath" Title="Untitled Page" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="NavPath.aspx.cs" %>

<asp:Content ID="ctnNavPath" ContentPlaceHolderID="CphMaster" Runat="Server">

    <h1 class="pagetitlesystem"><asp:Literal ID="lblNavPath" runat="server" Text="Navigation Paths" meta:resourcekey="lblNavPathResource1" /></h1>
    <p><asp:Literal ID="lblDescription" runat="server" Text="Navigation Paths guide you through the contents of the Wiki." meta:resourcekey="lblDescriptionResource1" /></p>
    <br />
   
    <p><asp:Literal ID="lblInfo" runat="server" Text="Here you can start to browse a Path." meta:resourcekey="lblInfoResource1" /></p>
    <br />
    
    <asp:Literal ID="lblNavPathList" runat="server" />

</asp:Content>
