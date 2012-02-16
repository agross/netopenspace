<%@ Page Language="C#" AutoEventWireup="true" Inherits="ScrewTurn.Wiki.Print" Codebehind="Print.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html dir="<%= ScrewTurn.Wiki.Settings.Direction %>" xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title runat="server">Print</title>
    <link rel="stylesheet" type="text/css" href="Themes/Print.css" /> 
</head>
<body>
    <form id="frmPrint" runat="server">
        <asp:Literal ID="lblContent" runat="server"></asp:Literal>
    </form>
</body>
</html>
