<%@ Control Language="C#" AutoEventWireup="true" Inherits="ScrewTurn.Wiki.ClientImageBrowser" Codebehind="ClientImageBrowser.ascx.cs" %>

<asp:Literal ID="lblStrings" runat="server" />

<script type="text/javascript">
<!--
	//var CurrentDivId = ""; // Probably needs to be set on server-side
	
	function DisplayDiv(divId) {
		var div = document.getElementById(divId);
		var current = document.getElementById(CurrentDivId);
		if(current) current.style["display"] = "none";
		div.style["display"] = "";
		CurrentDivId = divId;
		return false;
	}
// -->
</script>

<asp:Literal ID="lblContent" runat="server" EnableViewState="false" />
