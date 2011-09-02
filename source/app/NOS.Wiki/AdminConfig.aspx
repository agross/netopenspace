<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeBehind="AdminConfig.aspx.cs" Inherits="ScrewTurn.Wiki.AdminConfig" culture="auto" meta:resourcekey="PageResource2" uiculture="auto" %>

<asp:Content ID="ctnHead" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="ctnConfig" ContentPlaceHolderID="cphAdmin" runat="server">
	<asp:Literal ID="lblStrings" runat="server" EnableViewState="False" meta:resourcekey="lblStringsResource1" />

	<script type="text/javascript">
	<!--
		function __SelectDateTimeFormat() {
			var value = document.getElementById("dtSelector").value;
			document.getElementById(__DateTimeFormatTextBox).value = value;
			document.getElementById("dtSelector").value = "-";
		}
	// -->
	</script>

	<h2 class="sectiontitle"><asp:Literal ID="lblConfig" runat="server" Text="Configuration" meta:resourcekey="lblConfigResource1" /></h2>
	
	<div id="ConfigGeneralDiv">
		<div class="featurecontainer">
			<h3 class="separator"><asp:Literal ID="lblGeneralConfig" runat="server" Text="General Configuration" EnableViewState="False" meta:resourcekey="lblGeneralConfigResource1" /></h3>
		</div>
	
		<div class="featurecontainer">
			<asp:Literal ID="lblWikiTitle" runat="server" Text="Wiki title" 
				EnableViewState="False" meta:resourcekey="lblWikiTitleResource1" /><br />
			<anthem:TextBox ID="txtWikiTitle" runat="server" CssClass="configlarge" 
				meta:resourcekey="txtWikiTitleResource1" />
			
			<anthem:RequiredFieldValidator ID="rfvWikiTitle" runat="server" 
				Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtWikiTitle" ErrorMessage="Wiki Title is required" 
				AutoUpdateAfterCallBack="True" meta:resourcekey="rfvWikiTitleResource1" 
				UpdateAfterCallBack="True" />
			<anthem:RegularExpressionValidator ID="revWikiTitle" runat="server" 
				Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtWikiTitle" ErrorMessage="Invalid Wiki Title" 
				AutoUpdateAfterCallBack="True" meta:resourcekey="revWikiTitleResource1" 
				UpdateAfterCallBack="True" />
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblWikiUrl" runat="server" Text="Wiki URL" 
				EnableViewState="False" meta:resourcekey="lblWikiUrlResource1" />
			<span class="smalllabel">(<asp:Literal ID="lblUsedForEmailCommunications" 
				runat="server" Text="used for email communications and redirects" EnableViewState="False" 
				meta:resourcekey="lblUsedForEmailCommunicationsResource1" /> - 
			<anthem:LinkButton ID="btnAutoWikiUrl" runat="server" Text="autodetect" 
				CausesValidation="False" OnClick="btnAutoWikiUrl_Click" 
				meta:resourcekey="btnAutoWikiUrlResource1" />)</span><br />
			<anthem:TextBox ID="txtMainUrl" runat="server" CssClass="configlarge" 
				AutoUpdateAfterCallBack="True" meta:resourcekey="txtMainUrlResource1" 
				UpdateAfterCallBack="True" />
			
			<anthem:RequiredFieldValidator ID="rfvMainUrl" runat="server" Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtMainUrl" ErrorMessage="Wiki URL is required" 
				AutoUpdateAfterCallBack="True" meta:resourcekey="rfvMainUrlResource1" 
				UpdateAfterCallBack="True" />
			<anthem:RegularExpressionValidator ID="revMainUrl" runat="server" 
				Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtMainUrl" ErrorMessage="Invalid Wiki URL" 
				AutoUpdateAfterCallBack="True" meta:resourcekey="revMainUrlResource1" 
				UpdateAfterCallBack="True" />
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblContactEmail" runat="server" Text="Contact email" 
				EnableViewState="False" meta:resourcekey="lblContactEmailResource1" /><br />
			<anthem:TextBox ID="txtContactEmail" runat="server" CssClass="configmedium" 
				meta:resourcekey="txtContactEmailResource1" />
			
			<anthem:RequiredFieldValidator ID="rfvContactEmail" runat="server" 
				Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtContactEmail" ErrorMessage="Contact Email is required" 
				AutoUpdateAfterCallBack="True" meta:resourcekey="rfvContactEmailResource1" 
				UpdateAfterCallBack="True" />
			<anthem:RegularExpressionValidator ID="revContactEmail" runat="server" 
				Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtContactEmail" ErrorMessage="Invalid email address" 
				AutoUpdateAfterCallBack="True" meta:resourcekey="revContactEmailResource1" 
				UpdateAfterCallBack="True" />
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblSenderEmail" runat="server" Text="Sender email" 
				EnableViewState="False" meta:resourcekey="lblSenderEmailResource1" /><br />
			<anthem:TextBox ID="txtSenderEmail" runat="server" CssClass="configmedium" 
				meta:resourcekey="txtSenderEmailResource1" />
			
			<anthem:RequiredFieldValidator ID="rfvSenderEmail" runat="server" 
				Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtSenderEmail" ErrorMessage="Sender Email is required" 
				AutoUpdateAfterCallBack="True" meta:resourcekey="rfvSenderEmailResource1" 
				UpdateAfterCallBack="True" />
			<anthem:RegularExpressionValidator ID="revSenderEmail" runat="server" 
				Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtSenderEmail" ErrorMessage="Invalid email address" 
				AutoUpdateAfterCallBack="True" meta:resourcekey="revSenderEmailResource1" 
				UpdateAfterCallBack="True" />
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblErrorsEmails" runat="server" 
				Text="Email addresses to notify in case of errors (separate with commas)" 
				EnableViewState="False" meta:resourcekey="lblErrorsEmailsResource1" /><br />
			<anthem:TextBox ID="txtErrorsEmails" runat="server" CssClass="configlarge" 
				meta:resourcekey="txtErrorsEmailsResource1" />
			
			<anthem:CustomValidator ID="cvErrorsEmails" runat="server" Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtErrorsEmails" ErrorMessage="Invalid email address" AutoUpdateAfterCallBack="True"
				OnServerValidate="cvErrorsEmails_ServerValidate" 
				meta:resourcekey="cvErrorsEmailsResource1" UpdateAfterCallBack="True" />
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblSmtpServer" runat="server" 
				Text="SMTP server address and port" EnableViewState="False" 
				meta:resourcekey="lblSmtpServerResource1" /><br />
			<anthem:TextBox ID="txtSmtpServer" runat="server" CssClass="configmedium" 
				meta:resourcekey="txtSmtpServerResource1" />
			<anthem:TextBox ID="txtSmtpPort" runat="server" CssClass="configsmallest" 
				meta:resourcekey="txtSmtpPortResource1" />
			
			<anthem:RequiredFieldValidator ID="rfvSmtpServer" runat="server" 
				Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtSmtpServer" ErrorMessage="SMTP Server is required" 
				AutoUpdateAfterCallBack="True" meta:resourcekey="rfvSmtpServerResource1" 
				UpdateAfterCallBack="True" />
			<anthem:RegularExpressionValidator ID="revSmtpServer" runat="server" 
				Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtSmtpServer" ErrorMessage="Invalid SMTP Server address" 
				AutoUpdateAfterCallBack="True" meta:resourcekey="revSmtpServerResource1" 
				UpdateAfterCallBack="True" />
			<anthem:RangeValidator ID="rvSmtpPort" runat="server" Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtSmtpPort" ErrorMessage="Invalid Port (min. 1, max. 65535)"
				Type="Integer" MinimumValue="1" MaximumValue="65535" AutoUpdateAfterCallBack="True" 
				meta:resourcekey="rvSmtpPortResource1" UpdateAfterCallBack="True" />
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblSmtpAuthentication" runat="server" 
				Text="SMTP username and password" EnableViewState="False" 
				meta:resourcekey="lblSmtpAuthenticationResource1" /><br />
			<anthem:TextBox ID="txtUsername" runat="server" CssClass="configsmall" 
				meta:resourcekey="txtUsernameResource1" />
			<anthem:TextBox ID="txtPassword" runat="server" TextMode="Password" 
				CssClass="configsmall" meta:resourcekey="txtPasswordResource1" />
			<anthem:CheckBox ID="chkEnableSslForSmtp" runat="server" Text="Enable SSL" 
				meta:resourcekey="chkEnableSslForSmtpResource1" />
			
			<anthem:CustomValidator ID="cvUsername" runat="server" Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtUsername" ErrorMessage="Password is required" AutoUpdateAfterCallBack="True"
				OnServerValidate="cvUsername_ServerValidate" ValidateEmptyText="True" 
				meta:resourcekey="cvUsernameResource1" UpdateAfterCallBack="True" />
			<anthem:CustomValidator ID="cvPassword" runat="server" Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtUsername" ErrorMessage="Username is required" AutoUpdateAfterCallBack="True"
				OnServerValidate="cvPassword_ServerValidate" ValidateEmptyText="True" 
				meta:resourcekey="cvPasswordResource1" UpdateAfterCallBack="True" />
		</div>
	</div>
	
	<div id="ConfigContentDiv">
		<div class="featurecontainer">
			<h3 class="separator"><asp:Literal ID="lblContentConfig" runat="server" 
					Text="Content Configuration" EnableViewState="False" 
					meta:resourcekey="lblContentConfigResource1" /></h3>
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblRootTheme" runat="server" Text="Root namespace theme" 
				EnableViewState="False" meta:resourcekey="lblRootThemeResource1" />
			<span class="smalllabel">(<asp:Literal ID="lblSeeAlsoNamespaces1" 
				runat="server" Text="see also" EnableViewState="False" 
				meta:resourcekey="lblSeeAlsoNamespaces1Resource1" />
			<a href="AdminNamespaces.aspx" class="smalllabel">
			<asp:Literal ID="lblNamespaces1" runat="server" Text="Namespaces" 
				EnableViewState="False" meta:resourcekey="lblNamespaces1Resource1" /></a>)</span><br />
			<anthem:DropDownList ID="lstRootTheme" runat="server" CssClass="configmedium" 
				meta:resourcekey="lstRootThemeResource1" />
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblRootMainPage" runat="server" 
				Text="Root namespace main page" EnableViewState="False" 
				meta:resourcekey="lblRootMainPageResource1" />
			<span class="smalllabel">(<asp:Literal ID="lblSeeAlsoNamespaces2" 
				runat="server" Text="see also" EnableViewState="False" 
				meta:resourcekey="lblSeeAlsoNamespaces2Resource1" />
			<a href="AdminNamespaces.aspx" class="smalllabel">
			<asp:Literal ID="lblNamespaces2" runat="server" Text="Namespaces" 
				EnableViewState="False" meta:resourcekey="lblNamespaces2Resource1" /></a>)</span><br />
			<anthem:DropDownList ID="lstMainPage" runat="server" CssClass="configmedium" 
				meta:resourcekey="lstMainPageResource1" />
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblDateTimeFormat" runat="server" Text="Date/time format" 
				EnableViewState="False" meta:resourcekey="lblDateTimeFormatResource1" /><br />
			<anthem:TextBox ID="txtDateTimeFormat" runat="server" CssClass="configmedium" 
				meta:resourcekey="txtDateTimeFormatResource1" />
			<select id="dtSelector" class="configsmall" onchange="javascript:return __SelectDateTimeFormat();">
				<option value="-"><asp:Literal ID="lblSelectFormat" runat="server" Text="Select..." 
						meta:resourcekey="lblSelectFormatResource1" /></option>
				<asp:Literal ID="lblDateTimeFormatTemplates" runat="server" 
					meta:resourcekey="lblDateTimeFormatTemplatesResource1" />
			</select>
			
			<anthem:RequiredFieldValidator ID="rfvDateTimeFormat" runat="server" 
				Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtDateTimeFormat" ErrorMessage="Date/Time Format is required" 
				AutoUpdateAfterCallBack="True" meta:resourcekey="rfvDateTimeFormatResource1" 
				UpdateAfterCallBack="True" />
			<anthem:CustomValidator ID="cvDateTimeFormat" runat="server" Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtDateTimeFormat" ErrorMessage="Invalid Date/Time Format"
				OnServerValidate="cvDateTimeFormat_ServerValidate" AutoUpdateAfterCallBack="True" 
				meta:resourcekey="cvDateTimeFormatResource1" UpdateAfterCallBack="True" />
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblDefaultLanguage" runat="server" Text="Default language" 
				EnableViewState="False" meta:resourcekey="lblDefaultLanguageResource1" /><br />
			<anthem:DropDownList ID="lstDefaultLanguage" runat="server" 
				CssClass="configlarge" meta:resourcekey="lstDefaultLanguageResource1" />
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblDefaultTimeZone" runat="server" Text="Default time zone" 
				EnableViewState="False" meta:resourcekey="lblDefaultTimeZoneResource1" /><br />
			<anthem:DropDownList ID="lstDefaultTimeZone" runat="server" 
				CssClass="configlarge" meta:resourcekey="lstDefaultTimeZoneResource1">
				<asp:ListItem Value="-720" Text="(GMT-12:00) International Date Line West" 
					meta:resourcekey="ListItemResource1" />
				<asp:ListItem Value="-660" Text="(GMT-11:00) Midway Island, Samoa" 
					meta:resourcekey="ListItemResource2" />
				<asp:ListItem Value="-600" Text="(GMT-10:00) Hawaii" 
					meta:resourcekey="ListItemResource3" />
				<asp:ListItem Value="-540" Text="(GMT-09:00) Alaska" 
					meta:resourcekey="ListItemResource4" />
				<asp:ListItem Value="-480" Text="(GMT-08:00) Pacific" 
					meta:resourcekey="ListItemResource5" />
				<asp:ListItem Value="-420" Text="(GMT-07:00) Mountain" 
					meta:resourcekey="ListItemResource6" />
				<asp:ListItem Value="-360" Text="(GMT-06:00) Central" 
					meta:resourcekey="ListItemResource7" />
				<asp:ListItem Value="-300" Text="(GMT-05:00) Eastern" 
					meta:resourcekey="ListItemResource8" />
				<asp:ListItem Value="-240" Text="(GMT-04:00) Atlantic" 
					meta:resourcekey="ListItemResource9" />
				<asp:ListItem Value="-210" Text="(GMT-03:30) Newfoundland" 
					meta:resourcekey="ListItemResource10" />
				<asp:ListItem Value="-180" Text="(GMT-03:00) Greenland" 
					meta:resourcekey="ListItemResource11" />
				<asp:ListItem Value="-120" Text="(GMT-02:00) Mid-Atlantic" 
					meta:resourcekey="ListItemResource12" />
				<asp:ListItem Value="-60" Text="(GMT-01:00) Azores" 
					meta:resourcekey="ListItemResource13" />
				<asp:ListItem Value="0" Text="(GMT) Greenwich" Selected="True" 
					meta:resourcekey="ListItemResource14" />
				<asp:ListItem Value="60" Text="(GMT+01:00) Central European" 
					meta:resourcekey="ListItemResource15" />
				<asp:ListItem Value="120" Text="(GMT+02:00) Eastern European" 
					meta:resourcekey="ListItemResource16" />
				<asp:ListItem Value="180" Text="(GMT+03:00) Moscow, Baghdad" 
					meta:resourcekey="ListItemResource17" />
				<asp:ListItem Value="210" Text="(GMT+03:30) Iran" 
					meta:resourcekey="ListItemResource18" />
				<asp:ListItem Value="240" Text="(GMT+04:00) Abu Dhabi, Dubai" 
					meta:resourcekey="ListItemResource19" />
				<asp:ListItem Value="270" Text="(GMT+04:30) Kabul" 
					meta:resourcekey="ListItemResource20" />
				<asp:ListItem Value="300" Text="(GMT+05:00) Islamabad, Karachi" 
					meta:resourcekey="ListItemResource21" />
				<asp:ListItem Value="330" Text="(GMT+05:30) India" 
					meta:resourcekey="ListItemResource22" />
				<asp:ListItem Value="345" Text="(GMT+05:45) Kathmandu" 
					meta:resourcekey="ListItemResource23" />
				<asp:ListItem Value="360" Text="(GMT+06:00) Astana, Dhaka" 
					meta:resourcekey="ListItemResource24" />
				<asp:ListItem Value="390" Text="(GMT+06:30) Rangoon" 
					meta:resourcekey="ListItemResource25" />
				<asp:ListItem Value="420" Text="(GMT+07:00) Bangkok, Jakarta" 
					meta:resourcekey="ListItemResource26" />
				<asp:ListItem Value="480" Text="(GMT+08:00) China Coast, Western Australia" 
					meta:resourcekey="ListItemResource27" />
				<asp:ListItem Value="540" Text="(GMT+09:00) Japan, Korea" 
					meta:resourcekey="ListItemResource28" />
				<asp:ListItem Value="570" Text="(GMT+09:30) Central Australia" 
					meta:resourcekey="ListItemResource29" />
				<asp:ListItem Value="600" Text="(GMT+10:00) Eastern Australia" 
					meta:resourcekey="ListItemResource30" />
				<asp:ListItem Value="660" Text="(GMT+11:00) Magadan, Solomon Island" 
					meta:resourcekey="ListItemResource31" />
				<asp:ListItem Value="720" Text="(GMT+12:00) New Zealand, Fiji" 
					meta:resourcekey="ListItemResource32" />
				<asp:ListItem Value="765" Text="(GMT+12:45) Chatham Island NZ" 
					meta:resourcekey="ListItemResource33" />
				<asp:ListItem Value="780" Text="(GMT+13:00) Tonga, Phoenix Islands" 
					meta:resourcekey="ListItemResource34" />
				<asp:ListItem Value="840" Text="(GMT+14:00) Christmas Islands" 
					meta:resourcekey="ListItemResource35" />
			</anthem:DropDownList>
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblMaxRecentChangesToDisplayPre" runat="server" 
				Text="Display at most" EnableViewState="False" 
				meta:resourcekey="lblMaxRecentChangesToDisplayPreResource1" />
			<anthem:TextBox ID="txtMaxRecentChangesToDisplay" runat="server" 
				CssClass="configsmallest" 
				meta:resourcekey="txtMaxRecentChangesToDisplayResource1" />
			<asp:Literal ID="lblMaxRecentChangesToDisplayPost" runat="server" 
				Text="items in <code>{RecentChanges}</code> tags" EnableViewState="False" 
				meta:resourcekey="lblMaxRecentChangesToDisplayPostResource1" />
			
			<anthem:RequiredFieldValidator ID="rfvMaxRecentChangesToDisplay" runat="server" 
				Display="Dynamic" AutoUpdateAfterCallBack="True" CssClass="resulterror"
				ControlToValidate="txtMaxRecentChangesToDisplay" ErrorMessage="Number is required" 
				meta:resourcekey="rfvMaxRecentChangesToDisplayResource1" 
				UpdateAfterCallBack="True" />
			<anthem:RangeValidator ID="rvMaxRecentChangesToDisplay" runat="server" 
				Display="Dynamic" AutoUpdateAfterCallBack="True" CssClass="resulterror"
				ControlToValidate="txtMaxRecentChangesToDisplay" ErrorMessage="Number must be between 0 and 50"
				Type="Integer" MinimumValue="0" MaximumValue="50" 
				meta:resourcekey="rvMaxRecentChangesToDisplayResource1" 
				UpdateAfterCallBack="True" />
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblRssFeedsMode" runat="server"
				Text="RSS Feeds Serving Mode" EnableViewState="false"
				meta:resourcekey="lblRssFeedsModeResource1" /><br />
			<anthem:DropDownList ID="lstRssFeedsMode" runat="server" meta:resourcekey="lstRssFeedsModeResource1">
				<asp:ListItem Text="Full Text" Value="FullText" meta:resourcekey="ListItemResource42" />
				<asp:ListItem Text="Summary" Value="Summary" meta:resourcekey="ListItemResource43" />
				<asp:ListItem Text="Disabled (RSS feeds completely disabled)" Value="Disabled" meta:resourcekey="ListItemResource44" />
			</anthem:DropDownList>
		</div>
		
		<div class="featurecontainer">
			<anthem:CheckBox ID="chkEnableDoubleClickEditing" runat="server" 
				Text="Enable Double-Click editing" 
				meta:resourcekey="chkEnableDoubleClickEditingResource1" />
		</div>
		
		<div class="featurecontainer">
			<anthem:CheckBox ID="chkEnableSectionEditing" runat="server" 
				Text="Enable editing of pages' sections" 
				meta:resourcekey="chkEnableSectionEditingResource1" />
		</div>
		
		<div class="featurecontainer">
			<anthem:CheckBox ID="chkEnableSectionAnchors" runat="server" 
				Text="Display anchors for pages' sections" 
				meta:resourcekey="chkEnableSectionAnchorsResource1" />
		</div>
		
		<div class="featurecontainer">
			<anthem:CheckBox ID="chkEnablePageToolbar" runat="server" 
				Text="Enable Page Toolbar (Edit this Page, History, Admin)" 
				meta:resourcekey="chkEnablePageToolbarResource1" />
		</div>
		
		<div class="featurecontainer">
			<anthem:CheckBox ID="chkEnableViewPageCode" runat="server" 
				Text="Enable 'View Page Code' feature" 
				meta:resourcekey="chkEnableViewPageCodeResource1" />
		</div>
		
		<div class="featurecontainer">
			<anthem:CheckBox ID="chkEnablePageInfoDiv" runat="server" 
				Text="Enable Page Information section (Modified on, Categorized as, etc.)" 
				meta:resourcekey="chkEnablePageInfoDivResource1" />
		</div>
		
		<div class="featurecontainer">
			<anthem:CheckBox ID="chkEnableBreadcrumbsTrail" runat="server" 
				Text="Enable Breadcrumbs Trail" 
				meta:resourcekey="chkEnableBreadcrumbsTrailResource1" />
		</div>
		
		<div class="featurecontainer">
			<anthem:CheckBox ID="chkAutoGeneratePageNames" runat="server"
				Text="Auto-Generate Page Names in Editor by default"
				meta:resourcekey="chkAutoGeneratePageNamesResource1" />
		</div>
		
		<div class="featurecontainer">
			<anthem:CheckBox ID="chkProcessSingleLineBreaks" runat="server" 
				Text="Process single line breaks in content (experimental)" 
				meta:resourcekey="chkProcessSingleLineBreaksResource2" />
		</div>
		
		<div class="featurecontainer">
			<anthem:CheckBox ID="chkUseVisualEditorAsDefault" runat="server" 
				Text="Use visual (WYSIWYG) editor as default" 
				meta:resourcekey="chkUseVisualEditorAsDefaultResource1" />
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblKeptBackupNumberPre" runat="server" Text="Keep at most" 
				EnableViewState="False" meta:resourcekey="lblKeptBackupNumberPreResource1" />
			<anthem:TextBox ID="txtKeptBackupNumber" runat="server" 
				CssClass="configsmallest" meta:resourcekey="txtKeptBackupNumberResource1" />
			<asp:Literal ID="lblKeptBackupNumberPost" runat="server" 
				Text="backups for each page (leave empty for no limit)" EnableViewState="False" 
				meta:resourcekey="lblKeptBackupNumberPostResource1" />
			
			<anthem:RangeValidator ID="rvKeptBackupNumber" runat="server" Display="Dynamic" 
				AutoUpdateAfterCallBack="True" CssClass="resulterror"
				ControlToValidate="txtKeptBackupNumber" ErrorMessage="Number must be between 0 and 1000"
				Type="Integer" MinimumValue="0" MaximumValue="1000" 
				meta:resourcekey="rvKeptBackupNumberResource1" UpdateAfterCallBack="True" />
		</div>
		
		<div class="featurecontainer">
			<anthem:CheckBox ID="chkDisplayGravatars" runat="server" 
				Text="Display Gravatars for user accounts" 
				meta:resourcekey="chkDisplayGravatarsResource1" />
		</div>

		<div class="featurecontainer">
			<asp:Literal ID="lblDisplayAtMostPre" runat="server" Text="Display at most"
				EnableViewState="false" meta:resourcekey="lblDisplayAtMostPreResource1" />
			<anthem:TextBox ID="txtListSize" runat="server"
				CssClass="configsmallest" meta:resourceKey="txtListSizeResource1" />
			<asp:Literal ID="lblDisplayAtMostPost" runat="server" Text="items in a list, then start paging"
				EnableViewState="false" meta:resourcekey="lblDisplayAtMostPostResource1" />

			<anthem:RangeValidator ID="rvListSize" runat="server" Display="Dynamic" 
				AutoUpdateAfterCallBack="True" CssClass="resulterror"
				ControlToValidate="txtListSize" ErrorMessage="Number must be between 10 and 1000"
				Type="Integer" MinimumValue="10" MaximumValue="1000" 
				meta:resourcekey="rvListSizeResource1" UpdateAfterCallBack="True" />
		</div>
	</div>
	
	<div id="ConfigSecurityDiv">
		<div class="featurecontainer">
			<h3 class="separator"><asp:Literal ID="lblSecurityConfig" runat="server" 
					Text="Security Configuration" EnableViewState="False" 
					meta:resourcekey="lblSecurityConfigResource1" /></h3>
		</div>
		
		<div class="featurecontainer">
			<anthem:CheckBox ID="chkAllowUsersToRegister" runat="server" 
				Text="Allow users to register" 
				meta:resourcekey="chkAllowUsersToRegisterResource1" />
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblActivationMode" runat="server" 
				Text="Account activation mode" EnableViewState="False" 
				meta:resourcekey="lblActivationModeResource1" /><br />
			<anthem:DropDownList ID="lstAccountActivationMode" runat="server" 
				CssClass="configlarge" meta:resourcekey="lstAccountActivationModeResource1">
				<asp:ListItem Value="EMAIL" Text="Users must activate their account via Email" 
					meta:resourcekey="ListItemResource36" />
				<asp:ListItem Value="ADMIN" Text="Administrators must activate accounts" 
					meta:resourcekey="ListItemResource37" />
				<asp:ListItem Value="AUTO" Text="Accounts are active by default" 
					meta:resourcekey="ListItemResource38" />
			</anthem:DropDownList>
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblDefaultUsersGroup" runat="server" 
				Text="Default Users Group" EnableViewState="False" 
				meta:resourcekey="lblDefaultUsersGroupResource1" /><br />
			<anthem:DropDownList ID="lstDefaultUsersGroup" runat="server" 
				CssClass="configmedium" meta:resourcekey="lstDefaultUsersGroupResource1" />
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblDefaultAdministratorsGroup" runat="server" 
				Text="Default Administrators Group" EnableViewState="False" 
				meta:resourcekey="lblDefaultAdministratorsGroupResource1" /><br />
			<anthem:DropDownList ID="lstDefaultAdministratorsGroup" runat="server" 
				CssClass="configmedium" 
				meta:resourcekey="lstDefaultAdministratorsGroupResource1" />
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblDefaultAnonymousGroup" runat="server" 
				Text="Default Anonymous Users Group" EnableViewState="False" 
				meta:resourcekey="lblDefaultAnonymousGroupResource1" /><br />
			<anthem:DropDownList ID="lstDefaultAnonymousGroup" runat="server" 
				CssClass="configmedium" meta:resourcekey="lstDefaultAnonymousGroupResource1" />
		</div>
		
		<div class="featurecontainer">
			<anthem:CheckBox ID="chkEnableCaptchaControl" runat="server" 
				Text="Enable CAPTCHA control for all public functionalities" 
				meta:resourcekey="chkEnableCaptchaControlResource1" />
		</div>
		
		<div class="featurecontainer">
			<anthem:CheckBox ID="chkPreventConcurrentEditing" runat="server" 
				Text="Prevent concurrent page editing" 
				meta:resourcekey="chkPreventConcurrentEditingResource1" />
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblChangeModerationMode" runat="server" 
				Text="Page change moderation mode" 
				meta:resourcekey="lblChangeModerationModeResource1" /><br />
			<asp:RadioButton ID="rdoNoModeration" runat="server" Text="Disable Moderation" 
				GroupName="mod" 
				ToolTip="No moderation system is used: pages can be edited only by users who have editing permissions" 
				meta:resourcekey="rdoNoModerationResource1" /><br />
			<asp:RadioButton ID="rdoRequirePageViewingPermissions" runat="server" 
				Text="Require Page Viewing permissions" GroupName="mod" 
				ToolTip="Pages can be edited by users who have viewing permissions but not editing permissions, and the changes are help in moderation" 
				meta:resourcekey="rdoRequirePageViewingPermissionsResource1" /><br />
			<asp:RadioButton ID="rdoRequirePageEditingPermissions" runat="server" 
				Text="Require Page Editing permissions" GroupName="mod" 
				ToolTip="Pages can be edited by users who have editing permissions but not management permissions, and the changes are held in moderation" 
				meta:resourcekey="rdoRequirePageEditingPermissionsResource1" />
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblExtensionsAllowedForUpload" runat="server" 
				Text="File extensions allowed for upload (separate with commas, '*' for any type)" 
				EnableViewState="False" 
				meta:resourcekey="lblExtensionsAllowedForUploadResource2" /><br />
			<anthem:TextBox ID="txtExtensionsAllowed" runat="server" CssClass="configlarge" 
				meta:resourcekey="txtExtensionsAllowedResource1" />
			<anthem:CustomValidator ID="cvExtensionsAllowed" runat="server" Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtExtensionsAllowed" ErrorMessage="If you specify '*', remove all other extensions"
				OnServerValidate="cvExtensionsAllowed_ServerValidate" AutoUpdateAfterCallBack="true" />
		</div>
		
		<div class="featurecontainer">
			<anthem:DropDownList ID="lstFileDownloadCountFilterMode" runat="server" AutoCallBack="true"
				AutoUpdateAfterCallBack="true" meta:resourcekey="lstFileDownloadCountFilterModeResource1"
				OnSelectedIndexChanged="lstFileDownloadCountFilterMode_SelectedIndexChanged">
				<asp:ListItem Text="Count all file downloads" Value="CountAll" Selected="True" meta:resourcekey="ListItemResource39" />
				<asp:ListItem Text="Count downloads for specified extensions (separate with commas)" Value="CountSpecifiedExtensions" meta:resourcekey="ListItemResource40" />
				<asp:ListItem Text="Count downloads for all extensions except (separate with commas)" Value="ExcludeSpecifiedExtensions" meta:resourcekey="ListItemResource41" />
			</anthem:DropDownList><br />
			<anthem:TextBox ID="txtFileDownloadCountFilter" runat="server" Enabled="false" CssClass="configlarge"
				AutoUpdateAfterCallBack="true" meta:resourcekey="txtFileDownloadCountFilterResource1" />
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblMaxFileSize" runat="server" 
				Text="Max file size allowed for upload" EnableViewState="False" 
				meta:resourcekey="lblMaxFileSizeResource1" /><br />
			<anthem:TextBox ID="txtMaxFileSize" runat="server" CssClass="configsmallest" 
				meta:resourcekey="txtMaxFileSizeResource1" /> KB
			
			<anthem:RequiredFieldValidator ID="rfvMaxFileSize" runat="server" 
				Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtMaxFileSize" ErrorMessage="Max File Size is required" 
				AutoUpdateAfterCallBack="True" meta:resourcekey="rfvMaxFileSizeResource1" 
				UpdateAfterCallBack="True" />
			<anthem:RangeValidator ID="rvMaxFileSize" runat="server" Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtMaxFileSize" ErrorMessage="Invalid File Size (min. 256, max. 102400)"
				Type="Integer" MinimumValue="256" MaximumValue="102400" AutoUpdateAfterCallBack="True" 
				meta:resourcekey="rvMaxFileSizeResource1" UpdateAfterCallBack="True" />
		</div>
		
		<div class="featurecontainer">
			<anthem:CheckBox ID="chkAllowScriptTags" runat="server" 
				Text="Allow SCRIPT tags in WikiMarkup" 
				meta:resourcekey="chkAllowScriptTagsResource1" />
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblLoggingLevel" runat="server" Text="Logging level" 
				EnableViewState="False" meta:resourcekey="lblLoggingLevelResource1" /><br />
			<anthem:RadioButton ID="rdoAllMessages" runat="server" Text="All Messages" 
				GroupName="log" meta:resourcekey="rdoAllMessagesResource1" />
			<anthem:RadioButton ID="rdoWarningsAndErrors" runat="server" 
				Text="Warnings and Errors" GroupName="log" 
				meta:resourcekey="rdoWarningsAndErrorsResource1" />
			<anthem:RadioButton ID="rdoErrorsOnly" runat="server" Text="Errors Only" 
				GroupName="log" meta:resourcekey="rdoErrorsOnlyResource1" />
			<anthem:RadioButton ID="rdoDisableLog" runat="server" Text="Disable Log" 
				GroupName="log" meta:resourcekey="rdoDisableLogResource1" />
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblMaxLogSize" runat="server" Text="Max log size" 
				EnableViewState="False" meta:resourcekey="lblMaxLogSizeResource1" /><br />
			<anthem:TextBox ID="txtMaxLogSize" runat="server" CssClass="configsmallest" 
				meta:resourcekey="txtMaxLogSizeResource1" /> KB
			
			<anthem:RequiredFieldValidator ID="rfvMaxLogSize" runat="server" 
				Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtMaxLogSize" ErrorMessage="Max Log Size is required" 
				AutoUpdateAfterCallBack="True" meta:resourcekey="rfvMaxLogSizeResource1" 
				UpdateAfterCallBack="True" />
			<anthem:RangeValidator ID="rvMaxLogSize" runat="server" Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtMaxLogSize" ErrorMessage="Invalid Log Size (min. 16, max. 10240)"
				Type="Integer" MinimumValue="16" MaximumValue="10240" AutoUpdateAfterCallBack="True" 
				meta:resourcekey="rvMaxLogSizeResource1" UpdateAfterCallBack="True" />
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblIpHostFilter" runat="server" Text="IP Filter for allowed editing (seperate with commas, Use '*' for wild cards, Example: 192.168.1.*)" 
				EnableViewState="false" meta:resourceKey="lblIpHostFilterResource1" /><br />
			<anthem:TextBox ID="txtIpHostFilter" runat="server" CssClass="configlarge" 
				meta:resourcekey="txtIpHostFilterResource1" />
		</div>
		
	</div>
	
	<div id="ConfigAdvancedDiv">	
		<div class="featurecontainer">
			<h3 class="separator"><asp:Literal ID="lblAdvancedConfig" runat="server" 
					Text="Advanced Configuration" EnableViewState="False" 
					meta:resourcekey="lblAdvancedConfigResource1" /></h3>
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblUsernameRegEx" Text="Regular Expression for validating usernames and group names" runat="server" EnableViewState="false"
			meta:resourcekey="lblUsernameRegExResource2" /><br />
			<anthem:TextBox ID="txtUsernameRegEx" runat="server" CssClass="configlarge" 
					meta:resourcekey="txtUsernameRegExResource1" />
					<anthem:CustomValidator ID="cvUsernameRegEx" runat="server" Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtUsernameRegEx" ErrorMessage="Invalid Regular Expression"
				OnServerValidate="cvUsernameRegEx_ServerValidate" AutoUpdateAfterCallBack="True" 
				meta:resourcekey="cvUsernameRegExResource1" UpdateAfterCallBack="True" />
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblPasswordRegEx" Text="Regular Expression for validating passwords" runat="server" EnableViewState="false"
			meta:resourcekey="lblPasswordRegExResource2" /><br />
			<anthem:TextBox ID="txtPasswordRegEx" runat="server" CssClass="configlarge" 
					meta:resourcekey="txtPasswordRegExResource1" />
			<anthem:CustomValidator ID="cvPasswordRegEx" runat="server" Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtPasswordRegEx" ErrorMessage="Invalid Regular Expression"
				OnServerValidate="cvPasswordRegEx_ServerValidate" AutoUpdateAfterCallBack="True" 
				meta:resourcekey="cvPasswordRegExResource1" UpdateAfterCallBack="True" />
		</div>
		
		<div class="featurecontainer">
			<anthem:CheckBox ID="chkEnableAutomaticUpdateChecks" runat="server" 
				Text="Enable automatic update checks (system and providers)" 
				meta:resourcekey="chkEnableAutomaticUpdateChecksResource1" />
		</div>
		
		<div class="featurecontainer">
			<anthem:CheckBox ID="chkDisableCache" runat="server" 
				Text="Completely disable cache" meta:resourcekey="chkDisableCacheResource1" />
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblCacheSize" runat="server" Text="Cache Size" 
				EnableViewState="False" meta:resourcekey="lblCacheSizeResource1" /><br />
			<anthem:TextBox ID="txtCacheSize" runat="server" CssClass="configsmallest" 
				meta:resourcekey="txtCacheSizeResource1" />
			<asp:Literal ID="lblPages1" runat="server" Text="pages" EnableViewState="False" 
				meta:resourcekey="lblPages1Resource1" />
			
			<anthem:RequiredFieldValidator ID="rfvCacheSize" runat="server" 
				Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtCacheSize" ErrorMessage="Cache Size is required" 
				AutoUpdateAfterCallBack="True" meta:resourcekey="rfvCacheSizeResource1" 
				UpdateAfterCallBack="True" />
			<anthem:RangeValidator ID="rvCacheSize" runat="server" Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtCacheSize" ErrorMessage="Invalid Size (min. 10, max. 100000)"
				Type="Integer" MinimumValue="10" MaximumValue="100000" AutoUpdateAfterCallBack="True" 
				meta:resourcekey="rvCacheSizeResource1" UpdateAfterCallBack="True" />
		</div>
		
		<div class="featurecontainer">
			<asp:Literal ID="lblCacheCutSize" runat="server" Text="Cache cut size" 
				EnableViewState="False" meta:resourcekey="lblCacheCutSizeResource1" /><br />
			<anthem:TextBox ID="txtCacheCutSize" runat="server" CssClass="configsmallest" 
				meta:resourcekey="txtCacheCutSizeResource1" />
			<asp:Literal ID="lblPages2" runat="server" Text="pages" EnableViewState="False" 
				meta:resourcekey="lblPages2Resource1" />
			
			<anthem:RequiredFieldValidator ID="rfvCacheCutSize" runat="server" 
				Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtCacheCutSize" ErrorMessage="Cache Cut Size is required" 
				AutoUpdateAfterCallBack="True" meta:resourcekey="rfvCacheCutSizeResource1" 
				UpdateAfterCallBack="True" />
			<anthem:RangeValidator ID="rvCacheCutSize" runat="server" Display="Dynamic" CssClass="resulterror"
				ControlToValidate="txtCacheCutSize" ErrorMessage="Invalid Cache Cut Size (min. 5, max. 50000)"
				Type="Integer" MinimumValue="5" MaximumValue="50000" AutoUpdateAfterCallBack="True" 
				meta:resourcekey="rvCacheCutSizeResource1" UpdateAfterCallBack="True" />
		</div>
		
		<div class="featurecontainer">
			<anthem:CheckBox ID="chkEnableViewStateCompression" runat="server" 
				Text="Enable ViewState compression" 
				meta:resourcekey="chkEnableViewStateCompressionResource1" />
		</div>
		
		<div class="featurecontainer">
			<anthem:CheckBox ID="chkEnableHttpCompression" runat="server" 
				Text="Enable HTTP compression" 
				meta:resourcekey="chkEnableHttpCompressionResource1" />
		</div>
	</div>
	
	<div id="ButtonsDiv">
		<anthem:Button ID="btnSave" runat="server" Text="Save Configuration" 
			OnClick="btnSave_Click" meta:resourcekey="btnSaveResource1" />
		<anthem:Label ID="lblResult" runat="server" AutoUpdateAfterCallBack="True" 
			meta:resourcekey="lblResultResource1" UpdateAfterCallBack="True" />
	</div>
	
	<div style="clear: both;"></div>
</asp:Content>
