<%@ Page Language="C#" MasterPageFile="~/MasterPageSA.master" AutoEventWireup="true" Inherits="ScrewTurn.Wiki.Language" Title="Untitled Page" Codebehind="Language.aspx.cs" %>

<%@ Register TagPrefix="st" TagName="LanguageSelector" Src="~/LanguageSelector.ascx" %>

<asp:Content ID="ctnLanguage" ContentPlaceHolderID="CphMasterSA" Runat="Server">
    
    <h1 class="pagetitlesystem">Language/Time Zone Selection</h1>
    <p>Please select your preferred language and time zone.<br />
    <b>Note</b>: you must enable cookies to use the language and time zone selection features.<br />
    This page is in English to allow everyone to change the language.</p>
    <br /> 
    
    <st:LanguageSelector ID="languageSelector" runat="server" />
    
    <asp:Button ID="btnSet" runat="server" Text="Set" OnClick="btnSet_Click" />
    
</asp:Content>
