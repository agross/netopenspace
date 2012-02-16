<%@ Page Language="C#" MasterPageFile="~/MasterPageSA.master" AutoEventWireup="true" Inherits="ScrewTurn.Wiki.Upload" Title="Untitled Page" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="Upload.aspx.cs" %>
<%@ Register TagPrefix="st" TagName="FileManager" Src="~/FileManager.ascx" %>

<asp:Content ID="CtnUpload" ContentPlaceHolderID="CphMasterSA" Runat="Server">
    
    <h1 class="pagetitlesystem"><asp:Literal ID="lblManagementTitle" runat="server" Text="File Management" meta:resourcekey="lblManagementTitleResource1" /></h1>
    <p><asp:Literal ID="lblInfo" runat="server" Text="Here you can manage files and directories stored in the Wiki." meta:resourcekey="lblInfoResource1" /></p>
    <br />

    <st:FileManager runat="server" ID="fileManager" />
    
    <iframe src="SessionRefresh.aspx" style="width: 1px; height: 1px; border: none;" scrolling="no"></iframe>

</asp:Content>
