<%@ Control Language="C#" AutoEventWireup="true" Inherits="ScrewTurn.Wiki.Editor" Codebehind="Editor.ascx.cs" %>

<%@ Register TagName="ClientImageBrowser" TagPrefix="st" Src="~/ClientImageBrowser.ascx" %>

<asp:Literal ID="lblStrings" runat="server" meta:resourcekey="lblStringsResource3" />

<!-- added for WYSIWYG -->
<script type="text/javascript">
<!--
    var debug=true;

    var iframe;
    var inWYSIWYG=false;

    function IsInWYSIWYG() {
      if(inWYSIWYG) {
        inWYSIWYG=false;
        return true;
      }
      return false;
    }

    function iframe_onload() {
      inWYSIWYG=true;
      if (document.all) {
		    iframe = window.frames[0];
		    iframe.focus();
		    var range = iframe.document.selection.createRange();
		    range.pasteHTML(document.getElementById(VisualControl).value);
		    range.collapse(false);
		    range.select();
		    iframe.document.designMode='On';
	    } else {
		    iframe = document.getElementById('iframe').contentWindow;
		    iframe.document.designMode='On';
		    iframe.document.execCommand('styleWithCSS',false,false);
		    iframe.document.execCommand('backcolor', false, 'white');
		    try { // This seems to throw an exception in Firefox
		    	iframe.focus();
		    	iframe.document.execCommand('inserthtml', false, document.getElementById(VisualControl).value);
		    } catch(ex) { }
	    }
    }

    function execCmd(commandID,showUI,value) {
      iframe.focus();
      iframe.document.execCommand(commandID,showUI,value);
    }

    function getSelectedText() {
      if(document.all)
        var selected=iframe.document.selection.createRange().htmlText;
      else
        var selected=iframe.document.defaultView.getSelection().getRangeAt(0).commonAncestorContainer.innerHTML;
      return selected;
    }

    function insertHTML(html) {
        if (document.all) {
		    iframe.focus();
		    var range = iframe.document.selection.createRange();
		    range.pasteHTML(html);
		    range.collapse(false);
		    range.select();
		    iframe.focus();
	    } else {
			iframe.document.execCommand('inserthtml', false, html);
		    iframe.focus();
	    }
    }

    function wrapWithTagClass(tag,clsName) {
    	insertHTML('<' + tag + ' class=' + clsName + '>' + getSelectedText() + '</' + tag + '>');
    }

    function wrapWithTag(tag) {
    	insertHTML('<' + tag + '>' + getSelectedText() + '</' + tag + '>');
    }

    function insertBreak() {
        insertHTML('<h1 class="separator"> </h1>\n');
    }

    function insertList(listTag) {
    	insertHTML('<' + listTag + '><li>' + getSelectedText() + '</li></' + listTag + '>');
    	return false;
    }

    function IncreaseHeight(elemName) {
    	var elem = document.getElementById(elemName);
    	var pos = AbsolutePosition(elem);
    	elem.style["height"] = pos.height + 100 + "px";

    	__CreateCookie("ScrewTurnWikiES", elem.style["height"], 365);
    	
    	return false;
    }
    function DecreaseHeight(elemName) {
    	var elem = document.getElementById(elemName);
    	var pos = AbsolutePosition(elem);
    	if(pos.height > 100) elem.style["height"] = pos.height - 100 + "px";

    	__CreateCookie("ScrewTurnWikiES", elem.style["height"], 365);
    	
    	return false;
    }

    function InitES() {
    	var cookieValue = __ReadCookie("ScrewTurnWikiES");
    	if(cookieValue) {
    		var elem = document.getElementById(MarkupControl);
    		if(elem) elem.style["height"] = cookieValue;
    		elem = document.getElementById("iframe");
    		if(elem) elem.style["height"] = cookieValue;
    	}
    }

    function __FocusEditorWindow() {
    	$("#<%= txtMarkup.ClientID %>").focus();
    	$("#iframe").focus();
    }
// -->
</script>

