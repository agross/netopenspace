<%@ Page Language="C#" AutoEventWireup="true" Inherits="ScrewTurn.Wiki.ImageEditor" Codebehind="ImageEditor.aspx.cs" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Image Editor</title>
    
    <asp:Literal ID="lblDimensions" runat="server" EnableViewState="False" 
		meta:resourcekey="lblDimensionsResource1" />
    
    <script type="text/javascript">
		<!--
        rdoPercentage_checked = false;
        rdoPixel_checked = false;

        function StartImageEditor() {
        	if(document.getElementById('rdoPixel').checked) {
        		rdoPixel_checked = true;
        		document.getElementById('txtWidth').disabled = '';
        		document.getElementById('txtHeight').disabled = '';
        		document.getElementById('chkAspectRatio').disabled = '';
        	}
        	else if(document.getElementById('rdoPercentage').checked) {
        		rdoPercentage_checked = true;
        		document.getElementById('txtPercentage').disabled = '';
        	}
        }

        function rdoPercentage_Click() {
        	if(rdoPixel_checked) {
        		document.getElementById('rdoPixel').checked = false;
        		rdoPixel_checked = false;
        		document.getElementById('txtWidth').disabled = 'disabled';
        		document.getElementById('txtHeight').disabled = 'disabled';
        		document.getElementById('chkAspectRatio').disabled = 'disabled';
        	}
        	rdoPercentage_checked = true;
        	document.getElementById('txtPercentage').disabled = '';
        }

        function rdoPixel_Click() {
        	if(rdoPercentage_checked) {
        		document.getElementById('rdoPercentage').checked = false;
        		rdoPercentage_checked = false;
        		document.getElementById('txtPercentage').disabled = 'disabled';
        	}
        	rdoPixel_checked = true;
        	document.getElementById('txtWidth').disabled = '';
        	document.getElementById('txtHeight').disabled = '';
        	document.getElementById('chkAspectRatio').disabled = '';
        }

        function WidthChanged() {
        	if(document.getElementById('chkAspectRatio').checked) {
        		resultWidth = document.getElementById('txtWidth').value;
        		document.getElementById('txtHeight').value = Math.floor(resultWidth / width * height);
        	}
        }

        function HeightChanged() {
        	if(document.getElementById('chkAspectRatio').checked) {
        		resultHeight = document.getElementById('txtHeight').value;
        		document.getElementById('txtWidth').value = Math.floor(resultHeight / height * width);
        	}
        }
    // -->
    </script>
    
