<%@ Page Language="C#" MasterPageFile="~/MasterPageSA.master" AutoEventWireup="true" Inherits="ScrewTurn.Wiki.Operation" Title="Untitled Page" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="Operation.aspx.cs" %>

<asp:Content ID="ctnOperation" ContentPlaceHolderID="CphMasterSA" Runat="Server">

    <asp:MultiView ID="mlwOperation" runat="server">
    
        <asp:View ID="viwDeleteMessage" runat="server">
            <h1 class="pagetitlesystem"><asp:Literal ID="lblDeleteMessage" runat="server" Text="Delete Message" meta:resourcekey="lblDeleteMessageResource1" /></h1>
            
            <p>
                <asp:Literal ID="lblDeleteMessageDescription" runat="server" Text="To delete the selected message, click on the Delete button." meta:resourcekey="lblDeleteMessageDescriptionResource1" />
            </p>
            <br />
            <div class="box">
                <asp:Literal ID="lblDeleteMessageContent" runat="server" meta:resourcekey="lblDeleteMessageContentResource1" />
            </div>
            <br />
            
            <asp:CheckBox ID="chkDeleteMessageReplies" runat="server" Text="Delete Message's replies" meta:resourcekey="chkDeleteMessageRepliesResource1" /><br /><br />
            <asp:Button ID="btnDeleteMessage" runat="server" Text="Delete" style="font-weight: bold;" OnClick="btnDeleteMessage_Click" meta:resourcekey="btnDeleteMessageResource1" />
            <asp:Button ID="btnCancelDeleteMessage" runat="server" Text="Cancel" OnClick="btnCancelDeleteMessage_Click" meta:resourcekey="btnCancelDeleteMessageResource1" />
        </asp:View>
        
    </asp:MultiView>

</asp:Content>