<div id="TabContainerDiv">
	<anthem:Button ID="btnWikiMarkup" runat="server" Text="WikiMarkup" OnClick="btnWikiMarkup_Click" CssClass="tabbutton" CausesValidation="false"
		PostCallBackFunction="HideProgress" PreCallBackFunction="ShowProgress" AutoUpdateAfterCallBack="True" EnableViewState="False" meta:resourcekey="btnWikiMarkupResource3" UpdateAfterCallBack="True" />
	<anthem:Button ID="btnVisual" runat="server" Text="Visual" OnClick="btnVisual_Click" CssClass="tabbutton" CausesValidation="false"
		PostCallBackFunction="HideProgress" PreCallBackFunction="ShowProgress" AutoUpdateAfterCallBack="True" EnableViewState="False" meta:resourcekey="btnVisualResource3" UpdateAfterCallBack="True" />
	<anthem:Button ID="btnPreview" runat="server" Text="Preview" OnClick="btnPreview_Click" CssClass="tabbutton" CausesValidation="false"
		PostCallBackFunction="HideProgress" PreCallBackFunction="ShowProgress" AutoUpdateAfterCallBack="True" EnableViewState="False" meta:resourcekey="btnPreviewResource3" UpdateAfterCallBack="True" />
	<span id="ProgressSpan" style="display: none;">
		<img src="Images/Editor/Progress.gif" alt="Please wait..." style="margin-bottom: -2px;" />
	</span>
</div>

