<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ScrewTurn.Wiki.DefaultPage" culture="auto" meta:resourcekey="PageResource2" uiculture="auto" %>

<%@ Register TagPrefix="st" TagName="AttachmentViewer" Src="~/AttachmentViewer.ascx" %>

<asp:Content ID="ctnDefault" ContentPlaceHolderID="CphMaster" runat="server">

    <script type="text/javascript">
    <!--
        function __ShowAllTrail() {
            try {
                document.getElementById("BreadcrumbsDivMin").style["display"] = "none";
                document.getElementById("BreadcrumbsDivAll").style["display"] = "";
                __SetStatus("1");
            }
            catch(ex) { }
            return false;
        }
        function __HideTrail() {
            try {
                document.getElementById("BreadcrumbsDivMin").style["display"] = "";
                document.getElementById("BreadcrumbsDivAll").style["display"] = "none";
                __SetStatus("0");
            }
            catch(ex) { }
            return false;
        }
        
        function __SetStatus(open) {
            __CreateCookie("ScrewTurnWikiBCT", open, 365);
        }
        function __GetStatus() {
            var value = __ReadCookie("ScrewTurnWikiBCT");
            if(value) return value;
            else return "0";
        }

        function __InitBCT() {
        	if(__GetStatus() == "1") {
        		__ShowAllTrail();
        	}
        }

        var __attachmentsMenuJustShown = false;
        var __adminToolsMenuJustShown = false;
        var __ie7Mode = false;

        function __ToggleAttachmentsMenu(cx, cy) {
        	var element = document.getElementById("PageAttachmentsDiv");
        	if(element) {
        		if(element.style["display"] == "none") {
        			element.style["display"] = "";
        			var pos = __AbsolutePosition(element);
        			if(pos.left - cx > 0) {
        				__ie7Mode = true;
        				element.style["position"] = "absolute";
        				element.style["top"] = cy + "px";
        				element.style["left"] = (cx - pos.width) + "px";
        			}
        			else {
        				__RepositionDiv(document.getElementById("PageAttachmentsLink"), element);
        			}
        			__attachmentsMenuJustShown = true;
        		}
        	}
        	return false;
        }
        function __HideAttachmentsMenu() {
        	var element = document.getElementById("PageAttachmentsDiv");
        	if(element && !__attachmentsMenuJustShown) {
        		element.style["display"] = "none";
        		if (__ie7Mode) element.style["left"] = "10000px";
        	}
        	__attachmentsMenuJustShown = false;
        	return true; // Needed to enabled next clicks' action (file download)
        }

        function __ToggleAdminToolsMenu(cx, cy) {
        	var element = document.getElementById("AdminToolsDiv");
        	if(element) {
        		if(element.style["display"] == "none") {
        			element.style["display"] = "";
        			var pos = __AbsolutePosition(element);
        			if(pos.left - cx > 0) {
        				__ie7Mode = true;
        				element.style["position"] = "absolute";
        				element.style["top"] = cy + "px";
        				element.style["left"] = (cx - pos.width) + "px";
        			}
        			else {
        				__RepositionDiv(document.getElementById("AdminToolsLink"), element);
        			}
        			__adminToolsMenuJustShown = true;
        		}
        	}
        	return false;
        }
        function __HideAdminToolsMenu() {
        	var element = document.getElementById("AdminToolsDiv");
        	if(element && !__adminToolsMenuJustShown) {
        		element.style["display"] = "none";
        		if(__ie7Mode) element.style["left"] = "10000px";
        	}
        	__adminToolsMenuJustShown = false;
        	return true; // Needed to enable next clicks' action (admin tools)
        }

        function __HideAllMenus() {
        	__HideAttachmentsMenu();
        	__HideAdminToolsMenu();
        }

        document.body.onclick = __HideAllMenus;

        function __AbsolutePosition(obj) {
        	var pos = null;
        	if(obj != null) {
        		pos = new Object();
        		pos.top = obj.offsetTop;
        		pos.left = obj.offsetLeft;
        		pos.width = obj.offsetWidth;
        		pos.height = obj.offsetHeight;

        		obj = obj.offsetParent;
        		while(obj != null) {
        			pos.top += obj.offsetTop;
        			pos.left += obj.offsetLeft;
        			obj = obj.offsetParent;
        		}
        	}
        	return pos;
        }

        var __showTimer = null;
        var __hideTimer = null;

        function __ShowDropDown(e, divId, parent) {
           	// Set a timer
        	// On mouse out, cancel the timer and start a 2nd timer that hides the menu
        	// When the 1st timer elapses
        	//   show the drop-down
        	//   on menu mouseover, cancel the 2nd timer
        	//   on menu mouse out, hide the menu
        	__showTimer = setTimeout('__ShowDropDownForReal(' + e.clientX + ', ' + e.clientY + ', "' + divId + '", "' + parent.id + '");', 200);
        }

        function __ShowDropDownForReal(cx, cy, divId, parentId) {
        	var pos = __AbsolutePosition(document.getElementById(parentId));
        	var menu = document.getElementById(divId);

			// This is needed to trick IE7 which, for some reason,
			// does not position the drop-down correctly with the new Default theme
        	if(pos.left - cx > 30) {
        		menu.style["display"] = "";
        		menu.style["position"] = "absolute";
        		menu.style["top"] = cy + "px";
        		menu.style["left"] = (cx - 10) + "px";
        	}
        	else {
        		menu.style["display"] = "";
        		menu.style["position"] = "absolute";
        		menu.style["top"] = (pos.top + pos.height) + "px";
        		menu.style["left"] = pos.left + "px";
        	}
        	__showTimer = null;
        }

        function __HideDropDown(divId) {
        	if(__showTimer) clearTimeout(__showTimer);
        	__hideTimer = setTimeout('__HideDropDownForReal("' + divId + '");', 200);
        }

        function __HideDropDownForReal(divId) {
        	document.getElementById(divId).style["display"] = "none";
        	__hideTimer = null;
        }

        function __CancelHideTimer() {
        	if(__hideTimer) clearTimeout(__hideTimer);
        }
        
    // -->
    </script>

	<a id="PageTop"></a>
	
	<div id="PageHeaderDiv">
	
		<!-- Change this to PageToolbarDiv -->
		<div id="EditHistoryLinkDiv">
			<asp:Literal ID="lblDiscussLink" runat="server" EnableViewState="False" meta:resourcekey="lblDiscussLinkResource1" />
			<asp:Literal ID="lblEditLink" runat="server" EnableViewState="False" meta:resourcekey="lblEditLinkResource1" />
			<asp:Literal ID="lblViewCodeLink" runat="server" EnableViewState="False" meta:resourcekey="lblViewCodeLinkResource1" />
			<asp:Literal ID="lblHistoryLink" runat="server" EnableViewState="False" meta:resourcekey="lblHistoryLinkResource1" />
			<asp:Literal ID="lblAttachmentsLink" runat="server" EnableViewState="False" meta:resourcekey="lblAttachmentsLinkResource1" />
			<asp:Literal ID="lblAdminToolsLink" runat="server" EnableViewState="False" meta:resourcekey="lblAdminToolsLinkResource1" />
			
			<asp:Literal ID="lblPostMessageLink" runat="server" EnableViewState="False" meta:resourcekey="lblPostMessageLinkResource1" />
			<asp:Literal ID="lblBackLink" runat="server" EnableViewState="False" meta:resourcekey="lblBackLinkResource1" />
		</div>
		
		<h1 class="pagetitle">
			<asp:Literal ID="lblPreviousPage" runat="server" EnableViewState="False" meta:resourcekey="lblPreviousPageResource1" />
			<asp:Literal ID="lblPageTitle" runat="server" EnableViewState="False" meta:resourcekey="lblPageTitleResource1" />
			<asp:Literal ID="lblNextPage" runat="server" EnableViewState="False" meta:resourcekey="lblNextPageResource1" />
		</h1>
		
		<div id="PrintLinkDiv">
			<asp:Literal ID="lblPrintLink" runat="server" EnableViewState="False" meta:resourcekey="lblPrintLinkResource1" />
		</div>
		
		<div id="RssLinkDiv">
			<asp:Literal ID="lblRssLink" runat="server" EnableViewState="False" meta:resourcekey="lblRssLinkResource1" />
		</div>
		
		<div id="EmailNotificationDiv">
			<anthem:ImageButton ID="btnEmailNotification" runat="server" OnClick="btnEmailNotification_Click"
				AutoUpdateAfterCallBack="True" ImageUrl="~/Images/Blank.png" meta:resourcekey="btnEmailNotificationResource1" UpdateAfterCallBack="True" />
		</div>
		
		<asp:Panel ID="pnlPageInfo" runat="server" meta:resourcekey="pnlPageInfoResource1">
			<div id="PageInfoDiv">
				<span id="ModificationSpan">
					<asp:Literal ID="lblModified" runat="server" Text="Modified on " EnableViewState="False" meta:resourcekey="lblModifiedResource1" />
					<asp:Literal ID="lblModifiedDateTime" runat="server" EnableViewState="False" meta:resourcekey="lblModifiedDateTimeResource1" />
				</span>
				<span id="AuthorSpan">
					<asp:Literal ID="lblBy" runat="server" Text=" by " EnableViewState="False" meta:resourcekey="lblByResource1" />
					<asp:Literal ID="lblAuthor" runat="server" EnableViewState="False" meta:resourcekey="lblAuthorResource1" />
				</span>
				<span id="NavPathsSpan">
					<asp:Literal ID="lblNavigationPaths" runat="server" EnableViewState="False" meta:resourcekey="lblNavigationPathsResource1" />
				</span>
				<span id="CategoriesSpan">
					<asp:Literal ID="lblCategorizedAs" runat="server" Text="Categorized as " EnableViewState="False" meta:resourcekey="lblCategorizedAsResource1" />
					<asp:Literal ID="lblPageCategories" runat="server" EnableViewState="False" meta:resourcekey="lblPageCategoriesResource1" />
				</span>
				
				<span id="PageDiscussionSpan">
					<asp:Literal ID="lblPageDiscussionFor" runat="server" Text="Page discussion for " EnableViewState="False" meta:resourcekey="lblPageDiscussionForResource1" />
					<asp:Literal ID="lblDiscussedPage" runat="server" EnableViewState="False" meta:resourcekey="lblDiscussedPageResource1" />
				</span>
			</div>
		</asp:Panel>
		
		<asp:Literal ID="lblBreadcrumbsTrail" runat="server" EnableViewState="False" meta:resourcekey="lblBreadcrumbsTrailResource1" />
		
		<asp:Literal ID="lblRedirectionSource" runat="server" EnableViewState="False" meta:resourcekey="lblRedirectionSourceResource1" />
	
	</div>
	
	<div id="PageContentDiv">
		<asp:PlaceHolder ID="plhContent" runat="server" EnableViewState="False" />
	</div>
	
	<asp:Literal ID="lblDoubleClickHandler" runat="server" EnableViewState="False" meta:resourcekey="lblDoubleClickHandlerResource1" />
	
	<div id="PageAttachmentsDiv" style="position: absolute; left: 10000px;">
		<st:AttachmentViewer ID="attachmentViewer" runat="server" />
    </div>
    
    <div id="AdminToolsDiv" style="position: absolute; left: 10000px;">
		<asp:Literal ID="lblRollbackPage" runat="server" EnableViewState="False" meta:resourcekey="lblRollbackPageResource1" />
		<asp:Literal ID="lblAdministratePage" runat="server" EnableViewState="False" meta:resourcekey="lblAdministratePageResource1" />
		<asp:Literal ID="lblSetPagePermissions" runat="server" EnableViewState="False" meta:resourcekey="lblSetPagePermissionsResource1" />
    </div>
    
    <script type="text/javascript">
    <!--
    	function __RepositionDiv(link, element) {
    		var absPos = __AbsolutePosition(link);
    		var elemAbsPos = __AbsolutePosition(element);

    		element.style["top"] = (absPos.top + absPos.height) + "px";
    		element.style["left"] = (absPos.left - (elemAbsPos.width - absPos.width)) + "px";
    		element.style["position"] = "absolute";
    	}

		// Hide attachments and admin tools divs
    	// This is needed because __RepositionDiv cannot calculate the width of the element when it's hidden
    	var __elem = document.getElementById("PageAttachmentsDiv");
    	if(document.getElementById("PageAttachmentsLink")) {
    		__RepositionDiv(document.getElementById("PageAttachmentsLink"), __elem);
    	}
    	__elem.style["display"] = "none";

    	__elem = document.getElementById("AdminToolsDiv");
    	if(document.getElementById("AdminToolsLink")) {
    		__RepositionDiv(document.getElementById("AdminToolsLink"), __elem);
    	}
    	__elem.style["display"] = "none";

    	__InitBCT();
    // -->
    </script>

</asp:Content>
