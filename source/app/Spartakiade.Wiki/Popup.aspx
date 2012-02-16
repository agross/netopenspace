<%@ Page Language="C#" AutoEventWireup="true" Inherits="ScrewTurn.Wiki.Popup" meta:resourcekey="PageResource1" Codebehind="Popup.aspx.cs" culture="auto" uiculture="auto" %>

<%@ Register TagName="ClientTree" TagPrefix="st" Src="~/ClientTree.ascx" %>
<%@ Register TagName="ClientImageBrowser" TagPrefix="st" Src="~/ClientImageBrowser.ascx" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html dir="<%= ScrewTurn.Wiki.Settings.Direction %>" xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
	<title runat="server">ScrewTurn Wiki</title>
	<link rel="stylesheet" type="text/css" href="Themes/Editor.css" />
	
	<script type="text/javascript">
	<!--
		function Execute(code) {
			window.opener.eval(code);
			window.close();
			return false;
		}

		function ProcessPageLink() {
			var name = GetValue("txtPageName");
			if(name == "") return false;
			var title = GetValue("txtPageTitle");
			var c = IsChecked("chkPageNW") ? "^" : "";
			if(title != "") {
				Execute("InsertMarkup(\"[" + c + name + "|" + title + "]\");");
			}
			else {
				Execute("InsertMarkup(\"[" + c + name + "]\");");
			}
			window.close();
			return false;
		}
		
		function ProcessFileLink() {
			var name = GetValue("txtFilePath");
			name = name.replace(/\\/g, '\\\\');
			if(name == "") return false;
			var title = GetValue("txtFileTitle");
			var c = IsChecked("chkFileNW") ? "^" : "";
			if(title != "") {
				Execute("InsertMarkup(\"[" + c + name + "|" + title + "]\");");
			}
			else {
				Execute("InsertMarkup(\"[" + c + name + "]\");");
			}
			window.close();
			return false;
		}
		
		function SelectFile(prov, value) {
			SetValue("txtFilePath", "{UP" + prov + "}" + value);
		}
		
		function ProcessExternalLink() {
			var url = GetValue("txtLinkUrl");
			if(url == "") return false;
			var title = GetValue("txtLinkTitle");
			var c = IsChecked("chkLinkNW") ? "^" : "";
			if(title != "") {
				Execute("InsertMarkup(\"[" + c + url + "|" + title + "]\");");
			}
			else {
				Execute("InsertMarkup(\"[" + c + url + "]\");");
			}
			window.close();
			return false;
		}
		
		function ProcessImage() {
			var name = GetValue("txtImagePath");
			if(name == "") return false;
			var link = GetValue("txtImageLink");
			var descr = GetValue("txtImageDescr");
			var c = IsChecked("chkImageNW") ? "^" : "";
			var imageType = GetImageType();
			if(link != "") {
				Execute("InsertMarkup(\"[" + imageType + "|" + descr + "|" + name + "|" + c + link + "]\");");
			}
			else {
				Execute("InsertMarkup(\"[" + imageType + "|" + descr + "|" + name + "]\");");
			}
		}
		
		function GetImageType() {
			if(IsChecked("rdoImageLeft")) return "imageleft";
			if(IsChecked("rdoImageRight")) return "imageright";
			if(IsChecked("rdoImageAuto")) return "imageauto";
			if(IsChecked("rdoImageInline")) return "image";
			return "";
		}
		
		function SelectImage(prov, value, page) {
			document.getElementById("PreviewImg").src = "Thumb.aspx?Provider=" + GetValue("lstProviderImages") +
				"&File=" + value + "&Size=Big&Info=1&Page=" + page;
			if(IsChecked("rdoImageLink")) {
				SetValue("txtImageLink", "{UP" + prov + "}" + value);
				ImageLinkFromBrowser = 1;
			}
			else {
				SetValue("txtImagePath", "{UP" + prov + "}" + value);
			}
			return false;
		}
		
		function ProcessAnchor() {
			var link = IsChecked("rdoAnchorLink");
			if(link) {
				var id = GetValue("lstExistingAnchors");
				if(id == "") return false;
				var title = GetValue("txtAnchorTitle");
				Execute("InsertMarkup(\"[#" + id + (title != "" ? "|" + title : "") + "]\");");
			}
			else {
				var id = GetValue("txtAnchorID");
				if(id == "") return false;
				id = id.replace(/#/g, "");
				Execute("InsertMarkup(\"[anchor|#" + id + "]\");");
			}
			return false;
			window.close();
		}
		
		function SetValue(targetId, value) {
			document.getElementById(targetId).value = value;
		}
		
		function GetValue(targetId) {
			return document.getElementById(targetId).value;
		}
		
		function IsChecked(targetId) {
			return document.getElementById(targetId).checked;
		}
		
		function CancelAll() {
			window.close();
			return false;
		}
	// -->
	</script>
</head>
<body id="ToolWindowBody">
	<form id="frmPopup" runat="server">
		<div id="MainPopupDiv">
		
			<asp:Literal ID="lblStrings" runat="server" meta:resourcekey="lblStringsResource1" />
			
			<asp:MultiView ID="mlvPopup" runat="server">
			
				<asp:View ID="viwPageLink" runat="server">
					
					<asp:DropDownList ID="lstNamespace" runat="server" AutoPostBack="true" Width="270px" OnSelectedIndexChanged="lstNamespace_SelectedIndexChanged" />
				
					<div id="ClientTreePagesDiv">
					
						<st:ClientTree ID="ctPages" runat="server" OnPopulate="ctPages_Populate" EnableViewState="False"
							LeafCssClass="menulink" NodeCssClass="menulink" ContainerCssClass="subtree" />
					</div>
					
					<asp:Literal ID="lblPageName" runat="server" Text="Page Name (required)" EnableViewState="False" meta:resourcekey="lblPageNameResource1" /><br />
					<asp:TextBox ID="txtPageName" runat="server" Width="264px" meta:resourcekey="txtPageNameResource1" /><br />
					<asp:Literal ID="lblPageTitle" runat="server" Text="Link Title (optional)" EnableViewState="False" meta:resourcekey="lblPageTitleResource1" /><br />
					<asp:TextBox ID="txtPageTitle" runat="server" Width="264px" meta:resourcekey="txtPageTitleResource1" /><br />
					<asp:CheckBox ID="chkPageNW" runat="server" Text="Open link in new window" EnableViewState="False" meta:resourcekey="chkPageNWResource1" />
					
					<div class="popupbuttons">
						<asp:Button ID="btnOkPageLink" runat="server" Text="OK" EnableViewState="False" meta:resourcekey="btnOkPageLinkResource1" />
						<asp:Button ID="btnCancelPageLink" runat="server" Text="Cancel" EnableViewState="False" meta:resourcekey="btnCancelPageLinkResource1" />
					</div>
					
					<script type="text/javascript">
					<!--
						document.getElementById("btnOkPageLink").onclick = ProcessPageLink;
						document.getElementById("btnCancelPageLink").onclick = CancelAll;

						$(function () {
							$("#<%= txtPageName.ClientID %>").keyup(function () {
								var value = $("#<%= txtPageName.ClientID %>").val().toLowerCase();
								$("div.treecontainer a.menulink").each(function () {
									var elem = $(this);
									var txt = elem.attr("title");
									txt = txt.substring(txt.indexOf(".") + 1);
									value = value.replace(/_/g, '-');
									var match = txt.toLowerCase().indexOf(value) != -1;
									elem.css("display", match ? "" : "none");
								});
							});
							$("#<%= txtPageTitle.ClientID %>").keyup(function () {
								var value = $("#<%= txtPageTitle.ClientID %>").val().toLowerCase();
								$("div.treecontainer a.menulink").each(function () {
									var elem = $(this);
									value = value.replace(/_/g, '-');
									var match = elem.text().toLowerCase().indexOf(value) != -1;
									elem.css("display", match ? "" : "none");
								});
							});
						});
					// -->
					</script>
				
				</asp:View>
				
				<asp:View ID="viwFileLink" runat="server">
				
					<asp:DropDownList ID="lstProviderFiles" runat="server"
						AutoPostBack="True" OnSelectedIndexChanged="lstProviderFiles_SelectedIndexChanged" meta:resourcekey="lstProviderFilesResource1" /><br />
					<asp:CheckBox ID="chkFilesAttachments" runat="server" Text="Browse Page Attachments"
						AutoPostBack="True" OnCheckedChanged="chkFilesAttachments_CheckedChanged" meta:resourcekey="chkFilesAttachmentsResource1" />
					<br /><br />
							
					<div id="ClientTreeFilesDiv">
						
						<st:ClientTree ID="ctFiles" runat="server" OnPopulate="ctFiles_Populate" EnableViewState="False"
							LeafCssClass="menulink menulinkfile" NodeCssClass="menulink menulinkdirectory" ContainerCssClass="subtree" />
					</div>
					
					<asp:Literal ID="lblFilePath" runat="server" Text="File Path (required)" EnableViewState="False" meta:resourcekey="lblFilePathResource1" /><br />
					<asp:TextBox ID="txtFilePath" runat="server" Width="264px" meta:resourcekey="txtFilePathResource1" /><br />
					<asp:Literal ID="lblFileTitle" runat="server" Text="Link Title (optional)" EnableViewState="False" meta:resourcekey="lblFileTitleResource1" /><br />
					<asp:TextBox ID="txtFileTitle" runat="server" Width="264px" meta:resourcekey="txtFileTitleResource1" /><br />
					<asp:CheckBox ID="chkFileNW" runat="server" Text="Open link in new window" EnableViewState="False" meta:resourcekey="chkFileNWResource1" />
					
					<div class="popupbuttons">
						<asp:Button ID="btnOkFileLink" runat="server" Text="OK" EnableViewState="False" meta:resourcekey="btnOkFileLinkResource1" />
						<asp:Button ID="btnCancelFileLink" runat="server" Text="Cancel" EnableViewState="False" meta:resourcekey="btnCancelFileLinkResource1" />
					</div>
					
					<script type="text/javascript">
					<!--
						document.getElementById("btnOkFileLink").onclick = ProcessFileLink;
						document.getElementById("btnCancelFileLink").onclick = CancelAll;
					// -->
					</script>
					
				</asp:View>
				
				<asp:View ID="viwExternalLink" runat="server">
				
					<asp:Literal ID="lblLinkUrl" runat="server" Text="Link URL or Email address (required)" EnableViewState="False" meta:resourcekey="lblLinkUrlResource1" /><br />
					<asp:TextBox ID="txtLinkUrl" runat="server" Width="270px" meta:resourcekey="txtLinkUrlResource1" /><br />
					<asp:Literal ID="lblLinkTitle" runat="server" Text="Link Title (optional)" EnableViewState="False" meta:resourcekey="lblLinkTitleResource1" /><br />
					<asp:TextBox ID="txtLinkTitle" runat="server" Width="270px" meta:resourcekey="txtLinkTitleResource1" /><br />
					<asp:CheckBox ID="chkLinkNW" runat="server" Text="Open link in new window" EnableViewState="False" meta:resourcekey="chkLinkNWResource1" />
					
					<div class="popupbuttons">
						<asp:Button ID="btnOkLink" runat="server" Text="OK" EnableViewState="False" meta:resourcekey="btnOkLinkResource1" />
						<asp:Button ID="btnCancelLink" runat="server" Text="Cancel" EnableViewState="False" meta:resourcekey="btnCancelLinkResource1" />
					</div>
					
					<script type="text/javascript">
					<!--
						document.getElementById("btnOkLink").onclick = ProcessExternalLink;
						document.getElementById("btnCancelLink").onclick = CancelAll;
					// -->
					</script>
				
				</asp:View>
				
				<asp:View ID="viwImage" runat="server">
				
					<asp:DropDownList ID="lstProviderImages" runat="server"
						AutoPostBack="True" OnSelectedIndexChanged="lstProviderImages_SelectedIndexChanged" meta:resourcekey="lstProviderImagesResource1" />
					<asp:CheckBox ID="chkImageAttachments" runat="server" Text="Browse Page Attachments"
						AutoPostBack="True" OnCheckedChanged="chkImageAttachments_CheckedChanged" meta:resourcekey="chkImageAttachmentsResource1" />
				
					<table id="ImageBrowserTable">
						<tr>
							<td>
									
								<div id="ClientImageBrowserDiv">
								
									<st:ClientImageBrowser ID="cibImages" runat="server" OnPopulate="cibImages_Populate" EnableViewState="False"
										LeafCssClass="imageitem"
										NodeCssClass="folderitem" NodeContent='<img src="Images/Editor/Folder.png" alt="Up" /><br />'
										UpCssClass="upitem" UpLevelContent='<img src="Images/Editor/FolderUp.png" alt="Up" /><br />' />
								</div>
							
							</td>
							
							<td>
							
								<div id="ImagePreviewDiv">
									<img src="Images/Editor/Preview.png" id="PreviewImg" alt="Preview" />
								</div>
							
							</td>
						</tr>
						
					</table>
					
					<table id="ImageControlsTable">
						<tr>
							<td>
								<asp:Literal ID="lblImagePath" runat="server" Text="Image Path/URL (required)" EnableViewState="False" meta:resourcekey="lblImagePathResource1" /><br />
								<asp:TextBox ID="txtImagePath" runat="server" Width="350px" meta:resourcekey="txtImagePathResource1" />
								<asp:RadioButton ID="rdoImagePath" runat="server" ToolTip="Check this to select the image using the browser" GroupName="do_not_translate_image" Checked="True" meta:resourcekey="rdoImagePathResource1" /><br />
								<asp:Literal ID="lblImageLink" runat="server" Text="Link (optional)" EnableViewState="False" meta:resourcekey="lblImageLinkResource1" /><br />
								<asp:TextBox ID="txtImageLink" runat="server" Width="350px" meta:resourcekey="txtImageLinkResource1" />
								<asp:RadioButton ID="rdoImageLink" runat="server" ToolTip="Check this to select the linked image using the browser" GroupName="do_not_translate_image" meta:resourcekey="rdoImageLinkResource1" /><br />
								<asp:Literal ID="lblImageDescr" runat="server" Text="Description (optional)" EnableViewState="False" meta:resourcekey="lblImageDescrResource1" /><br />
								<asp:TextBox ID="txtImageDescr" runat="server" Width="350px" meta:resourcekey="txtImageDescrResource1" /><br />
								<asp:CheckBox ID="chkImageNW" runat="server" Text="Open link in new window" EnableViewState="False" meta:resourcekey="chkImageNWResource1" />
							</td>
							
							<td>
								<asp:RadioButton ID="rdoImageLeft" runat="server" Text="Align Left" GroupName="do_not_translate_align" Checked="True" meta:resourcekey="rdoImageLeftResource1" /><br />
								<asp:RadioButton ID="rdoImageRight" runat="server" Text="Align Right" GroupName="do_not_translate_align" meta:resourcekey="rdoImageRightResource1" /><br />
								<asp:RadioButton ID="rdoImageAuto" runat="server" Text="Auto" GroupName="do_not_translate_align" meta:resourcekey="rdoImageAutoResource1" /><br />
								<asp:RadioButton ID="rdoImageInline" runat="server" Text="Inline" GroupName="do_not_translate_align" meta:resourcekey="rdoImageInlineResource1" /><br />
								<asp:Button ID="btnOkImage" runat="server" Text="OK" EnableViewState="False" meta:resourcekey="btnOkImageResource1" />
								<asp:Button ID="btnCancelImage" runat="server" Text="Cancel" EnableViewState="False" meta:resourcekey="btnCancelImageResource1" />
							</td>
						</tr>
					</table>
					
					<script type="text/javascript">
					<!--
						document.getElementById("btnOkImage").onclick = ProcessImage;
						document.getElementById("btnCancelImage").onclick = CancelAll;
						document.getElementById("txtImagePath").onclick = function() {
							document.getElementById("rdoImagePath").checked = true;
						};
						document.getElementById("txtImageLink").onclick = function() {
							document.getElementById("rdoImageLink").checked = true;
						};
					// -->
					</script>
				
				</asp:View>
				
				<asp:View ID="viwAnchor" runat="server">
				
					<asp:Literal ID="lblInsertAnchor" runat="server" Text="Insert:" EnableViewState="False" meta:resourcekey="lblInsertAnchorResource1" /><br />
					<asp:RadioButton ID="rdoNewAnchor" runat="server" Checked="True" Text="New Anchor"
						AutoPostBack="True" OnCheckedChanged="rdoAnchor_CheckedChanged" GroupName="do_not_translate_anchor" meta:resourcekey="rdoNewAnchorResource1" /><br />
					<asp:RadioButton ID="rdoAnchorLink" runat="server" Text="Link to an existing Anchor"
						AutoPostBack="True" OnCheckedChanged="rdoAnchor_CheckedChanged" GroupName="do_not_translate_anchor" meta:resourcekey="rdoAnchorLinkResource1" />
					
					<br /><br />
					
					<asp:Panel ID="pnlNewAnchor" runat="server" meta:resourcekey="pnlNewAnchorResource1">
						<asp:Literal ID="lblAnchorID" runat="server" Text="Anchor ID (required)" EnableViewState="False" meta:resourcekey="lblAnchorIDResource1" /><br />
						<asp:TextBox ID="txtAnchorID" runat="server" Width="270px" meta:resourcekey="txtAnchorIDResource1" />
					</asp:Panel>
					
					<asp:Panel ID="pnlAnchorLink" runat="server" Visible="False" meta:resourcekey="pnlAnchorLinkResource1">
						<asp:Literal ID="lblExistingAnchors" runat="server" Text="Link to:" EnableViewState="False" meta:resourcekey="lblExistingAnchorsResource1" /><br />
						<asp:DropDownList ID="lstExistingAnchors" runat="server" meta:resourcekey="lstExistingAnchorsResource1" /><br />
						<asp:Literal ID="lblAnchorTitle" runat="server" Text="Link Title (optional)" EnableViewState="False" meta:resourcekey="lblAnchorTitleResource1" /><br />
						<asp:TextBox ID="txtAnchorTitle" runat="server" Width="270px" meta:resourcekey="txtAnchorTitleResource1" />
					</asp:Panel>
					
					<div class="popupbuttons">
						<asp:Button ID="btnOkAnchor" runat="server" Text="OK" EnableViewState="False" meta:resourcekey="btnOkAnchorResource1" />
						<asp:Button ID="btnCancelAnchor" runat="server" Text="Cancel" EnableViewState="False" meta:resourcekey="btnCancelAnchorResource1" />
					</div>
					
					<script type="text/javascript">
					<!--
						document.getElementById("btnOkAnchor").onclick = ProcessAnchor;
						document.getElementById("btnCancelAnchor").onclick = CancelAll;
					// -->
					</script>
				
				</asp:View>
			
			</asp:MultiView>
			
		</div>
	</form>
</body>
</html>
