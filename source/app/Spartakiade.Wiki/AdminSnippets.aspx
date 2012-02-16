<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeBehind="AdminSnippets.aspx.cs" Inherits="ScrewTurn.Wiki.AdminSnippets" ValidateRequest="false" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" %>

<%@ Register TagPrefix="st" TagName="ProviderSelector" Src="~/ProviderSelector.ascx" %>
<%@ Register TagPrefix="st" TagName="Editor" Src="~/Editor.ascx" %>

<asp:Content ID="ctnHead" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="ctnSnippetsTemplates" ContentPlaceHolderID="cphAdmin" runat="server">
	<h2 class="sectiontitle"><asp:Literal ID="lblSnippetsTemplates" runat="server" Text="Snippets and Templates" EnableViewState="False" meta:resourcekey="lblSnippetsTemplatesResource1" /></h2>
	
	<asp:Panel ID="pnlList" runat="server" meta:resourcekey="pnlListResource1">
		<asp:Button ID="btnNewTemplate" runat="server" Text="New Template" CssClass="rightaligned" OnClick="btnNewTemplate_Click" meta:resourcekey="btnNewTemplateResource1" />
		<asp:Button ID="btnNewSnippet" runat="server" Text="New Snippet" CssClass="rightaligned" OnClick="btnNewSnippet_Click" meta:resourcekey="btnNewSnippetResource1" />
		
		<div id="SnippetsListContainerDiv">
			<asp:Repeater ID="rptSnippetsTemplates" runat="server"
				OnDataBinding="rptSnippetsTemplates_DataBinding" OnItemCommand="rptSnippetsTemplates_ItemCommand">
				<HeaderTemplate>
					<table cellpadding="0" cellspacing="0" class="generic">
						<thead>
						<tr class="tableheader">
							<th><asp:Literal ID="lblType" runat="server" EnableViewState="False" meta:resourcekey="lblTypeResource1" Text="Type" /></th>
							<th><asp:Literal ID="lblName" runat="server" EnableViewState="False" meta:resourcekey="lblNameResource1" Text="Name" /></th>
							<th><asp:Literal ID="lblParameters" runat="server" EnableViewState="False" meta:resourcekey="lblParametersResource1" Text="Params" /></th>
							<th><asp:Literal ID="lblProvider" runat="server" EnableViewState="False" meta:resourcekey="lblProviderResource1" Text="Provider" /></th>
							<th>&nbsp;</th>
						</tr>
						</thead>
						<tbody>
				</HeaderTemplate>
				<ItemTemplate>
					<tr class='tablerow<%# Eval("AdditionalClass") %>'>
						<td><%# Eval("Type") %></td>
						<td><%# Eval("Name") %></td>
						<td><%# Eval("ParameterCount") %></td>
						<td><%# Eval("Provider") %></td>
						<td><asp:LinkButton ID="btnSelect" runat="server" CommandArgument='<%# Eval("DistinguishedName") %>' CommandName="Select" meta:resourcekey="btnSelectResource2" Text="Select" ToolTip="Edit or delete this item" /></td>
					</tr>
				</ItemTemplate>
				<AlternatingItemTemplate>
					<tr class='tablerowalternate<%# Eval("AdditionalClass") %>'>
						<td><%# Eval("Type") %></td>
						<td><%# Eval("Name") %></td>
						<td><%# Eval("ParameterCount") %></td>
						<td><%# Eval("Provider") %></td>
						<td><asp:LinkButton ID="btnSelect" runat="server" CommandArgument='<%# Eval("DistinguishedName") %>' CommandName="Select" meta:resourcekey="btnSelectResource1" Text="Select" ToolTip="Edit or delete this item" /></td>
					</tr>
				</AlternatingItemTemplate>
				<FooterTemplate>
					</tbody>
					</table>
				</FooterTemplate>
			</asp:Repeater>
		</div>
	</asp:Panel>
	
	<asp:Panel ID="pnlEditElement" runat="server" Visible="False" meta:resourcekey="pnlEditElementResource1">
		<div id="EditSnippetDiv">		
			<h2 class="separator">
				<asp:Literal ID="lblEditTitleSnippet" runat="server" Text="Snippet Details" meta:resourcekey="lblEditTitleSnippetResource1" />
				<asp:Literal ID="lblEditTitleTemplate" runat="server" Text="Template Details" meta:resourcekey="lblEditTitleTemplateResource1" />
			</h2>
			<asp:Literal ID="lblEditSnippetWarning" runat="server" Visible="false" meta:resourcekey="lblEditSnippetWarningResource1"
				Text="<div class='warning' style='float: right;'>You are now editing a snippet. After you are done,<br />it is <b>strongly</b> suggested to rebuild the search engine index in the <i>Admin Home</i> page.</div>" />
			
			<asp:Literal ID="lblProvider" runat="server" Text="Provider" EnableViewState="False" meta:resourcekey="lblProviderResource2" /><br />
			<st:ProviderSelector ID="providerSelector" runat="server" ExcludeReadOnly="true" ProviderType="Pages" /><br />
			
			<asp:Literal ID="lblName" runat="server" Text="Name" EnableViewState="False" meta:resourcekey="lblNameResource2" /><br />
			<asp:TextBox ID="txtName" runat="server" CssClass="textbox" ValidationGroup="snippet" meta:resourcekey="txtNameResource1" />
			<asp:RequiredFieldValidator ID="rfvName" runat="server" ErrorMessage="Name is required"
				CssClass="resulterror" ControlToValidate="txtName" Display="Dynamic" ValidationGroup="snippet" meta:resourcekey="rfvNameResource1" />
			<asp:CustomValidator ID="cvName" runat="server" ErrorMessage="Invalid Snippet Name"
				CssClass="resulterror" ControlToValidate="txtName" Display="Dynamic" ValidationGroup="snippet"
				OnServerValidate="cvName_ServerValidate" meta:resourcekey="cvNameResource1" />
			<br /><br />
			
			<st:Editor ID="editor" runat="server" />
				
			<div id="ButtonsDiv">
				<asp:Button ID="btnSave" runat="server" Text="Save Item" ToolTip="Save modifications"
					CssClass="button" Visible="False" ValidationGroup="snippet" OnClick="btnSave_Click" meta:resourcekey="btnSaveResource1" />
				<asp:Button ID="btnCreate" runat="server" Text="Create Item" ToolTip="Save the new Item"
					CssClass="button" ValidationGroup="snippet" OnClick="btnCreate_Click" meta:resourcekey="btnCreateResource1" />
				<asp:Button ID="btnDelete" runat="server" Text="Delete" ToolTip="Delete the Item"
					CssClass="button" Visible="False" CausesValidation="False" OnClick="btnDelete_Click"
					ValidationGroup="account" OnClientClick="javascript:return RequestConfirm();" meta:resourcekey="btnDeleteResource1" />
				<asp:Button ID="btnCancel" runat="server" Text="Cancel" ToolTip="Cancel and return to the items list"
					CssClass="button" CausesValidation="False" ValidationGroup="account" OnClick="btnCancel_Click" meta:resourcekey="btnCancelResource1" />
					
				<asp:Label ID="lblResult" runat="server" meta:resourcekey="lblResultResource1" />
			</div>
		</div>
	</asp:Panel>
	
	<asp:HiddenField ID="txtCurrentElement" runat="server" />
	
	<div style="clear: both;"></div>

</asp:Content>
