<%@ Page ValidateRequest="false" Async="true" AsyncTimeout="180" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="ScrewTurn.Wiki.Import" Title="Untitled Page" Codebehind="Import.aspx.cs" %>

<asp:Content ID="ctnImport" ContentPlaceHolderID="CphMaster" Runat="Server">

    <h1 class="pagetitlesystem"><asp:Literal ID="lblImport" runat="server" Text="Import" /></h1>
    <p><asp:Literal ID="lblImportDescription" runat="server" Text="Import Pages from other Wiki engines." /></p>
    <div style="float: right; border: solid 1px #CCCCCC; padding: 6px;">
        <p>Proxy address/port</p>
        <asp:TextBox ID="txtProxyAddress" runat="server" Width="150px" />
        <asp:TextBox ID="txtProxyPort" runat="server" Width="40px" />
    </div>
    <br />
   
    <table style="width: 98%;" cellpadding="0" cellspacing="0">
        <tr>
            <td style="width: 350px;">
                <p><asp:Literal ID="lblOperationDescription" runat="server" Text="What do you want to import?" /></p>
                <asp:RadioButtonList ID="lstOperation" runat="server" AutoPostBack="True" OnSelectedIndexChanged="lstOperation_SelectedIndexChanged"> 
                    <asp:ListItem Value="PAGE">Import a single Page</asp:ListItem>
                    <asp:ListItem Value="WIKI">Import a whole Wiki</asp:ListItem>
                    <asp:ListItem Value="TEXT">Import a block of Text</asp:ListItem> 
                </asp:RadioButtonList>
                <br />
                <p><asp:Literal ID="lblWikiDescription" runat="server" Text="What Wiki engine do you want to import from?"></asp:Literal></p>
                <asp:RadioButtonList ID="lstWiki" runat="server" AutoPostBack="True" OnSelectedIndexChanged="lstWiki_SelectedIndexChanged" > 
                    <asp:ListItem Value="MEDIA">MediaWiki</asp:ListItem>
                    <asp:ListItem Value="FLEX">FlexWiki</asp:ListItem>
                </asp:RadioButtonList>
            </td>
            <td valign="bottom">
                
            </td>
        </tr> 
    </table>
    <br /><br />
    
    <asp:MultiView ID="mlwImport" runat="server">
        <asp:View ID="viwPage" runat="server">
            <h3 class="separator"><asp:Literal ID="lblPage" runat="server" Text="Import Page"></asp:Literal></h3>
            <br />
            <p><asp:Literal ID="lblPageUrl" runat="server" Text=""></asp:Literal></p>
            <asp:TextBox ID="txtPageUrl" runat="server" Width="300px"></asp:TextBox>
            <p><asp:Literal ID="lblPageName" runat="server" Text="Page Name"></asp:Literal></p>
            <asp:TextBox ID="txtPageName" runat="server" Width="300px"></asp:TextBox>
            <asp:Button ID="btnGoWiki" runat="server" Text="Go" style="font-weight: bold;" OnClick="btnGo_click" />
            <br />
            <span id="ResultSpan"><asp:Literal ID="lblResult" runat="server" meta:resourcekey="lblResultResource1" Text="You will be redirected to the new page; not supported formatting tags will appear in red" ></asp:Literal></span>
        </asp:View>
        
        <asp:View ID="viwWiki" runat="server">
            <h3 class="separator"><asp:Literal ID="lblWiki" runat="server" Text="Import whole Wiki"></asp:Literal></h3>
            <br />
            <p><asp:Literal ID="lblWikiUrl" runat="server" Text="Wiki URL"></asp:Literal></p>
            <asp:TextBox ID="txtWikiUrl" runat="server" Width="300px"></asp:TextBox>
            <asp:Button ID="btnGoPage" runat="server" Text="Go" style="font-weight: bold;" OnClick="btnGo_click" />
            <br />
            <p><asp:Label ID="lblPageList" Text="" runat="server"></asp:Label></p>
            <div style="width: 98%; height: 300px; border: solid 1px #CCCCCC; overflow: scroll; padding: 6px;" ID="pageList_div" runat="server">
                <asp:CheckBoxList ID="pageList" runat="server"></asp:CheckBoxList>
            </div>
            <asp:Button ID="btnTranslateAll" runat="server" Text="Translate" OnClick="btnTranslateAll_click" />
        </asp:View>
        
        <asp:View ID="viwText" runat="server">
            <h3 class="separator"><asp:Literal ID="lblText" runat="server" Text="Import block of Text"></asp:Literal></h3>
            <br />
            <asp:TextBox ID="txtText" runat="server" Height="400px" TextMode="MultiLine" Width="98%"></asp:TextBox>
            <asp:Button ID="Button1" runat="server" Text="Translate" style="font-weight: bold;" OnClick="btnGo_click" />
        </asp:View>
        
        <asp:View ID="viewTranslated" runat="server">
            <h3 class="separator"><asp:Literal ID="lblTranslated" runat="server" Text="Block of Text translated"></asp:Literal></h3>
            <br />
            <asp:TextBox ID="txtTranslated" runat="server" Height="400px" TextMode="MultiLine" Width="98%"></asp:TextBox>
        </asp:View>
    </asp:MultiView>

</asp:Content>
