<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProviderSelector.ascx.cs" Inherits="ScrewTurn.Wiki.ProviderSelector" %>
<anthem:DropDownList ID="lstProviders" runat="server" AutoUpdateAfterCallBack="true"
	OnSelectedIndexChanged="lstProviders_SelectedIndexChanged" CssClass="storageproviderselector" />