<anthem:MultiView ID="mlvEditor" AutoUpdateAfterCallBack="True" UpdateAfterCallBack="True" runat="server">

    <anthem:View ID="viwStandard" runat="server">
    
        <div class="toolbar">
			<div class="sizebuttons">
				<anthem:ImageButton ID="btnBiggerMarkup" runat="server" ImageUrl="~/Images/Editor/EditorBigger.png" ImageUrlDuringCallBack="~/Images/Editor/EditorBigger.png"
					ToolTip="Increase editor size" CssClass="helperbutton" EnableViewState="False" meta:resourcekey="btnBiggerMarkupResource3"
					OnClientClick="javascript:return IncreaseHeight(MarkupControl);" />
				<anthem:ImageButton ID="btnSmallerMarkup" runat="server" ImageUrl="~/Images/Editor/EditorSmaller.png" ImageUrlDuringCallBack="~/Images/Editor/EditorSmaller.png"
					ToolTip="Decrease editor size" CssClass="helperbutton" EnableViewState="False" meta:resourcekey="btnSmallerMarkupResource3"
					OnClientClick="javascript:return DecreaseHeight(MarkupControl);" />
			</div>
			
			<div id="MarkupToolbarDiv">
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.BoldTitle %>" class="toolbarbutton" onclick="javascript:return WrapSelectedMarkup('\'\'\'', '\'\'\'');">
				<img src="Images/Editor/Bold.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.Bold %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.ItalicTitle %>" class="toolbarbutton" onclick="javascript:return WrapSelectedMarkup('\'\'', '\'\'');">
				<img src="Images/Editor/Italic.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.Italic %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.UnderlinedTitle %>" class="toolbarbutton" onclick="javascript:return WrapSelectedMarkup('__', '__');">
				<img src="Images/Editor/Underlined.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.Underlined %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.StrikedTitle %>" class="toolbarbutton" onclick="javascript:return WrapSelectedMarkup('--', '--');">
				<img src="Images/Editor/Striked.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.Striked %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.H1Title %>" class="toolbarbutton" onclick="javascript:return WrapSelectedMarkup('==', '==');">
				<img src="Images/Editor/H1.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.H1 %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.H2Title %>" class="toolbarbutton" onclick="javascript:return WrapSelectedMarkup('===', '===');">
				<img src="Images/Editor/H2.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.H2 %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.H3Title %>" class="toolbarbutton" onclick="javascript:return WrapSelectedMarkup('====', '====');">
				<img src="Images/Editor/H3.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.H3 %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.H4Title %>" class="toolbarbutton" onclick="javascript:return WrapSelectedMarkup('=====', '=====');">
				<img src="Images/Editor/H4.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.H4 %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.SuperscriptTitle %>" class="toolbarbutton" onclick="javascript:return WrapSelectedMarkup('<sup>', '</sup>');">
				<img src="Images/Editor/Superscript.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.Superscript %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.SubscriptTitle %>" class="toolbarbutton" onclick="javascript:return WrapSelectedMarkup('<sub>', '</sub>');">
				<img src="Images/Editor/Subscript.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.Subscript %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.PageLinkTitle %>" class="toolbarbutton" onclick="javascript:return OpenPopup('PageLink');">
				<img src="Images/Editor/PageLink.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.PageLink %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.FileLinkTitle %>" class="toolbarbutton" onclick="javascript:return OpenPopup('FileLink');">
				<img src="Images/Editor/File.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.FileLink %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.ExternalLinkTitle %>" class="toolbarbutton" onclick="javascript:return OpenPopup('ExternalLink');">
				<img src="Images/Editor/Link.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.ExternalLink %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.ImageTitle2 %>" class="toolbarbutton" onclick="javascript:return OpenPopup('Image');">
				<img src="Images/Editor/Image.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.Image %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.AnchorTitle2 %>" class="toolbarbutton" onclick="javascript:return OpenPopup('Anchor$' + ExtractAnchors());">
				<img src="Images/Editor/Anchor.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.Anchor %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.LineBreakTitle %>" class="toolbarbutton" onclick="javascript:return InsertMarkup('{br}');">
				<img src="Images/Editor/BR.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.LineBreak %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.SnippetsTitle %>" id="SnippetsMenuLinkMarkup" class="toolbarbutton" onclick="javascript:return ShowSnippetsMenuMarkup(event);">
				<img src="Images/Editor/Snippet.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.Snippets %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.SpecialTagsTitle %>" id="SpecialTagsMenuLinkMarkup" class="toolbarbutton" onclick="javascript:return ShowSpecialTagsMenuMarkup(event);">
				<img src="Images/Editor/SpecialTags.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.SpecialTags %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.HRTitle %>" class="toolbarbutton" onclick="javascript:return InsertMarkup('----');">
				<img src="Images/Editor/HR.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.HR %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.CodeInlineTitle %>" class="toolbarbutton" onclick="javascript:return WrapSelectedMarkup('{{', '}}');">
				<img src="Images/Editor/Code.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.CodeInline %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.CodeEscapedTitle %>" class="toolbarbutton" onclick="javascript:return WrapSelectedMarkup('@@', '@@');">
				<img src="Images/Editor/Pre.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.CodeEscaped %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.EscapeTitle %>" class="toolbarbutton" onclick="javascript:return WrapSelectedMarkup('<esc>', '</esc>');">
				<img src="Images/Editor/Escape.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.Escape %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.NoWikiTitle %>" class="toolbarbutton" onclick="javascript:return WrapSelectedMarkup('<nowiki>', '</nowiki>');">
				<img src="Images/Editor/NoWiki.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.NoWiki %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.NoBrTitle %>" class="toolbarbutton" onclick="javascript:return WrapSelectedMarkup('<nobr>', '</nobr>');">
				<img src="Images/Editor/NoBr.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.NoBr %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.WrapperBoxTitle %>" class="toolbarbutton" onclick="javascript:return WrapSelectedMarkup('(((', ')))');">
				<img src="Images/Editor/Box.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.WrapperBox %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.CommentTitle %>" class="toolbarbutton" onclick="javascript:return WrapSelectedMarkup('<!--', '-->');">
				<img src="Images/Editor/Comment.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.Comment %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.SymbolsTitle %>" id="SymbolsMenuLinkMarkup" class="toolbarbutton" onclick="javascript:return ShowSymbolsMenuMarkup(event);">
				<img src="Images/Editor/Symbol.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.Symbols %>" /></a>
			</div>
        </div>
        
        <anthem:TextBox ID="txtMarkup" runat="server" TextMode="MultiLine" Width="99%" Height="400px" style="width: 700px; min-width: 99%; max-width: 99%;" AutoUpdateAfterCallBack="True" meta:resourcekey="txtMarkupResource3" UpdateAfterCallBack="True" />
    
    </anthem:View>
    
    <anthem:View ID="viwVisual" runat="server">
    
        <div class="toolbar">
			<div class="sizebuttons">
				<anthem:ImageButton ID="btnBiggerMarkupVisual" runat="server" ImageUrl="~/Images/Editor/EditorBigger.png" ImageUrlDuringCallBack="~/Images/Editor/EditorBigger.png"
					ToolTip="Increase editor size" CssClass="helperbutton" EnableViewState="False" meta:resourcekey="btnBiggerMarkupVisualResource3"
					OnClientClick="javascript:return IncreaseHeight('iframe');" />
				<anthem:ImageButton ID="btnSmallerMarkupVisual" runat="server" ImageUrl="~/Images/Editor/EditorSmaller.png" ImageUrlDuringCallBack="~/Images/Editor/EditorSmaller.png"
					ToolTip="Decrease editor size" CssClass="helperbutton" EnableViewState="False" meta:resourcekey="btnSmallerMarkupVisualResource3"
					OnClientClick="javascript:return DecreaseHeight('iframe');" />
			</div>
        
			<div id="VisualToolbarDiv">
            <a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.BoldTitle %>" class="toolbarbutton" onclick="javascript:return execCmd('Bold',false,null);">
				<img src="Images/Editor/Bold.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.Bold %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.ItalicTitle %>" class="toolbarbutton" onclick="javascript:return execCmd('Italic',false,null);">
				<img src="Images/Editor/Italic.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.Italic %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.UnderlinedTitle %>" class="toolbarbutton" onclick="javascript:return execCmd('Underline',false,null);">
				<img src="Images/Editor/Underlined.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.Underlined %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.StrikedTitle %>" class="toolbarbutton" onclick="javascript:return execCmd('Strikethrough',false,null);">
				<img src="Images/Editor/Striked.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.Striked %>" /></a>
            <a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.H1Title %>" class="toolbarbutton" onclick="javascript:return wrapWithTagClass('h1','separator');">
				<img src="Images/Editor/H1.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.H1 %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.H2Title %>" class="toolbarbutton" onclick="javascript:return wrapWithTagClass('h2','separator');">
				<img src="Images/Editor/H2.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.H2 %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.H3Title %>" class="toolbarbutton" onclick="javascript:return wrapWithTagClass('h3','separator');">
				<img src="Images/Editor/H3.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.H3 %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.H4Title %>" class="toolbarbutton" onclick="javascript:return wrapWithTagClass('h4','separator');">
				<img src="Images/Editor/H4.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.H4 %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.SuperscriptTitle %>" class="toolbarbutton" onclick="javascript:return execCmd('Superscript',false,null);">
				<img src="Images/Editor/Superscript.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.Superscript %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.SubscriptTitle %>" class="toolbarbutton" onclick="javascript:return execCmd('Subscript',false,null);">
				<img src="Images/Editor/Subscript.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.Subscript %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.UnorderedListTitle %>" class="toolbarbutton" onclick="javascript:return insertList('ul');">
				<img src="Images/Editor/UL.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.UnorderedList %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.OrderedListTitle %>" class="toolbarbutton" onclick="javascript:return insertList('ol');">
				<img src="Images/Editor/OL.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.OrderedList %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.PageLinkTitle %>" class="toolbarbutton" onclick="javascript:return OpenPopup('PageLink','WYSIWYG');">
				<img src="Images/Editor/PageLink.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.PageLink %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.FileLinkTitle %>" class="toolbarbutton" onclick="javascript:return OpenPopup('FileLink','WYSIWYG');">
				<img src="Images/Editor/File.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.FileLink %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.ExternalLinkTitle %>" class="toolbarbutton" onclick="javascript:return OpenPopup('ExternalLink','WYSIWYG');">
				<img src="Images/Editor/Link.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.ExternalLink %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.ImageTitle2 %>" class="toolbarbutton" onclick="javascript:return OpenPopup('Image','WYSIWYG');">
				<img src="Images/Editor/Image.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.Image %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.AnchorTitle2 %>" class="toolbarbutton" onclick="javascript:return OpenPopup('Anchor$' + ExtractAnchorsWYSIWYG(),'WYSIWYG');">
				<img src="Images/Editor/Anchor.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.Anchor %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.SnippetsTitle %>" id="SnippetsMenuLinkMarkup" class="toolbarbutton" onclick="javascript:return ShowSnippetsMenuMarkup(event);">
				<img src="Images/Editor/Snippet.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.Snippets %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.SpecialTagsTitle %>" id="SpecialTagsMenuLinkMarkup" class="toolbarbutton" onclick="javascript:return ShowSpecialTagsMenuMarkup(event);">
				<img src="Images/Editor/SpecialTags.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.SpecialTags %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.HRTitle %>" class="toolbarbutton" onclick="javascript:return insertBreak();">
				<img src="Images/Editor/HR.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.HR %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.CodeInlineTitle %>" class="toolbarbutton" onclick="javascript:return wrapWithTag('code');">
				<img src="Images/Editor/Code.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.CodeInline %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.CodeEscapedTitle %>" class="toolbarbutton" onclick="javascript:return wrapWithTag('pre');">
				<img src="Images/Editor/Pre.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.CodeEscaped %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.EscapeTitle %>" class="toolbarbutton" onclick="javascript:return wrapWithTag('esc');">
				<img src="Images/Editor/Escape.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.Escape %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.WrapperBoxTitle %>" class="toolbarbutton" onclick="javascript:return wrapWithTagClass('div', 'box');">
				<img src="Images/Editor/Box.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.WrapperBox %>" /></a>
			<a href="#" title="<%= ScrewTurn.Wiki.Properties.Messages.SymbolsTitle %>" id="SymbolsMenuLinkMarkup" class="toolbarbutton" onclick="javascript:return ShowSymbolsMenuMarkup(event);">
				<img src="Images/Editor/Symbol.png" alt="<%= ScrewTurn.Wiki.Properties.Messages.Symbols %>" /></a>
			</div>
        </div>
        
        <div id="WysiwygDiv">
            <iframe id="iframe" name="iframe" onload="javascript:return iframe_onload();" src="IframeEditor.aspx" style="width: 100%; height: 400px;" frameborder="0"></iframe>
        </div>
        
        <div style="display: none;">
			<anthem:TextBox ID="lblWYSIWYG" runat="server" TextMode="MultiLine" AutoUpdateAfterCallBack="True" meta:resourcekey="lblWYSIWYGResource1" />
		</div>
    </anthem:View>
    
    <anthem:View ID="viwPreview" runat="server">
        
        <div class="toolbar" style="padding-top: 8px; padding-bottom: 0px;">
			<asp:Label ID="lblPreviewWarning" runat="server" CssClass="resulterror" EnableViewState="False"
				Text="&lt;b&gt;Warning&lt;/b&gt;: this is only a preview. The content was not saved." meta:resourcekey="lblPreviewWarningResource3" />
        </div>
    
        <div id="PreviewDiv" style="border: solid 4px #999999; padding: 8px; height: 450px; overflow: auto;">
            <asp:Literal ID="lblPreview" runat="server" EnableViewState="False" meta:resourcekey="lblPreviewResource3" />
        </div>
    </anthem:View>