</head>
<body id="ToolWindowBody">
    <form id="frmImageEditor" runat="server">
        <div id="ImageEditorMainDiv">
        
            <div id="PreviewDiv">
                <asp:Image ID="imgPreview" runat="server" AlternateText="Image Preview" meta:resourcekey="imgPreviewResource1" />
            </div>
            
            <div id="ResizeOptionsDiv">
                <h3 class="separator"><asp:Label ID="lblOptions" runat="server" Text="Image Resize Options" meta:resourcekey="lblOptionsResource1" /></h3>
                
                <div id="CurrentSizeDiv">
					<asp:Literal ID="lblCurrentSizeInfo" runat="server" Text="Current size: " EnableViewState="False" meta:resourcekey="lblCurrentSizeInfoResource1" />
					<asp:Literal ID="lblCurrentSize" runat="server" EnableViewState="False" meta:resourcekey="lblCurrentSizeResource1" />
					<asp:Literal ID="lblCurrentSizePixels" runat="server" Text=" pixels" meta:resourcekey="lblCurrentSizePixelsResource1" />
				</div>
				               
                <asp:RadioButton ID="rdoPercentage" runat="server" Text="Resize by scale " onclick="rdoPercentage_Click();" GroupName="method" meta:resourcekey="rdoPercentageResource2" />
                <div id="PercentageDiv">
					<asp:TextBox ID="txtPercentage" runat="server" Enabled="False" Text="100" ToolTip="Resize scale (percentage)" meta:resourcekey="txtPercentageResource2" /> %
                </div>
                
                <div id="PixelDiv">
					<asp:RadioButton ID="rdoPixel" runat="server" Text="Resize by absolute size" onclick="rdoPixel_Click();" GroupName="method" meta:resourcekey="rdoPixelResource2" />
					<div id="PixelSizeDiv">
						<asp:TextBox ID="txtWidth" runat="server" Enabled="False" ToolTip="Width" onkeyup="WidthChanged();" meta:resourcekey="txtWidthResource1" />
						x
						<asp:TextBox ID="txtHeight" runat="server" Enabled="False" ToolTip="Height" onkeyup="HeightChanged();" meta:resourcekey="txtHeightResource1" />
						<asp:Literal ID="lblSizePixels" runat="server" Text=" pixels" meta:resourcekey="lblSizePixelsResource1" />
						<br />
	                    
	                    <span style="display: none">
							<asp:CheckBox ID="chkAspectRatio" runat="server" Text="Maintain Aspect Ratio" Enabled="False" Checked="True" meta:resourcekey="chkAspectRatioResource1" />
						</span>
					</div>
                </div>
                
                <div id="RotateDiv">
					<asp:Literal ID="lblRotate" runat="server" Text="Rotation" EnableViewState="false" meta:resourcekey="lblRotateResource1" /><br />
					<asp:RadioButton ID="rdoNoRotation" runat="server" Text="None" GroupName="rotation" Checked="true" /><br />
					<asp:RadioButton ID="rdo90CW" runat="server" Text="90° Clockwise" GroupName="rotation" /><br />
					<asp:RadioButton ID="rdo90CCW" runat="server" Text="90° Counter-Clockwise" GroupName="rotation" /><br />
					<asp:RadioButton ID="rdo180" runat="server" Text="180°" GroupName="rotation" />
                </div>
                
				<div id="PreviewLinkDiv">
                    <asp:LinkButton ID="btnPreview" runat="server" Text="Update Preview" OnClick="btnPreview_Click" meta:resourcekey="btnPreviewResource1" />
                    <asp:Label ID="lblScalePre" runat="server" Text="(Scale: " EnableViewState="False" meta:resourcekey="lblScalePreResource1" />
                    <anthem:Label ID="lblScale" runat="server" AutoUpdateAfterCallBack="true" meta:resourcekey="lblScaleResource1"
                    /><asp:Label
						ID="lblScalePost" runat="server" Text="%)" EnableViewState="False" meta:resourcekey="lblScalePostResource1" />
                </div>
            </div>
            
            <div id="MainSaveDiv">
				<div id="ResultDiv">
					<asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" ToolTip="Save the modified Image" meta:resourcekey="btnSaveResource1" />
					<asp:Button ID="btnCancel" runat="server" Text="Close" OnClientClick="javascript:window.close();" ToolTip="Close this toolbox" meta:resourcekey="btnCancelResource2" />
					<br />
					<asp:Label ID="lblResult" runat="server" meta:resourcekey="lblResultResource1" />
				</div>
				<div id="SaveDiv">
					<anthem:CheckBox ID="chkNewName" runat="server" Text="Save as new file" ToolTip="If not selected, the original file is overwritten"
						Checked="True" AutoCallBack="True" OnCheckedChanged="chkNewName_CheckedChanged" meta:resourcekey="chkNewNameResource2" /><br />
					<anthem:TextBox ID="txtNewName" runat="server" Width="224px" 
						AutoUpdateAfterCallBack="True" meta:resourcekey="txtNewNameResource1" UpdateAfterCallBack="True" /><br />
					<anthem:RadioButton ID="rdoPng" runat="server" Text="PNG" ToolTip="PNG format (alpha channel is preserved)" AutoUpdateAfterCallBack="True"
						AutoCallBack="True" GroupName="format" OnCheckedChanged="rdoFormat_CheckedChanged" meta:resourcekey="rdoPngResource2" UpdateAfterCallBack="True" />
					<anthem:RadioButton ID="rdoJpegHigh" runat="server" Text="JPEG 100%" ToolTip="JPEG format, full quality" AutoUpdateAfterCallBack="True"
						AutoCallBack="True" GroupName="format" OnCheckedChanged="rdoFormat_CheckedChanged" meta:resourcekey="rdoJpegHighResource2" UpdateAfterCallBack="True" />
					<anthem:RadioButton ID="rdoJpegMedium" runat="server" Text="JPEG 60%" ToolTip="JPEG format, medium quality" AutoUpdateAfterCallBack="True"
						AutoCallBack="True" GroupName="format" OnCheckedChanged="rdoFormat_CheckedChanged" meta:resourcekey="rdoJpegMediumResource2" UpdateAfterCallBack="True" />
                </div>
            </div>
            
        </div>
    </form>
    
    <script type="text/javascript">
    <!--
    	StartImageEditor();
    // -->
    </script>
    
</body>
</html>
