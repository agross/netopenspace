<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeBehind="AdminCategories.aspx.cs" Inherits="ScrewTurn.Wiki.AdminCategories" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" %>

<%@ Register TagPrefix="st" TagName="ProviderSelector" Src="~/ProviderSelector.ascx" %>
<%@ Register TagPrefix="st" TagName="PageListBuilder" Src="~/PageListBuilder.ascx" %>

<asp:Content ID="ctnHead" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="ctnCategories" ContentPlaceHolderID="cphAdmin" runat="server">
	<h2 class="sectiontitle"><asp:Literal ID="lblCategories" runat="server" Text="Categories" EnableViewState="False" meta:resourcekey="lblCategoriesResource1" /></h2>
	
	<anthem:Panel ID="pnlList" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="pnlListResource1">
		<div class="rightaligned">
			<h3><asp:Literal ID="lblNewCategory" runat="server" Text="New Category" EnableViewState="False" meta:resourcekey="lblNewCategoryResource1" /></h3>
			<anthem:TextBox ID="txtNewCategory" runat="server" Width="150px" ValidationGroup="newcat" meta:resourcekey="txtNewCategoryResource1" />
			<anthem:Button ID="btnNewCategory" runat="server" Text="Create" OnClick="btnNewCategory_Click" ValidationGroup="newcat" 
				AutoUpdateAfterCallBack="True" meta:resourcekey="btnNewCategoryResource1" /><br />
			<anthem:RequiredFieldValidator ID="rfvNewCategory" runat="server" Display="Dynamic" ErrorMessage="Category Name is required"
				ControlToValidate="txtNewCategory" ValidationGroup="newcat" CssClass="resulterror" meta:resourcekey="rfvNewCategoryResource1" />
			<anthem:CustomValidator ID="cvNewCategory" runat="server" Display="Dynamic" ErrorMessage="Invalid Category Name"
				ControlToValidate="txtNewCategory" ValidationGroup="newcat" OnServerValidate="cvNewCategory_ServerValidate" CssClass="resulterror" 
				meta:resourcekey="cvNewCategoryResource1" />
			<anthem:Label ID="lblNewCategoryResult" runat="server" meta:resourcekey="lblNewCategoryResultResource1" />

			<br /><br />			
			<anthem:Button ID="btnBulkManage" runat="server" Text="Bulk Manage" ToolTip="Manage categories binding for many pages at once" OnClick="btnBulkManage_Click" meta:resourcekey="btnBulkManageResource1" />
		</div>
	
		<div id="NamespaceSelectorDiv">
			<asp:Literal ID="lblNamespace" runat="server" Text="Namespace" EnableViewState="False" meta:resourcekey="lblNamespaceResource1" /><br />
			<anthem:DropDownList ID="lstNamespace" runat="server" AutoCallBack="True" OnSelectedIndexChanged="lstNamespace_SelectedIndexChanged" Width="150px" meta:resourcekey="lstNamespaceResource1" />
		</div>
		
		<div id="CategoriesListContainerDiv">
			<anthem:Repeater ID="rptCategories" runat="server"
				OnDataBinding="rptCategories_DataBinding" OnItemCommand="rptCategories_ItemCommand">
				<HeaderTemplate>
					<table cellpadding="0" cellspacing="0" class="generic">
						<thead>
						<tr class="tableheader">
							<th>
								<asp:Literal ID="lblName" runat="server" EnableViewState="False" 
									meta:resourcekey="lblNameResource1" Text="Name"></asp:Literal>
							</th>
							<th>
								<asp:Literal ID="lblPages" runat="server" EnableViewState="False" 
									meta:resourcekey="lblPagesResource1" Text="Pages"></asp:Literal>
							</th>
							<th>
								<asp:Literal ID="lblProvider" runat="server" EnableViewState="False" 
									meta:resourcekey="lblProviderResource1" Text="Provider"></asp:Literal>
							</th>
							<td>&nbsp;</td>
						</tr>
						</thead>
						<tbody>
				</HeaderTemplate>
				<ItemTemplate>
					<tr class='tablerow<%# Eval("AdditionalClass") %>'>
						<td><a href='AllPages.aspx?Cat=<%# ScrewTurn.Wiki.Tools.UrlEncode((string)Eval("FullName")) %>&amp;NS=<%# ScrewTurn.Wiki.PluginFramework.NameTools.GetNamespace((string)Eval("FullName")) %>' target="_blank" title='<%= ScrewTurn.Wiki.Properties.Messages.GoToCategory %>'><%# ScrewTurn.Wiki.PluginFramework.NameTools.GetLocalName((string)Eval("FullName")) %></a></td>
						<td><%# Eval("PageCount") %></td>
						<td><%# Eval("Provider") %></td>
						<td><anthem:LinkButton ID="btnSelect" runat="server" Visible='<%# (bool)Eval("CanSelect") %>' Text="Select" ToolTip="Select this Category" CommandName="Select" CommandArgument='<%# Eval("FullName") %>' meta:resourcekey="btnSelectResource2" /></td>
					</tr>
				</ItemTemplate>
				<AlternatingItemTemplate>
					<tr class='tablerowalternate<%# Eval("AdditionalClass") %>'>
						<td><a href='AllPages.aspx?Cat=<%# ScrewTurn.Wiki.Tools.UrlEncode((string)Eval("FullName")) %>&amp;NS=<%# ScrewTurn.Wiki.PluginFramework.NameTools.GetNamespace((string)Eval("FullName")) %>' target="_blank" title='<%= ScrewTurn.Wiki.Properties.Messages.GoToCategory %>'><%# ScrewTurn.Wiki.PluginFramework.NameTools.GetLocalName((string)Eval("FullName")) %></a></td>
						<td><%# Eval("PageCount") %></td>
						<td><%# Eval("Provider") %></td>
						<td><anthem:LinkButton ID="btnSelect" runat="server" Visible='<%# (bool)Eval("CanSelect") %>' Text="Select" ToolTip="Select this Category" CommandName="Select" CommandArgument='<%# Eval("FullName") %>' meta:resourcekey="btnSelectResource1" /></td>
					</tr>
				</AlternatingItemTemplate>
				<FooterTemplate>
					</tbody>
					</table>
				</FooterTemplate>
			</anthem:Repeater>
		</div>
	</anthem:Panel>
	
	<anthem:Panel ID="pnlEditCategory" runat="server" AutoUpdateAfterCallBack="True" Visible="False" meta:resourcekey="pnlEditCategoryResource1">
		<div id="EditCategoryDiv">
			<h2 class="separator"><asp:Literal ID="lblEditTitle" runat="server" Text="Category Operations" EnableViewState="False" meta:resourcekey="lblEditTitleResource1" />
			(<asp:Literal ID="lblCurrentCategory" runat="server" meta:resourcekey="lblCurrentCategoryResource1" />)</h2>
			<br />
			
			<div class="categoryfeaturecontainer">
				<h3><asp:Literal ID="lblRenameCategoryTitle" runat="server" Text="Rename Category" EnableViewState="False" meta:resourcekey="lblRenameCategoryTitleResource1" /></h3>
				<br />
				<asp:Literal ID="lblNewName" runat="server" Text="New Name" EnableViewState="False" meta:resourcekey="lblNewNameResource1" /><br />
				<anthem:TextBox ID="txtNewName" runat="server" Width="200px" ValidationGroup="rencat" meta:resourcekey="txtNewNameResource1" />
				<br /><br />
				<anthem:Button ID="btnRename" runat="server" Text="Rename" ToolTip="Rename the Category"
					PreCallBackFunction="RequestConfirm" OnClick="btnRename_Click" ValidationGroup="rencat" meta:resourcekey="btnRenameResource1" />
				<br />
				<anthem:RequiredFieldValidator ID="rfvNewName" runat="server" Display="Dynamic" ErrorMessage="New Name is required"
					ControlToValidate="txtNewName" ValidationGroup="rencat" CssClass="resulterror" meta:resourcekey="rfvNewNameResource1" />
				<anthem:CustomValidator ID="cvNewName" runat="server" Display="Dynamic" ErrorMessage="Invalid Category Name"
					ControlToValidate="txtNewName" ValidationGroup="rencat" OnServerValidate="cvNewName_ServerValidate" CssClass="resulterror" meta:resourcekey="cvNewNameResource1" />
				<anthem:Label ID="lblRenameResult" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="lblRenameResultResource1" />
			</div>
			
			<div class="categoryfeaturecontainer">
				<h3><asp:Literal ID="lblMergeCategoryTitle" runat="server" Text="Merge Category" EnableViewState="False" meta:resourcekey="lblMergeCategoryTitleResource1" /></h3>
				<br />
				<asp:Literal ID="lblMergeInto" runat="server" Text="Merge into" EnableViewState="False" meta:resourcekey="lblMergeIntoResource1" /><br />
				<anthem:DropDownList ID="lstDestinationCategory" runat="server" meta:resourcekey="lstDestinationCategoryResource1" />
				<br /><br />
				<anthem:Button ID="btnMerge" runat="server" Text="Merge" ToolTip="Merges the Category" PreCallBackFunction="RequestConfirm" OnClick="btnMerge_Click" meta:resourcekey="btnMergeResource1" />
				<br />
				<anthem:Label ID="lblMergeResult" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="lblMergeResultResource1" UpdateAfterCallBack="True" />
			</div>
			
			<div class="categoryfeaturecontainerwarning">
				<h3><asp:Literal ID="lblDeleteCategory" runat="server" Text="Delete Category" EnableViewState="False" meta:resourcekey="lblDeleteCategoryResource1" /></h3>
				<br />
				<anthem:Button ID="btnDeleteCategory" runat="server" Text="Delete Category" ToolTip="Delete this Category"
					PreCallBackFunction="RequestConfirm" OnClick="btnDelete_Click" meta:resourcekey="btnDeleteCategoryResource1" />
				<br />
				<anthem:Label ID="lblDeleteResult" runat="server" AutoUpdateAfterCallBack="True" meta:resourcekey="lblDeleteResultResource1" />
			</div>
			
			<div id="ButtonsDiv">
				<anthem:Button ID="btnBack" runat="server" Text="Back" ToolTip="Back to the Category list" OnClick="btnBack_Click" CausesValidation="False" meta:resourcekey="btnBackResource1" />
			</div>
			
		</div>
	</anthem:Panel>
	
	<anthem:Panel ID="pnlBulkManage" runat="server" Visible="false" AutoUpdateAfterCallBack="true">
		<div id="CategoryBulkAdminDiv">
			<div id="PageSelectionDiv">
				<h3 class="separator"><asp:Literal ID="lblBulkStep1" runat="server" Text="1. Select Pages" EnableViewState="false" meta:resourcekey="lblBulkStep1Resource1" /></h3>
				
				<st:ProviderSelector ID="providerSelector" runat="server" ProviderType="Pages"
					AutoPostBack="true" OnSelectedProviderChanged="providerSelector_SelectedProviderChanged" />
				<br /><br />
				
				<st:PageListBuilder ID="pageListBuilder" runat="server" />
			</div>
			
			<div id="CategorySelectionDiv">
				<h3 class="separator"><asp:Literal ID="lblBulkStep2" runat="server" Text="2. Select Categories" EnableViewState="false" meta:resourcekey="lblBulkStep2Resource1" /></h3>
				<div id="ListContainerDiv">
					<anthem:CheckBoxList ID="lstBulkCategories" runat="server" AutoUpdateAfterCallBack="true" />
				</div>
			</div>
			
			<div id="BatchControlDiv">
				<h3 class="separator"><asp:Literal ID="lblBulkStep3" runat="server" Text="3. Save Binding" EnableViewState="false" meta:resourcekey="lblBulkStep3Resource1" /></h3>
				<anthem:RadioButton ID="rdoBulkAdd" runat="server" Text="Add selected categories to selected pages, preserving existing categories mapping" GroupName="bulkmode" Checked="true" meta:resourcekey="rdoBulkAddResource2" />
				<br /><br />
				<anthem:RadioButton ID="rdoBulkReplace" runat="server" Text="For selected pages, replace existing categories mapping with selected categories (selecting no categories causes the pages to be uncategorized)" GroupName="bulkmode" meta:resourcekey="rdoBulkReplaceResource2" />
				<br /><br />
				
				<anthem:Button ID="btnBulkSave" runat="server" Text="Save Binding" OnClick="btnBulkSave_Click" OnClientClick="javascript:return RequestConfirm();" meta:resourcekey="btnBulkSaveResouce1" /><br />
				<anthem:Label ID="lblBulkResult" runat="server" AutoUpdateAfterCallBack="true" />
			</div>
		
			<div id="ButtonsDiv2">
				<anthem:Button ID="btnBulkBack" runat="server" Text="Back" ToolTip="Back to the Category list" OnClick="btnBulkBack_Click" CausesValidation="False" meta:resourcekey="btnBulkBackResource1" />
			</div>
		</div>
	</anthem:Panel>
	
	<anthem:HiddenField ID="txtCurrentCategory" runat="server" AutoUpdateAfterCallBack="True" />
	
	<div style="clear: both;"></div>

</asp:Content>
