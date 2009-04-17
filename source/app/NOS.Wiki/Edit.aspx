<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Edit.aspx.cs" Inherits="ScrewTurn.Wiki.Edit" MasterPageFile="~/MasterPage.master" ValidateRequest="false" MaintainScrollPositionOnPostback="true" %>
<%@ Register TagPrefix="st" TagName="JsFileTree" Src="~/JsFileTree.ascx" %>
<%@ Register TagPrefix="st" TagName="JsImageBrowser" Src="~/JsImageBrowser.ascx" %>
<%@ Register TagPrefix="st" TagName="Captcha" Src="~/Captcha.ascx" %>

<asp:Content runat="server" ID="CtnEdit" ContentPlaceHolderID="CphMaster">

    <asp:Literal ID="lblStrings" runat="server" meta:resourcekey="lblStringsResource1" />
   
    <script type="text/javascript">
    <!-- 
        var __XmlHttp = false;
        /*@cc_on @*/
        /*@if (@_jscript_version >= 5)
        // JScript gives us Conditional compilation, we can cope with old IE versions.
        // and security blocked creation of the objects.
        try {
        __XmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
        }
        catch(e1) {
	        try {
		        __XmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
	        }
	        catch(e2) {
		        __XmlHttp = false;
	        }
        }
        @end @*/
        if(!__XmlHttp && typeof XMLHttpRequest != 'undefined') {
	        try {
		        __XmlHttp = new XMLHttpRequest();
	        }
	        catch(e) {
		        __XmlHttp = false;
	        }
        }
        if(!__XmlHttp && window.createRequest) {
	        try {
	        	__XmlHttp = window.createRequest();
	        }
	        catch(e) {
		        __XmlHttp = false;
	        }
        }

        function __HidePreview() {
            document.getElementById("PreviewDivExternal").style["display"] = "none";
        }
		
		function getMozSelection() {
			return document.getSelection();
		}

		// IE only - stores the current cursor position on any textarea activity
		function storeCaret (txtarea) {
			if(txtarea.createTextRange) {
				txtarea.caretPos = document.selection.createRange().duplicate();
			}
		}

		// IE only - wraps selected text with lft and rgt
		function WrapIE(lft, rgt) {
			strSelection = document.selection.createRange().text;
			if(strSelection != "") {
				document.selection.createRange().text = lft + strSelection + rgt;
			}
		}

		// Moz only - wraps selected text with lft and rgt
		function wrapMoz(txtarea, lft, rgt) {
			var selLength = txtarea.textLength;
			var selStart = txtarea.selectionStart;
			var selEnd = txtarea.selectionEnd;
			if(selEnd == 1 || selEnd == 2) selEnd = selLength;
			var s1 = (txtarea.value).substring(0, selStart);
			var s2 = (txtarea.value).substring(selStart, selEnd)
			var s3 = (txtarea.value).substring(selEnd, selLength);
			txtarea.value = s1 + lft + s2 + rgt + s3;
		}
 
		// Chooses technique based on browser
		function wrapTag(txtarea, lft, rgt) {
			lft = unescape(lft);
			rgt = unescape(rgt);
			if(document.all) {
				WrapIE(lft, rgt);
			}
			else if (document.getElementById) {
				wrapMoz(txtarea, lft, rgt);
			}
		}

		// IE only - Insert text at caret position or at start of selected text
		function insertIE (txtarea, text) {
			if(txtarea.createTextRange && txtarea.caretPos) {
				var caretPos = txtarea.caretPos;
				caretPos.text = caretPos.text.charAt(caretPos.text.length - 1) == ' ' ? text+caretPos.text + ' ' : text+caretPos.text;
			}
			else {
				txtarea.value = txtarea.value + text;
			}
			return false;
		}

		// Moz only - Insert text at caret position or at start of selected text
		function insertMoz(txtarea , lft) {
			var rgt = "";
			wrapTag(txtarea, lft, rgt);
			return false;
		}

		// Switch function based on browser - Insert text at caret position or at start of selected text
		function insertTag(txtarea , lft) {
			if(document.all) {
				insertIE(txtarea, lft);
			}
			else if (document.getElementById) {
				insertMoz(txtarea, lft);
			}
		}
       
		function __Insert(strInsertText) {
			var objTextArea = __GetServerElementById("txtContent");
			insertTag(__GetServerElementById("txtContent"), strInsertText);
			document.getElementById("SpecialTagsDiv").style["display"] = "none";
			return false;
		}
        
        function __Wrap(strStartTag, strEndTag) {
            while(strStartTag.indexOf("$") != -1) {
                // The symbol '$' is used to replace double quotes inside javascript links
                strStartTag = strStartTag.replace("$", "\"");
            }
	        var objTextArea = __GetServerElementById("txtContent");
	        if(objTextArea) {
		        if(document.selection && document.selection.createRange) {
			        objTextArea.focus();
			        var objSelectedTextRange = document.selection.createRange();
			        var strSelectedText = objSelectedTextRange.text;
			        if(strSelectedText.substring(0, strStartTag.length) == strStartTag && strSelectedText.substring(strSelectedText.length - strEndTag.length, strSelectedText.length) == strEndTag) {
			            objSelectedTextRange.text = strSelectedText.substring(strStartTag.length, strSelectedText.length - strEndTag.length);
			        }
			        else {
			            objSelectedTextRange.text = strStartTag + strSelectedText + strEndTag;
			        }
			        objSelectedTextRange.select();
		        }
		        else {
		            objTextArea.focus(); 
		            var selStart = objTextArea.selectionStart;
					var strFirst = objTextArea.value.substring(0, objTextArea.selectionStart);
					var strSelected = objTextArea.value.substring(objTextArea.selectionStart, objTextArea.selectionEnd);
					var strSecond = objTextArea.value.substring(objTextArea.selectionEnd);
					if(strSelected.substring(0, strStartTag.length) == strStartTag && strSelected.substring(strSelected.length - strEndTag.length, strSelected.length) == strEndTag) {
					    // Remove tags
					    strSelected = strSelected.substring(strStartTag.length, strSelected.length - strEndTag.length);
					    objTextArea.value = strFirst + strSelected + strSecond;
					    objTextArea.selectionStart = selStart;
					    objTextArea.selectionEnd = selStart + strSelected.length;
					}
					else {
					    objTextArea.value = strFirst + strStartTag + strSelected + strEndTag + strSecond;
					    objTextArea.selectionStart = selStart;
					    objTextArea.selectionEnd = selStart + strStartTag.length + strSelected.length + strEndTag.length;
					}
		        }
	        }
	        document.getElementById("SpecialTagsDiv").style["display"] = "none";
	        return false;
        }
        
        function __BuildLink() {
            var strTitle = window.prompt(__StringLinkTitle);
            if(strTitle == null) return false;
            var strUrl = window.prompt(__StringLinkUrl, "http://");
            if(strUrl == null) return false;
            __Insert("[" + strUrl + "|" + strTitle + "]");
            return false;
        }
        
        function __BuildAnchor() {
            var strId = window.prompt(__StringAnchorId, "#");
            if(strId == null) return;
            if(strId.substring(0, 1) != "#") strId = "#" + strId;
            return __Insert("[anchor|" + strId + "]");
        }
        function __BuildAnchorLink() {
            var strTitle = window.prompt(__StringAnchorTitle);
            if(strTitle == null) return false;
            var strId = window.prompt(__StringAnchorId, "#");
            if(strId == null) return false;
            if(strId.substring(0, 1) != "#") strId = "#" + strId;
            __Insert("[" + strId + "|" + strTitle + "]");
            return false;
        }
        
        function __BuildImage(align) {
            var strTitle = window.prompt(__StringImageTitle);
            if(strTitle == null) return false;
            var strUrl = window.prompt(__StringImageUrl, "http://");
            if(strUrl == null) return false;
            var strBigUrl = window.prompt(__StringImageBigUrl, "http://");
            if(strBigUrl == "http://" || strBigUrl == "") strBigUrl = null;
            var strResult = "[image" + align + "|" + strTitle + "|" + strUrl;
            if(strBigUrl != null) strResult = strResult + "|" + strBigUrl;
            strResult = strResult + "]";
            __Insert(strResult);
            return false;
        }
        
        function __AbsolutePosition(obj) {
            var pos = null; 
            if(obj != null) {
                pos = new Object();
                pos.top = obj.offsetTop;
                pos.left = obj.offsetLeft;
                pos.width = obj.offsetWidth;
                pos.height= obj.offsetHeight;
          
                /*
				This breaks positioning popups with relative elements (in DOM order) above the popup.
				obj = obj.offsetParent;
                while(obj != null) {
                    pos.top += obj.offsetTop;
                    pos.left += obj.offsetLeft;
                    obj = obj.offsetParent;
                }*/
            }
            return(pos);
        }
        
        function __ToggleItem(link, div) {
            var objLink = document.getElementById(link);
            var objDiv = document.getElementById(div);
            if(objDiv.style["display"] == "none") {
                __HideMenus();
                var pos = __AbsolutePosition(objLink);
                var top = pos.top + pos.height;
                var left = pos.left;
			    objDiv.style["position"] = "absolute";
			    objDiv.style["top"] = top + "px";
			    objDiv.style["left"] = left + "px";
                objDiv.style["display"] = "";
            }
            else {
                objDiv.style["display"] = "none";
            }
            return false;
        }
        
        function __ToggleSpecialTags() {
            __ToggleItem("SpecialTagsLink", "SpecialTagsDiv");
            return false;
        }
        
        function __ToggleAnchors() {
            __ToggleItem("AnchorLink", "AnchorsDiv");
            return false;
        }
        
        function __ToggleImages() {
            __ShowImageDialog();
            return false;
            __ToggleItem("ImageLink", "ImagesDiv");
            return false;
        }
        
        function __TogglePageList() {
			document.getElementById("TxtSearchPage").value = "";
			__FilterPages();
            __ToggleItem("PageListLink", "PageListDiv");
            try {
				document.getElementById("TxtSearchPage").focus();
            }
            catch(ex) { }
            return false;
        }
        
        function __ToggleSnippetList() {
            __ToggleItem("SnippetListLink", "SnippetListDiv");
            return false;
        }
        
        function __ToggleFileList() {
            __ToggleItem("FileLink", "FileListDiv");
            return false;
        }
        
        var toggled = "";
        
        function __LinkPage(pg) {
            if(toggled == "1") {
                document.getElementById("ImageLinkInput").value = pg;
            }
            else {
                var title = window.prompt(__StringLinkTitle, "");
                if(title == null) return false;
                if(title != "") __Insert("[" + pg + "|" + title + "]");
                else __Insert("[" + pg + "]");
            }
            __TogglePageList();
            return false;
        }
        
        function __LinkFile(file) {
            if(toggled == "1") {
                document.getElementById("ImageLinkInput").value = file;
            }
            else {
                if(document.getElementById("AttachmentChk").checked) {
                    __Insert("[attachment:" + file + "]");
                    __ToggleFileList();
                    return false;
                }
                var title = window.prompt(__StringLinkTitle, "");
                if(title == null) return false;
                if(title != "") __Insert("[{UP}" + file + "|" + title + "]");
                else __Insert("[{UP}" + file + "]");
            }
            __ToggleFileList();
            return false;
        }
        
        function getPageScroll(){

	        var yScroll;

	        if (self.pageYOffset) {
		        yScroll = self.pageYOffset;
	        } else if (document.documentElement && document.documentElement.scrollTop){	 // Explorer 6 Strict
		        yScroll = document.documentElement.scrollTop;
	        } else if (document.body) {// all other Explorers
		        yScroll = document.body.scrollTop;
	        }

	        arrayPageScroll = new Array('',yScroll) 
	        return arrayPageScroll;
        }

        function getPageSize(){
        	
	        var xScroll, yScroll;
        	
	        if (window.innerHeight && window.scrollMaxY) {	
		        xScroll = document.body.scrollWidth;
		        yScroll = window.innerHeight + window.scrollMaxY;
	        } else if (document.body.scrollHeight > document.body.offsetHeight){ // all but Explorer Mac
		        xScroll = document.body.scrollWidth;
		        yScroll = document.body.scrollHeight;
	        } else { // Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari
		        xScroll = document.body.offsetWidth;
		        yScroll = document.body.offsetHeight;
	        }
        	
	        var windowWidth, windowHeight;
	        if (self.innerHeight) {	// All except Explorer
		        windowWidth = self.innerWidth;
		        windowHeight = self.innerHeight;
	        } else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode
		        windowWidth = document.documentElement.clientWidth;
		        windowHeight = document.documentElement.clientHeight;
	        } else if (document.body) { // other Explorers
		        windowWidth = document.body.clientWidth;
		        windowHeight = document.body.clientHeight;
	        }	
        	
	        // For small pages with total height less then height of the viewport
	        if(yScroll < windowHeight){
		        pageHeight = windowHeight;
	        } else { 
		        pageHeight = yScroll;
	        }

	        // For small pages with total width less then width of the viewport
	        if(xScroll < windowWidth){	
		        pageWidth = windowWidth;
	        } else {
		        pageWidth = xScroll;
	        }

	        arrayPageSize = new Array(pageWidth,pageHeight,windowWidth,windowHeight) 
	        return arrayPageSize;
        }
        
        function __ShowImageDialog() {
            __DisplayJsBrowserContent();
            __CenterAndShow(document.getElementById("ImageDialogDiv"));
            __ShowBG();
            toggled = "1";
            document.getElementById("ImageTitleInput").focus();
            document.getElementById("AttachmentChk").disabled = true;
            return false;
        }
        
        function __HideImageDialog() {
            var diag = document.getElementById("ImageDialogDiv");
            diag.style["display"] = "none";
            __HideBG();
            toggled = "";
            document.getElementById("AttachmentChk").disabled = false;
            return false;
        }
        
        function __ShowBG() {
            var bg = document.getElementById("BackgroundDiv");
            bg.style["position"] = "absolute";
            bg.style["left"] = "0px";
            bg.style["top"] = "0px";
            bg.style["height"] = getPageSize()[1] + "px";
            bg.style["display"] = "";
        }
        
        function __HideBG() {
            var bg = document.getElementById("BackgroundDiv");
            bg.style["display"] = "none";
        }
        
        function __CenterAndShow(div) {
            var pScroll = getPageScroll();
            var pSize = getPageSize();
            div.style["left"] = ((pScroll[0] + (pSize[2] - 618) / 2)) + "px";
            div.style["top"] = ((pScroll[1] + (pSize[3] - 360) / 2)) + "px";
            div.style["display"] = "";
        }
        
        var current = "txtImageUrl";
        
        function __ShowAndSelectInput(sel) {
            current = sel;
            document.getElementById("ImageBrowserDiv").style["display"] = "";
            document.getElementById("BrowserControlsDiv").style["display"] = "";
            document.getElementById("InputControlsDiv").style["display"] = "none";
            return false;
        }
        
        function __SelectImage(val) {
            document.getElementById(current).value = val;
            return false;
        }
        
        function __Hide(cancel) {
            document.getElementById("ImageBrowserDiv").style["display"] = "none";
            document.getElementById("BrowserControlsDiv").style["display"] = "none";
            document.getElementById("InputControlsDiv").style["display"] = "";
            if(cancel) document.getElementById(current).value = "";
            return false;
        }
        
        function __Done(cancel) {
            if(cancel) {
                document.getElementById("ImageTitleInput").value = "";
                document.getElementById("ImageUrlInput").value = "";
                document.getElementById("ImageLinkInput").value = "";
                __HideImageDialog();
                return false;
            }
            var title = document.getElementById("ImageTitleInput").value;
            var url = document.getElementById("ImageUrlInput").value;
            var link = document.getElementById("ImageLinkInput").value;
            var imageType = "image";
            if(document.getElementById("RightImageRadio").checked) imageType = "imageright";
            if(document.getElementById("LeftImageRadio").checked) imageType = "imageleft";
            if(document.getElementById("AutoImageRadio").checked) imageType = "imageauto";
            if(document.getElementById("InlineImageRadio").checked) imageType = "image";
            if(url.length == 0) {
                window.alert(__EnterTitleAndUrl);
                return false;
            }
            if(link.length > 0) {
                __Insert("[" + imageType + "|" + title + "|" + url + "|" + link + "]");
            }
            else __Insert("[" + imageType + "|" + title + "|" + url + "]");
            document.getElementById("ImageTitleInput").value = "";
            document.getElementById("ImageUrlInput").value = "";
            document.getElementById("ImageLinkInput").value = "";
            __HideImageDialog();
            return false;
        }
        
        function __TogglePageListForImage() {
            document.getElementById("TxtSearchPage").value = "";
			__FilterPages();
            __ToggleItem("PickPageLink", "PageListDiv");
            try {
				document.getElementById("TxtSearchPage").focus();
            }
            catch(ex) { }
            return false;
        }
        
        function __ToggleFileListForImage() {
            __ToggleItem("PickFileLink", "FileListDiv");
            return false;
        }
    // -->
    </script>
    
    <div id="BackgroundDiv" style="display: none; width: 100%; background-color: #CCCCCC; opacity: 0.5; filter: alpha(opacity=50); -moz-opacity: 0.50; z-index: 500;"></div>
    <div id="ImageDialogDiv" style="position: absolute; left: 0px; top: 0px; display: none; padding: 4px; width: 618px; height: 360px; background-color: #FFFFFF; border: solid 1px #000000; z-index: 1000;">
        <h3 class="separator"><asp:Literal ID="lblInsertImage" runat="server" Text="Insert an Image" meta:resourcekey="lblInsertImageResource1" /></h3>
        <div id="InputControlsDiv">
            <asp:Literal ID="lblImageAlignment" runat="server" Text="Image Alignment" meta:resourcekey="lblImageAlignmentResource1" /><br />
            <input type="radio" id="RightImageRadio" name="Alignment" checked="checked" /><label for="RightImageRadio"><asp:Literal ID="lblRightImage" runat="server" Text="Right" meta:resourcekey="lblRightImageResource1" /></label>
            <input type="radio" id="LeftImageRadio" name="Alignment" /><label for="LeftImageRadio"><asp:Literal ID="lblLeftImage" runat="server" Text="Left" meta:resourcekey="lblLeftImageResource1" /></label>
            <input type="radio" id="AutoImageRadio" name="Alignment" /><label for="AutoImageRadio"><asp:Literal ID="lblAutoImage" runat="server" Text="Auto" meta:resourcekey="lblAutoImageResource1" /></label>
            <input type="radio" id="InlineImageRadio" name="Alignment" /><label for="InlineImageRadio"><asp:Literal ID="lblInlineImage" runat="server" Text="Inline" meta:resourcekey="lblInlineImageResource1" /></label>
            <br /><br />
            <asp:Literal ID="lblImageTitle" runat="server" Text="Image Title" meta:resourcekey="lblImageTitleResource1" /><br /><input type="text" id="ImageTitleInput" style="width: 300px;" />
            <br /><br />
            <asp:Literal ID="lblImageUrl" runat="server" Text="Image URL" meta:resourcekey="lblImageUrlResource1" /><br /><input type="text" id="ImageUrlInput" style="width: 300px;" />
                <small>
                    <a href="#" onclick="javascript:return __ShowAndSelectInput('ImageUrlInput');"><asp:Literal ID="lblBrowse1" runat="server" Text="Browse" meta:resourcekey="lblBrowse1Resource1" /></a>
                </small>
            <br /><br />
            <asp:Literal ID="lblImageLink" runat="server" Text="Link (optional)" meta:resourcekey="lblImageLinkResource1"></asp:Literal><br /><input type="text" id="ImageLinkInput" style="width: 300px;" /> 
                <small>
                    <a href="#" onclick="javascript:return __ShowAndSelectInput('ImageLinkInput');"><asp:Literal ID="lblBrowse2" runat="server" Text="Browse" meta:resourcekey="lblBrowse2Resource1" /></a> -
                    <a href="#" id="PickFileLink" onclick="javascript:return __ToggleFileListForImage();"><asp:Literal ID="lblPickFile" runat="server" Text="Pick File" meta:resourcekey="lblPickFileResource1" /></a> -
                    <a href="#" id="PickPageLink" onclick="javascript:return __TogglePageListForImage();"><asp:Literal ID="lblPickPage" runat="server" Text="Pick Page" meta:resourcekey="lblPickPageResource1" /></a>
                </small>
            <br /><br />
            <div style="text-align: center; border-top: solid 1px #CCCCCC;">
                <a href="#" onclick="javascript:return __Done(false);"><b><asp:Literal ID="lblOK1" runat="server" Text="OK" meta:resourcekey="lblOK1Resource1" /></b></a> - 
                <a href="#" onclick="javascript:return __Done(true);"><b><asp:Literal ID="lblCancel1" runat="server" Text="Cancel" meta:resourcekey="lblCancel1Resource1" /></b></a>
            </div>
        </div>
        <st:JsImageBrowser ID="jsimBrowser" runat="server" EnableViewState="false" HrefCommand="#" OnClickCommand="javascript:return __SelectImage('{UP}$');" /><br />
        <div id="BrowserControlsDiv" style="display: none; text-align: center;">
            <a href="#" onclick="javascript:return __Hide(false);"><b><asp:Literal ID="lblOK2" runat="server" Text="OK" meta:resourcekey="lblOK2Resource1" /></b></a> - 
            <a href="#" onclick="javascript:return __Hide(true);"><b><asp:Literal ID="lblCancel2" runat="server" Text="Cancel" meta:resourcekey="lblCancel2Resource1" /></b></a>
        </div>
    </div>
    
    <script type="text/javascript">
    <!--
        document.getElementById("ImageBrowserDiv").style["display"] = "none";
    // -->
    </script>
    
    <h1 class="pagetitlesystem" id="MainTitle"><asp:Literal ID="lblGlobalTitle" runat="server" Text="-- Title --" meta:resourcekey="lblGlobalTitleResource1" />
        <asp:TextBox ID="txtPageName" runat="server" Visible="False" Width="300px" meta:resourcekey="txtPageNameResource1" ToolTip="Type here the Page name" /></h1>
    <p class="small"><b><asp:Literal ID="lblIpLogged" runat="server" meta:resourcekey="lblIpLoggedResource1" Text="Since you are not logged in, your IP Address will be used as Username." Visible="False" /></b></p>
    
    <asp:Panel ID="pnlProvider" runat="server" Visible="False" meta:resourcekey="pnlProviderResource1">
		<div id="EditProviderListDiv">
			<asp:Literal ID="lblProvider" runat="server" Text="Create in" meta:resourcekey="lblProviderResource1" />
			<br />
			<asp:DropDownList ID="lstProvider" runat="server" AutoPostBack="True" OnSelectedIndexChanged="lstProvider_SelectedIndexChanged" meta:resourcekey="lstProviderResource1" />
        </div>
    </asp:Panel>
    
    <p><asp:Literal ID="lblTitle" runat="server" Text="Page Title" meta:resourcekey="lblTitleResource1" /></p>
    <asp:TextBox ID="txtTitle" runat="server" Width="350px" meta:resourcekey="txtTitleResource1" ToolTip="Type here the Page Title" />
    <asp:Literal ID="lblEditNotice" runat="server" meta:resourcekey="lblEditNoticeResource1" />
    <br /><br />
    
    <asp:Panel ID="pnlConcurrentEditing" runat="server" Visible="False" meta:resourcekey="pnlConcurrentEditingResource1">
        <div id="ConcurrentEditingDiv">
            <asp:Literal ID="lblConcurrentEditing" runat="server" Text="&lt;b&gt;Warning&lt;/b&gt;: this Page is being edited by another user" meta:resourcekey="lblConcurrentEditingResource1" />
            <asp:Literal ID="lblConcurrentEditingUsername" runat="server" />.
            <asp:Literal ID="lblSaveDangerous" runat="server" Visible="False" Text="Saving this Page might result in a &lt;b&gt;data-loss&lt;/b&gt;." meta:resourcekey="lblSaveDangerousResource1" />
            <asp:Literal ID="lblSaveDisabled" runat="server" Visible="False" Text="The Administrators don't allow to save this Page." meta:resourcekey="lblSaveDisabledResource1" />
            <asp:Literal ID="lblRefreshLink" runat="server" meta:resourcekey="lblRefreshLinkResource2" />
        </div>
        <br /><br />
    </asp:Panel>
    
    <div id="PageListDiv" style="display: none; z-index: 2000;">
        <div style="padding: 0px; margin: 0px; height: 250px; width: 200px; overflow: scroll;">
			<asp:Literal ID="lblPageList" runat="server" meta:resourcekey="lblPageListResource2" />
			<script type="text/javascript">
			<!--
				function __FilterPages() {
					var txt = document.getElementById("TxtSearchPage").value;
					txt = txt.toLowerCase();
					var temp = "";
					
					for(i = 0; i < __AllPages.length; i++) {
						if(txt == "" || (__AllPages[i].toLowerCase().indexOf(txt) != -1)) {
							temp += '<a href="#" class="pagelistlink" onclick="javascript:return __LinkPage(\'' + __AllPages[i] + '\');">' + __AllPages[i] + '</a>';
						}
					}
					
					document.getElementById("PagesSpan").innerHTML = temp;
					
					return false;
				}
			// -->
			</script>
			<input id="TxtSearchPage" type="text" onkeyup="javascript:__FilterPages(); return true;" />
            <span id="PagesSpan">&nbsp;</span>
        </div>
    </div>
    
    <div id="FileListDiv" style="display: none; height: 200px; z-index: 2000; overflow: auto;">
        <div style="margin-bottom: 6px;">
            <input type="checkbox" id="AttachmentChk" name="AttachmentChk" />
            <label for="AttachmentChk">
                <small><asp:Literal ID="lblAttachment" runat="server" Text="Link as Attachment" meta:resourcekey="lblAttachmentResource1" /></small>
            </label>
        </div>
        <st:JsFileTree ID="jsftTree" runat="server" EnableViewState="false" HrefCommand="#" OnClickCommand="javascript:return __LinkFile('$');" />
    </div>
    
    <div id="SnippetListDiv" style="display: none;">
        <div style="padding: 0px; margin: 0px; height: 200px; width: 150px; overflow: auto;">
            <asp:Literal ID="lblSnippetList" runat="server" meta:resourcekey="lblSnippetListResource1"></asp:Literal>
        </div>
    </div>
    
    <ul id="FormatUl">
        <li><a href="#" onclick="javascript:return __Wrap('\'\'\'', '\'\'\'');" title="<% Response.Write(Resources.Messages.Bold); %>" class="formatlink" id="BoldLink"><% Response.Write(Resources.Messages.Bold); %></a></li>
        <li><a href="#" onclick="javascript:return __Wrap('\'\'', '\'\'');" title="<% Response.Write(Resources.Messages.Italic); %>" class="formatlink" id="ItalicLink"><% Response.Write(Resources.Messages.Italic); %></a></li>
        <li><a href="#" onclick="javascript:return __Wrap('__', '__');" title="<% Response.Write(Resources.Messages.Underlined); %>" class="formatlink" id="UnderlineLink"><% Response.Write(Resources.Messages.Underlined); %></a></li>
        <li><a href="#" onclick="javascript:return __Wrap('--', '--');" title="<% Response.Write(Resources.Messages.Striked); %>" class="formatlink" id="StrikeLink"><% Response.Write(Resources.Messages.Striked); %></a></li>
        <li><a href="#" onclick="javascript:return __Wrap('==', '==');" title="<% Response.Write(Resources.Messages.H1); %>" class="formatlink" id="H1Link"><% Response.Write(Resources.Messages.H1); %></a></li>
        <li><a href="#" onclick="javascript:return __Wrap('===', '===');" title="<% Response.Write(Resources.Messages.H2); %>" class="formatlink" id="H2Link"><% Response.Write(Resources.Messages.H2); %></a></li>
        <li><a href="#" onclick="javascript:return __Wrap('====', '====');" title="<% Response.Write(Resources.Messages.H3); %>" class="formatlink" id="H3Link"><% Response.Write(Resources.Messages.H3); %></a></li>
        <li><a href="#" onclick="javascript:return __Wrap('=====', '=====');" title="<% Response.Write(Resources.Messages.H4); %>" class="formatlink" id="H4Link"><% Response.Write(Resources.Messages.H4); %></a></li>
        <li><a href="#" onclick="javascript:return __Wrap('&lt;sub&gt;', '&lt;/sub&gt;');" title="<% Response.Write(Resources.Messages.Subscript); %>" class="formatlink" id="SubLink"><% Response.Write(Resources.Messages.Subscript); %></a></li>
        <li><a href="#" onclick="javascript:return __Wrap('&lt;sup&gt;', '&lt;/sup&gt;');" title="<% Response.Write(Resources.Messages.Superscript); %>" class="formatlink" id="SupLink"><% Response.Write(Resources.Messages.Superscript); %></a></li>
        <li><a href="#" onclick="javascript:return __TogglePageList();" title="<% Response.Write(Resources.Messages.PageLink); %>" class="formatlink" id="PageListLink"><% Response.Write(Resources.Messages.PageLink); %></a></li>
        <li><a href="#" onclick="javascript:return __ToggleFileList();" title="<% Response.Write(Resources.Messages.FileLink); %>" class="formatlink" id="FileLink"><% Response.Write(Resources.Messages.FileLink); %></a></li>
        <li><a href="#" onclick="javascript:return __BuildLink();" title="<% Response.Write(Resources.Messages.ExternalLink); %>" class="formatlink" id="LinkLink"><% Response.Write(Resources.Messages.ExternalLink); %></a></li>
        <li><a href="#" onclick="javascript:return __ToggleImages();" title="<% Response.Write(Resources.Messages.Image); %>" class="formatlink" id="ImageLink"><% Response.Write(Resources.Messages.Image); %></a></li>
        <li><a href="#" onclick="javascript:return __ToggleAnchors();" title="<% Response.Write(Resources.Messages.Anchor); %>" class="formatlink" id="AnchorLink"><% Response.Write(Resources.Messages.Anchor); %></a></li>
        <li><a href="#" onclick="javascript:return __Wrap('{{', '}}');" title="<% Response.Write(Resources.Messages.CodeInline); %>" class="formatlink" id="CodeLink"><% Response.Write(Resources.Messages.CodeInline); %></a></li>
        <li><a href="#" onclick="javascript:return __Wrap('{{{{', '}}}}');" title="<% Response.Write(Resources.Messages.CodeBlock); %>" class="formatlink" id="PreLink"><% Response.Write(Resources.Messages.CodeBlock); %></a></li>
        <li><a href="#" onclick="javascript:return __Wrap('(((', ')))');" title="<% Response.Write(Resources.Messages.Box); %>" class="formatlink" id="BoxLink"><% Response.Write(Resources.Messages.Box); %></a></li>
        <li><a href="#" onclick="javascript:return __Insert('{BR}');" title="<% Response.Write(Resources.Messages.LineBreak); %>" class="formatlink" id="BrLink"><% Response.Write(Resources.Messages.LineBreak); %></a></li>
        <li><a href="#" onclick="javascript:return __ToggleSnippetList();" title="<% Response.Write(Resources.Messages.InsertSnippet); %>" class="formatlink" id="SnippetListLink"><% Response.Write(Resources.Messages.InsertSnippet); %></a></li>
        <li><a href="#" onclick="javascript:return __ToggleSpecialTags();" title="<% Response.Write(Resources.Messages.SpecialTags); %>" class="formatlink" id="SpecialTagsLink"><% Response.Write(Resources.Messages.SpecialTags); %></a></li>
        <li><a href="#" onclick="javascript:return __Wrap('&lt;nowiki&gt;', '&lt;/nowiki&gt;');" title="<% Response.Write(Resources.Messages.NoWiki); %>" class="formatlink" id="NoWikiLink"><% Response.Write(Resources.Messages.NoWiki); %></a></li>
        <li><a href="#" onclick="javascript:return __Wrap('&lt;!--', '--&gt;');" title="<% Response.Write(Resources.Messages.Comment); %>" class="formatlink" id="CommentLink"><% Response.Write(Resources.Messages.Comment); %></a></li>
        <li><a href="#" onclick="javascript:return __Wrap('&lt;esc&gt;', '&lt;/esc&gt;');" title="<% Response.Write(Resources.Messages.Escape); %>" class="formatlink" id="EscapeLink"><% Response.Write(Resources.Messages.Escape); %></a></li>
    </ul> 
    <div id="SpecialTagsDiv" style="display: none;">
        <a href="#" onclick="javascript:return __Insert('{WIKITITLE}');" class="specialtaglink">{WikiTitle}</a>
        <a href="#" onclick="javascript:return __Insert('{UP}');" class="specialtaglink">{Up}</a>
        <a href="#" onclick="javascript:return __Insert('{TOP}');" class="specialtaglink">{Top}</a>
        <a href="#" onclick="javascript:return __Insert('{TOC}');" class="specialtaglink">{TOC}</a>
        <a href="#" onclick="javascript:return __Insert('{THEMEPATH}');" class="specialtaglink">{ThemePath}</a>
        <a href="#" onclick="javascript:return __Insert('{RSSPAGE}');" class="specialtaglink">{RSSPage}</a>
        <a href="#" onclick="javascript:return __Insert('{WIKIVERSION}');" class="specialtaglink">{WikiVersion}</a>
        <a href="#" onclick="javascript:return __Insert('{MAINURL}');" class="specialtaglink">{MainURL}</a>
        <a href="#" onclick="javascript:return __Insert('{PAGECOUNT}');" class="specialtaglink">{PageCount}</a>
        <a href="#" onclick="javascript:return __Insert('{USERNAME}');" class="specialtaglink">{Username}</a>
        <a href="#" onclick="javascript:return __Insert('{CLEAR}');" class="specialtaglink">{Clear}</a>
        <a href="#" onclick="javascript:return __Insert('{CLOUD}');" class="specialtaglink">{Cloud}</a>
        <a href="#" onclick="javascript:return __Insert('{SEARCHBOX}');" class="specialtaglink">{SearchBox}</a>
        <asp:Literal ID="lblCustomSpecialTags" runat="server" EnableViewState="false" />
    </div>
    <div id="AnchorsDiv" style="display: none;">
        <a href="#" onclick="javascript:return __BuildAnchor();" class="anchorlink"><asp:Literal ID="lblBuildAnchor" runat="server" meta:resourcekey="lblBuildAnchorResource1"></asp:Literal></a>
        <a href="#" onclick="javascript:return __BuildAnchorLink();" class="anchorlink"><asp:Literal ID="lblBuildAnchorLink" runat="server" meta:resourcekey="lblBuildAnchorLinkResource1"></asp:Literal></a>
    </div>
    <div id="ImagesDiv" style="display: none;">
        <a href="#" onclick="javascript:return __BuildImage('left');" class="imagelink"><asp:Literal ID="lblImageLeft" runat="server" meta:resourcekey="lblImageLeftResource1"></asp:Literal></a>
        <a href="#" onclick="javascript:return __BuildImage('right');" class="imagelink"><asp:Literal ID="lblImageRight" runat="server" meta:resourcekey="lblImageRightResource1"></asp:Literal></a>
        <a href="#" onclick="javascript:return __BuildImage('auto');" class="imagelink"><asp:Literal ID="lblImageAuto" runat="server" meta:resourcekey="lblImageAutoResource1"></asp:Literal></a>
        <a href="#" onclick="javascript:return __BuildImage('');" class="imagelink"><asp:Literal ID="lblImageInline" runat="server" meta:resourcekey="lblImageInlineResource1"></asp:Literal></a>
    </div>
    <div style="float: right; position: relative; top: 0px; right: 10px;">
        <p class="small" style="text-align: right;"><asp:Literal ID="lblTextareaSize" runat="server" meta:resourcekey="lblTextareaSizeResource1"></asp:Literal><br />
        <a href="#" onclick="javascript:return __IncreaseSize();"><asp:Literal ID="lblBigger" runat="server" meta:resourcekey="lblBiggerResource1"></asp:Literal></a> /
        <a href="#" onclick="javascript:return __DecreaseSize();"><asp:Literal ID="lblSmaller" runat="server" meta:resourcekey="lblSmallerResource1"></asp:Literal></a> /
        <a href="#" onclick="javascript:return __AutoSize();"><asp:Literal ID="lblAuto" runat="server" meta:resourcekey="lblAutoResource1"></asp:Literal></a></p>
    </div> 
     
    <br /><br />
    <asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine" meta:resourcekey="txtContentResource1" Rows="26" Columns="95"></asp:TextBox>
    <br />
    <asp:Literal ID="lblEditComment" runat="server" Text="Edit Comment" meta:resourcekey="lblEditCommentResource1" />
    <asp:TextBox ID="txtComment" runat="server" Width="500px" meta:resourcekey="txtCommentResource1" />
    <div style="height: 50px; margin-top: 4px;">
		<asp:Panel ID="pnlCaptcha" runat="server" style="float: left;">
			<st:Captcha ID="captcha" runat="server" />
		</asp:Panel>
		<div>
			<asp:Button ID="btnSave" runat="server" Text="Save Item" style="font-weight: bold;" meta:resourcekey="btnSaveResource1" OnClick="btnSave_Click" ToolTip="Save the current Item" />
			<asp:Button ID="btnSaveAndContinue" runat="server" Text="Save & Continue" ToolTip="Save the data and continue editing" OnClick="btnSaveAndContinue_Click" meta:resourcekey="btnSaveAndContinueResource1" />
			<asp:Button ID="btnPreview" runat="server" Text="Preview" meta:resourcekey="btnPreviewResource1" OnClick="btnPreview_Click" ToolTip="Show the Preview of the content" CausesValidation="false" />
			<asp:Button ID="btnCancel" runat="server" Text="Cancel" meta:resourcekey="btnCancelResource1" OnClick="btnCancel_Click" ToolTip="Cancel Editing" CausesValidation="false" />
			<span id="ResultSpan"><asp:Label ID="lblResult" runat="server" meta:resourcekey="lblResultResource1" /></span>
		</div>
    </div>
   
    <script type="text/javascript">
    <!--
        function __IncreaseSize() {
			var box = __GetServerElementById("txtContent");
            box.rows = box.rows + 8;
            return false;
        }
        function __DecreaseSize() {
			var box = __GetServerElementById("txtContent");
            box.rows = box.rows - 8;
            return false;
        }
        function __AutoSize() {
			var box = __GetServerElementById("txtContent");
            var str = box.value;
            var count = str.split("\n").length + str.length / (box.cols * 2);
            if(count > 0) {
                box.rows = count + 6;
            }
            return false;
        }

        function __ResizeTextbox() {
            __GetServerElementById("txtContent").style["width"] = document.getElementById("MainTitle").scrollWidth - 24 + "px";
        }
        __ResizeTextbox();
        window.onresize = __ResizeTextbox;
        __GetServerElementById("txtContent").onmouseup = __HideMenus;
        
        function __HideMenus() {
            document.getElementById("SpecialTagsDiv").style["display"] = "none";
            document.getElementById("AnchorsDiv").style["display"] = "none";
            document.getElementById("ImagesDiv").style["display"] = "none";
            document.getElementById("PageListDiv").style["display"] = "none";
            document.getElementById("SnippetListDiv").style["display"] = "none";
            document.getElementById("FileListDiv").style["display"] = "none";
        }
        
        __GetServerElementById("txtContent").selectionStart = 0;
        __GetServerElementById("txtContent").selectionEnd = 0;
        __GetServerElementById("txtContent").focus();
        try {
            if(__GetServerElementById("txtPageName").value.length == 0 && !__GetServerElementById("txtPageName").hidden) {
                __GetServerElementById("txtPageName").focus();
            }
            else if(__GetServerElementById("txtTitle").value.length == 0 && !__GetServerElementById("txtTitle").hidden) {
                __GetServerElementById("txtTitle").focus();
            }
        } catch(ex) { }
    // -->
    </script> 
   
    <script type="text/javascript">
    <!--
        var __ClosePreviewLink = '<a href="#" onclick="javascript:document.getElementById(\'AjaxPreviewDiv\').style[\'display\'] = \'none\';" style="float: right; padding: 4px; background-color: #FFFFFF;"><b>X</b></a>';
        
        function __DetectScripts() {
            var data = __GetServerElementById("txtContent").value;
            data = data.toLowerCase();
            if(data.indexOf("<script") != -1) return true;
            else return false;
        }

        function __LoadPreview() {
            if(!__XmlHttp) {
                return true;
            }
            if(!__ScriptAllowed && __DetectScripts()) {
                document.getElementById("ResultSpan").className = "resulterror";
                document.getElementById("ResultSpan").innerHTML = __ScriptDetected;
                return false;
            }
            __ResetAjaxPreview();
            document.getElementById("PreviewDivExternal").style["display"] = "";
            
            var loc = document.location.href;
		    loc = loc.replace("#Prev", "");
			loc = loc.replace("#", "");
			document.location.href = loc + "#Prev";
            
            __XmlHttp.open("POST", "Preview.aspx", true);
            __XmlHttp.setRequestHeader("content-type", "application/x-www-form-urlencoded");
		    __XmlHttp.onreadystatechange = function() {
			    if(__XmlHttp.readyState == 4 || __XmlHttp.readyState == "complete") {
				    if(__XmlHttp.status == 200 || __XmlHttp.status == 0) {
					    document.getElementById("PreviewDiv").innerHTML = __XmlHttp.responseText;
					    document.getElementById("ResultSpan").className = "resultok";
					    document.getElementById("ResultSpan").innerHTML = __PreviewCreated;
					    var loc = document.location.href;
					    loc = loc.replace("#Prev", "");
					    loc = loc.replace("#", "");
					    document.location.href = loc + "#Prev";
				    }
				    else {
				        window.alert("AJAX POST Returned: " + __XmlHttp.status + "\n" + __XmlHttp.statusText);
					    return true;
				    }
			    }
		    }
		    var content = __GetServerElementById("txtContent").value;
		    content = content.replace(/%/g, "%25");
		    content = content.replace(/&/g, "%26");
		    content = content.replace(/\+/g, "%2B");
		    __XmlHttp.send("Text=" + content);
            return false;
        }
        
        function __ResetAjaxPreview() {
            document.getElementById("PreviewDiv").innerHTML = '<p style="text-align: center;"><img src="Images/Wait.gif" alt="Wait" /></p>';
        }
    // -->
    </script>
    
    <asp:Literal ID="lblAjaxEnabler" runat="server" meta:resourcekey="lblAjaxEnablerResource1" />
       
    <br />
    <table>
		<tr>
			<td style="vertical-align: top;">
				<h2 class="separator"><asp:Literal ID="lblCategories" runat="server" Text="Categories" meta:resourcekey="lblCategoriesResource1" /></h2>
				<div>
					<div id="CategoriesListDiv">
						<asp:CheckBoxList ID="lstCategories" runat="server" RepeatDirection="Vertical"
							meta:resourcekey="lstCategoriesResource1" RepeatLayout="Flow" />
					</div>
					<br />
					<asp:TextBox ID="txtNewCategory" runat="server" Width="180px" meta:resourcekey="txtNewCategoryResource1" /><br />
					<asp:Button ID="btnNewCategory" runat="server" Text="Create new Category" OnClick="btnNewCategory_Click" meta:resourcekey="btnNewCategoryResource1" />
					<asp:Label ID="lblNewCategoryResult" runat="server" meta:resourcekey="lblNewCategoryResultResource1" />
				</div> 
			</td>
			<td style="vertical-align: top;">
				<h2 class="separator"><asp:Literal ID="lblQuickUpload" runat="server" Text="Quick Upload" meta:resourcekey="lblQuickUploadResource1" /></h2>
				<asp:FileUpload ID="updFile" runat="server" size="20" /><br />
				<asp:Button ID="btnUpload" runat="server" Text="Upload/Refresh" OnClick="btnUpload_Click" ToolTip="Uploads the file or refreshes the current file lists" meta:resourcekey="btnUploadResource1" />
				<asp:Label ID="lblUploadResult" runat="server" />
				<br /><br />
				<small>
					<asp:Literal ID="lblUploadInfo" runat="server" Text="Files will be uploaded in: " meta:resourcekey="lblUploadInfoResource1" /><br />
					{UP}/<asp:TextBox ID="txtUploadDirectory" runat="server" Width="120px" class="compact" />
					<br /><br />
					<a href="Upload.aspx" target="_blank"><asp:Literal ID="lblFileManagement" runat="server" meta:resourcekey="lblFileManagementResource1" /></a>
				</small>
			</td>
			<td style="vertical-align: top;">
				<h2 class="separator"><asp:Literal ID="lblSpecialChars" runat="server" Text="Special Characters" /></h2>
				<div id="SpecialCharsDiv">
					<a href="#" onclick="javascript:return __Insert('&amp;#42;');">*</a>
					<a href="#" onclick="javascript:return __Insert('&amp;#35;');">#</a>
					<a href="#" onclick="javascript:return __Insert('&amp;#39;');"><b>'</b></a>
					<a href="#" onclick="javascript:return __Insert('&amp;#64;');"><b>@</b></a>
					<a href="#" onclick="javascript:return __Insert('&amp;#124;');">|</a>
					<a href="#" onclick="javascript:return __Insert('&amp;#95;');">_</a>
					<a href="#" onclick="javascript:return __Insert('&amp;ndash;');">&ndash;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;mdash;');">&mdash;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;#40;');">(</a>
					<a href="#" onclick="javascript:return __Insert('&amp;#41;');">)</a>
					<a href="#" onclick="javascript:return __Insert('&amp;#0091;');">[</a>
					<a href="#" onclick="javascript:return __Insert('&amp;#0093;');">]</a>
					<a href="#" onclick="javascript:return __Insert('&amp;#0123;');">{</a>
					<a href="#" onclick="javascript:return __Insert('&amp;#0125;');">}</a>
					<a href="#" onclick="javascript:return __Insert('&amp;lt;');">&lt;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;gt;');">&gt;</a>
			         
					<a href="#" onclick="javascript:return __Insert('&amp;quot;');">&quot;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;amp;');">&amp;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;euro;');">&euro;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Aacute;');">&Aacute;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;aacute;');">&aacute;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Acirc;');">&Acirc;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;acirc;');">&acirc;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;acute;');">&acute;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;AElig;');">&AElig;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;aelig;');">&aelig;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Agrave;');">&Agrave;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;agrave;');">&agrave;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Aring;');">&Aring;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;aring;');">&aring;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Atilde;');">&Atilde;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Auml;');">&Auml;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;auml;');">&auml;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;brvbar;');">&brvbar;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Ccedil;');">&Ccedil;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;ccedil;');">&ccedil;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;cedil;');">&cedil;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;cent;');">&cent;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;circ;');">&circ;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;copy;');">&copy;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;curren;');">&curren;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;deg;');">&deg;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;divide;');">&divide;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Eacute;');">&Eacute;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;eacute;');">&eacute;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Ecirc;');">&Ecirc;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;ecirc;');">&ecirc;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Egrave;');">&Egrave;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;egrave;');">&egrave;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;ETH;');">&ETH;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;eth;');">&eth;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Euml;');">&Euml;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;euro;');">&euro;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;fnof;');">&fnof;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;frac12;');">&frac12;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;frac14;');">&frac14;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;frac34;');">&frac34;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Iacute;');">&Iacute;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;iacute;');">&iacute;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Icirc;');">&Icirc;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;icirc;');">&icirc;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;iexcl;');">&iexcl;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Igrave;');">&Igrave;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;igrave;');">&igrave;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;iquest;');">&iquest;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Iuml;');">&Iuml;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;iuml;');">&iuml;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;laquo;');">&laquo;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;raquo;');">&raquo;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;micro;');">&micro;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;middot;');">&middot;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;not;');">&not;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Ntilde;');">&Ntilde;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;ntilde;');">&ntilde;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Oacute;');">&Oacute;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;oacute;');">&oacute;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Ocirc;');">&Ocirc;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;ocirc;');">&ocirc;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;OElig;');">&OElig;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;oelig;');">&oelig;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Ograve;');">&Ograve;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;ograve;');">&ograve;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;ordf;');">&ordf;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;ordm;');">&ordm;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Oslash;');">&Oslash;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;oslash;');">&oslash;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Otilde;');">&Otilde;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;otilde;');">&otilde;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Ouml;');">&Ouml;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;ouml;');">&ouml;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;para;');">&para;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;plusmn;');">&plusmn;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;pound;');">&pound;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;reg;');">&reg;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Scaron;');">&Scaron;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;scaron;');">&scaron;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;sect;');">&sect;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;shy;');">&shy;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;sup1;');">&sup1;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;sup2;');">&sup2;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;sup3;');">&sup3;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;szlig;');">&szlig;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;THORN;');">&THORN;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;thorn;');">&thorn;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;tilde;');">&tilde;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;times;');">&times;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Uacute;');">&Uacute;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;uacute;');">&uacute;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Ucirc;');">&Ucirc;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;ucirc;');">&ucirc;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Ugrave;');">&Ugrave;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;ugrave;');">&ugrave;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;uml;');">&uml;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Uuml;');">&Uuml;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;uuml;');">&uuml;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Yacute;');">&Yacute;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;yacute;');">&yacute;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;yen;');">&yen;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Yuml;');">&Yuml;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;yuml;');">&yuml;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;zwnj;');">&zwnj;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;zwj;');">&zwj;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;lrm;');">&lrm;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;rlm;');">&rlm;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;lsquo;');">&lsquo;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;rsquo;');">&rsquo;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;sbquo;');">&sbquo;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;ldquo;');">&ldquo;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;rdquo;');">&rdquo;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;bdquo;');">&bdquo;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;lsaquo;');">&lsaquo;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;rsaquo;');">&rsaquo;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;dagger;');">&dagger;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Dagger;');">&Dagger;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;permil;');">&permil;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;bull;');">&bull;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;hellip;');">&hellip;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Prime;');">&Prime;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;prime;');">&prime;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;oline;');">&oline;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;frasl;');">&frasl;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;trade;');">&trade;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;larr;');">&larr;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;uarr;');">&uarr;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;rarr;');">&rarr;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;darr;');">&darr;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;harr;');">&harr;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;rArr;');">&rArr;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;hArr;');">&hArr;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;forall;');">&forall;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;part;');">&part;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;exist;');">&exist;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;nabla;');">&nabla;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;isin;');">&isin;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;ni;');">&ni;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;prod;');">&prod;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;sum;');">&sum;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;minus;');">&minus;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;radic;');">&radic;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;prop;');">&prop;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;infin;');">&infin;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;ang;');">&ang;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;and;');">&and;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;or;');">&or;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;cap;');">&cap;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;cup;');">&cup;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;int;');">&int;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;there4;');">&there4;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;sim;');">&sim;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;asymp;');">&asymp;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;ne;');">&ne;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;equiv;');">&equiv;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;le;');">&le;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;ge;');">&ge;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;sub;');">&sub;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;sup;');">&sup;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;sube;');">&sube;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;supe;');">&supe;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;oplus;');">&oplus;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;perp;');">&perp;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;loz;');">&loz;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;spades;');">&spades;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;clubs;');">&clubs;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;hearts;');">&hearts;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;diams;');">&diams;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Alpha;');">&Alpha;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;alpha;');">&alpha;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Beta;');">&Beta;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;beta;');">&beta;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Gamma;');">&Gamma;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;gamma;');">&gamma;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Delta;');">&Delta;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;delta;');">&delta;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Epsilon;');">&Epsilon;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;epsilon;');">&epsilon;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Zeta;');">&Zeta;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;zeta;');">&zeta;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Eta;');">&Eta;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;eta;');">&eta;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Theta;');">&Theta;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;theta;');">&theta;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Iota;');">&Iota;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;iota;');">&iota;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Kappa;');">&Kappa;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;kappa;');">&kappa;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Lambda;');">&Lambda;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;lambda;');">&lambda;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Mu;');">&Mu;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;mu;');">&mu;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Nu;');">&Nu;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;nu;');">&nu;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Xi;');">&Xi;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;xi;');">&xi;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Omicron;');">&Omicron;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;omicron;');">&omicron;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Pi;');">&Pi;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;pi;');">&pi;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Rho;');">&Rho;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;rho;');">&rho;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Sigma;');">&Sigma;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;sigma;');">&sigma;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;sigmaf;');">&sigmaf;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Tau;');">&Tau;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;tau;');">&tau;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Upsilon;');">&Upsilon;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;upsilon;');">&upsilon;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Phi;');">&Phi;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;phi;');">&phi;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Chi;');">&Chi;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;chi;');">&chi;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Psi;');">&Psi;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;psi;');">&psi;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;Omega;');">&Omega;</a>
					<a href="#" onclick="javascript:return __Insert('&amp;omega;');">&omega;</a>
				</div> 
			</td>
		</tr>
    </table>
    <br /> 
    <a id="Prev"></a>
    <asp:Literal ID="lblPrePreview" runat="server" meta:resourcekey="lblPrePreviewResource1" />
    <asp:Label ID="lblPreview" runat="server" meta:resourcekey="lblPreviewResource1" />
    <asp:Literal ID="lblPostPreview" runat="server" meta:resourcekey="lblPostPreviewResource1" />
   
    <!-- Used to keep the session alive -->
    <asp:Literal ID="lblSessionRefresh" runat="server" meta:resourcekey="lblSessionRefreshResource1" />
    
    <script type="text/javascript">
	<!--
		var submitted = false;
		function __UnloadPage(e) {
			if(!submitted) {
				e.returnValue = " ";
			}
		}
		
		function __SetSubmitted() {
			submitted = true;
		}
		
		__GetServerElementById("btnSave").onclick = __SetSubmitted;
		if(__GetServerElementById("btnSaveAndContinue")) {
			__GetServerElementById("btnSaveAndContinue").onclick = __SetSubmitted;
		}
		__GetServerElementById("btnCancel").onclick = __SetSubmitted;
		if(__GetServerElementById("btnNewCategory")) {
		    // btnNewCategory might not be visible
		    __GetServerElementById("btnNewCategory").onclick = __SetSubmitted;
		}
		if(__GetServerElementById("btnUpload")) {
			__GetServerElementById("btnUpload").onclick = __SetSubmitted;
		}
	// -->
    </script>
    
    <asp:Literal ID="lblUnloadPage" runat="server" />

    </div>
</asp:Content>