</anthem:MultiView>

<div id="SnippetsMenuDiv" class="menucontainer" style="display: none;">
	<asp:Label ID="lblSnippets" runat="server" EnableViewState="False" meta:resourcekey="lblSnippetsResource3" />
</div>

<div id="SpecialTagsMenuDiv" class="menucontainer" style="display: none;">
    <asp:Literal ID="lblCustomSpecialTags" runat="server" EnableViewState="false" />
	<a href="#" onclick="javascript:return InsertMarkup('{WIKITITLE}');" class="menulink">{WikiTitle}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{UP}');" class="menulink">{Up}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{TOP}');" class="menulink">{Top}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{TOC}');" class="menulink">{TOC}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{THEMEPATH}');" class="menulink">{ThemePath}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{RSSPAGE}');" class="menulink">{RSSPage}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{WIKIVERSION}');" class="menulink">{WikiVersion}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{MAINURL}');" class="menulink">{MainURL}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{PAGECOUNT}');" class="menulink">{PageCount}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{PAGECOUNT(*)}');" class="menulink">{PageCount(*)}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{USERNAME}');" class="menulink">{Username}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{LOGINLOGOUT}');" class="menulink">{LoginLogout}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{CLEAR}');" class="menulink">{Clear}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{CLOUD}');" class="menulink">{Cloud}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{SEARCHBOX}');" class="menulink">{SearchBox}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{PAGENAME}');" class="menulink">{PageName}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{NAMESPACE}');" class="menulink">{Namespace}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{CATEGORIES}');" class="menulink">{Categories}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{NAMESPACEDROPDOWN}');" class="menulink">{NamespaceDropDown}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{NAMESPACELIST}');" class="menulink">{NamespaceList}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{ORPHANS}');" class="menulink">{Orphans}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{WANTED}');" class="menulink">{Wanted}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{INCOMING}');" class="menulink">{Incoming}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{OUTGOING}');" class="menulink">{Outgoing}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{RECENTCHANGES}');" class="menulink">{RecentChanges}</a>
    <a href="#" onclick="javascript:return InsertMarkup('{RECENTCHANGES(*)}');" class="menulink">{RecentChanges(*)}</a>
</div>

<div id="SymbolsMenuDiv" class="menucontainer" style="display: none;">
	<a href="#" onclick="javascript:return InsertMarkup('&amp;#0123;');" class="menulinkcompact">{</a>
	<a href="#" onclick="javascript:return InsertMarkup('&amp;#0125;');" class="menulinkcompact">}</a>
	<a href="#" onclick="javascript:return InsertMarkup('&amp;#0091;');" class="menulinkcompact">[</a>
	<a href="#" onclick="javascript:return InsertMarkup('&amp;#0093;');" class="menulinkcompact">]</a>
	<a href="#" onclick="javascript:return InsertMarkup('&amp;lt;');" class="menulinkcompact">&lt;</a>
	<a href="#" onclick="javascript:return InsertMarkup('&amp;gt;');" class="menulinkcompact">&gt;</a>
	<a href="#" onclick="javascript:return InsertMarkup('&amp;laquo;');" class="menulinkcompact">&laquo;</a>
	<a href="#" onclick="javascript:return InsertMarkup('&amp;raquo;');" class="menulinkcompact">&raquo;</a>
	<br />
	<!-- More here... -->
</div>

<script type="text/javascript">
<!--

	function OpenPopup(feature, mode) {
		var settings = "center=yes,resizable=yes,dialog,status=no,scrollbars=no,width=300,height=300";
		var w;
		//added for WYSIWYG
		// CurrentPage is escaped in code-behind
		if(mode == 'WYSIWYG')
			w = window.open(CurrentNamespace + "PopupWYSIWYG.aspx?Feature=" + feature + (CurrentPage != "" ? "&CurrentPage=" + CurrentPage : ""), "Popup", settings);
		//end
		else
			w = window.open(CurrentNamespace + "Popup.aspx?Feature=" + feature + (CurrentPage != "" ? "&CurrentPage=" + CurrentPage : ""), "Popup", settings);

		//modify link
		if(feature == 'ExternalLink') {
			if(document.all) {
				var parentSelection = '';
				if(iframe) parentSelection = iframe.document.selection.createRange().parentElement();
				if(parentSelection.tagName == 'A') {
					w.attachEvent('onfocus', function() {
						if(parentSelection.getAttribute('target') == '_blank')
							w.document.getElementById('chkLinkNW').checked = true;
						w.document.getElementById('txtLinkUrl').value = parentSelection.getAttribute('href');
						if(parentSelection.getAttribute('href') != parentSelection.innerHTML)
							w.document.getElementById('txtLinkTitle').value = parentSelection.innerHTML;
					});
				}
			}
			else {
				var parentSelection = '';
				if(iframe) parentSelection = iframe.document.defaultView.getSelection().anchorNode.parentNode;
				if(parentSelection.tagName == 'A') {
					w.addEventListener('load', function() {
						if(parentSelection.getAttribute('target') == '_blank')
							w.document.getElementById('chkLinkNW').checked = true;
						w.document.getElementById('txtLinkUrl').value = parentSelection.getAttribute('href');
						if(parentSelection.getAttribute('href') != parentSelection.innerHTML)
							w.document.getElementById('txtLinkTitle').value = parentSelection.innerHTML;
					}, false);
				}
			}
		}
		if(feature == 'PageLink') {
			if(document.all) {
				var parentSelection = '';
				if(iframe) iframe.document.selection.createRange().parentElement();
				if(parentSelection.tagName == 'A') {
					w.attachEvent('onfocus', function() {
						if(parentSelection.getAttribute('target') == '_blank')
							w.document.getElementById('chkPageNW').checked = true;
						w.document.getElementById('txtPageName').value = parentSelection.getAttribute('href');
						if(parentSelection.getAttribute('href') != parentSelection.innerHTML)
							w.document.getElementById('txtPageTitle').value = parentSelection.innerHTML;
					});
				}
			}
			else {
				var parentSelection = '';
				if(iframe) iframe.document.defaultView.getSelection().anchorNode.parentNode;
				if(parentSelection.tagName == 'A') {
					w.addEventListener('load', function() {
						if(parentSelection.getAttribute('target') == '_blank')
							w.document.getElementById('chkPageNW').checked = true;
						w.document.getElementById('txtPageName').value = parentSelection.getAttribute('href');
						if(parentSelection.getAttribute('href') != parentSelection.innerHTML)
							w.document.getElementById('txtPageTitle').value = parentSelection.innerHTML;
					}, false);
				}
			}
		}
		w.focus();
		return false;
	}

	function AbsolutePosition(obj) {
		var pos = null; 
        if(obj != null) {
			pos = new Object();
            pos.top = obj.offsetTop;
            pos.left = obj.offsetLeft;
            pos.width = obj.offsetWidth;
            pos.height= obj.offsetHeight;
            obj = obj.offsetParent;
            while(obj != null) {
				pos.top += obj.offsetTop;
                pos.left += obj.offsetLeft;
                obj = obj.offsetParent;
            }
        }
        return(pos);
    }
    
    function ExtractAnchors() {
		var markup = new String(document.getElementById(MarkupControl).value);
		markup = markup.toLowerCase();
		var idx = 0;
		var size = 0;
		var result = "";
		while(idx != -1) {
			idx = markup.indexOf("[anchor|#", idx + size);
			size = 9;
			if(idx != -1) {
				var nidx = markup.indexOf("]", idx);
				var name = markup.substring(idx + size, nidx);
				size = 9 + name.length;
				//alert(name);
				result += name + "|";
			}
		}
		//alert(result);
		return result;
    }
    
    function ExtractAnchorsWYSIWYG() {
		var markup = new String(iframe.document.body.innerHTML);
		//alert(markup);
		markup = markup.toLowerCase();
		var idx = 0;
		var size = 0;
		var result = "";
		while(idx != -1) {
			idx = markup.indexOf("<a id=", idx + size);
			//alert(idx);
			size = 7;
			if(idx != -1) {
				var nidx = markup.indexOf(">", idx);
				//alert(nidx);
				//if(markup.indexOf("<", nidx) == (nidx + 2) || markup.indexOf("<", nidx) == (nidx)) {
					//var name = markup.substring(idx + size, nidx - 1);
					var name = markup.substring(idx + size - 1, nidx);
					if(name.indexOf('"') == 0) name = name.substring(1, name.length - 1);
					size = 7 + name.length;
					//alert(name);
					result += name + "|";
				//}
			}
		}
		//alert(result);
		return result;
	}

	// This fires a content copy every time the mouse is pressed
	document.body.onmousedown = CopyWYSIWYGContentToHiddenControl;

	function CopyWYSIWYGContentToHiddenControl() {
		if(inWYSIWYG) {
		//if(window.frames["iframe"] && window.frames["iframe"].document) {
			try {
				document.getElementById(VisualControl).value = iframe.document.body.innerHTML;
			}
			catch(exception) {
				//alert(exception);
			}
		}
		return true;
	}

	function ShowProgress() {
		document.getElementById("ProgressSpan").style["display"] = "";
		
		// added for WYSIWYG
		CopyWYSIWYGContentToHiddenControl();
		// end
	}
	function HideProgress() {
		document.getElementById("ProgressSpan").style["display"] = "none";

		InitES();
	}
	
	function ShowSnippetsMenuMarkup(event) {
		var pos = AbsolutePosition(document.getElementById("SnippetsMenuLinkMarkup"));
		var menu = document.getElementById("SnippetsMenuDiv");
		Display(menu, pos.top + pos.height, pos.left);
		return false;
	}
	
	function ShowSpecialTagsMenuMarkup(event) {
		var pos = AbsolutePosition(document.getElementById("SpecialTagsMenuLinkMarkup"));
		var menu = document.getElementById("SpecialTagsMenuDiv");
		Display(menu, pos.top + pos.height, pos.left);
		return false;
	}
	
	function ShowSymbolsMenuMarkup(event) {
		var pos = AbsolutePosition(document.getElementById("SymbolsMenuLinkMarkup"));
		var menu = document.getElementById("SymbolsMenuDiv");
		Display(menu, pos.top + pos.height, pos.left);
		return false;
	}
	
	function Display(obj, x, y) {
		if(obj.style["display"] == "none") {
			HideAllMenus();
			obj.style["position"] = "absolute";
			obj.style["top"] = x + "px";
			obj.style["left"] = y + "px";
			obj.style["display"] = "";
		}
		else HideAllMenus();
	}
	function Hide(obj) {
		obj.style["display"] = "none";
	}
	
	function HideAllMenus() {
		Hide(document.getElementById("SnippetsMenuDiv"));
		Hide(document.getElementById("SpecialTagsMenuDiv"));
		Hide(document.getElementById("SymbolsMenuDiv"));
		return false;
	}
	
	// Hide all menus when textbox is clicked
	if(document.getElementById(MarkupControl))
		document.getElementById(MarkupControl).onclick = HideAllMenus;
	
	function WrapSelectedMarkup(preTag, postTag) {
		HideAllMenus();
		var objTextArea = document.getElementById(MarkupControl);
        if(objTextArea) {
	        if(document.selection && document.selection.createRange) {
		        objTextArea.focus();
		        var objSelectedTextRange = document.selection.createRange();
		        var strSelectedText = objSelectedTextRange.text;
		        if(strSelectedText.substring(0, preTag.length) == preTag && strSelectedText.substring(strSelectedText.length - postTag.length, strSelectedText.length) == postTag) {
		            objSelectedTextRange.text = strSelectedText.substring(preTag.length, strSelectedText.length - postTag.length);
		        }
		        else {
		            objSelectedTextRange.text = preTag + strSelectedText + postTag;
		        }
	        }
	        else {
	        	objTextArea.focus();
	        	var scrollPos = objTextArea.scrollTop;
	            var selStart = objTextArea.selectionStart;
				var strFirst = objTextArea.value.substring(0, objTextArea.selectionStart);
				var strSelected = objTextArea.value.substring(objTextArea.selectionStart, objTextArea.selectionEnd);
				var strSecond = objTextArea.value.substring(objTextArea.selectionEnd);
				if(strSelected.substring(0, preTag.length) == preTag && strSelected.substring(strSelected.length - postTag.length, strSelected.length) == postTag) {
				    // Remove tags
				    strSelected = strSelected.substring(preTag.length, strSelected.length - postTag.length);
				    objTextArea.value = strFirst + strSelected + strSecond;
				    objTextArea.selectionStart = selStart;
				    objTextArea.selectionEnd = selStart + strSelected.length;
				}
				else {
				    objTextArea.value = strFirst + preTag + strSelected + postTag + strSecond;
				    objTextArea.selectionStart = selStart;
				    objTextArea.selectionEnd = selStart + preTag.length + strSelected.length + postTag.length;
				}
				objTextArea.scrollTop = scrollPos;
	        }
        }
		return false;
	}

	function WrapSelectedMarkupWYSIWYG(preTag, postTag) {
		insertHTML(preTag + getSelectedText() + postTag);
		return false;
	}
	
	function InsertMarkup(tag) {
		HideAllMenus();

		if(document.getElementById(VisualControl)) {
			return InsertMarkupWYSIWYG(tag);
		}
		
		var objTextArea = document.getElementById(MarkupControl);
        if(objTextArea) {
	        if(document.selection && document.selection.createRange) {
		        objTextArea.focus();
		        var objSelectedTextRange = document.selection.createRange();
		        var strSelectedText = objSelectedTextRange.text;
		        objSelectedTextRange.text = tag + strSelectedText;
	        }
	        else {
	        	objTextArea.focus();
	        	var scrollPos = objTextArea.scrollTop;
	            var selStart = objTextArea.selectionStart;
				var strFirst = objTextArea.value.substring(0, objTextArea.selectionStart);
				var strSecond = objTextArea.value.substring(objTextArea.selectionStart);
				objTextArea.value = strFirst + tag + strSecond;
				objTextArea.selectionStart = selStart + tag.length;
				objTextArea.selectionEnd = selStart + tag.length;
				objTextArea.scrollTop = scrollPos;
			}
        }
        return false;
    }

    function InsertMarkupWYSIWYG(tag) {
    	insertHTML(tag);
    	return false;
    }

    function HideToolbarButtons() {
    	// This could be done easily with jQuery...
    	var elem = document.getElementById("MarkupToolbarDiv");
    	if(elem) elem.style["display"] = "none";

    	elem = document.getElementById("VisualToolbarDiv");
    	if(elem) elem.style["display"] = "none";
    }

    InitES();
// -->
</script>

<asp:Literal ID="lblToolbarInit" runat="server" />
