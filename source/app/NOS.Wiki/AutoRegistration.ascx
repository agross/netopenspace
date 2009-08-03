<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AutoRegistration.ascx.cs" Inherits="NOS.AutoRegistration" %>

<script type="text/javascript">
	$(document).ready(function()
	{
		$("#<%=chkAutoRegister.ClientID %>").change(function()
		{
			var enabled = $(this).is(":checked");
			ValidatorEnable($("#<%= rfvName.ClientID %>").get(0), enabled);
			ValidatorEnable($("#<%= revBlog.ClientID %>").get(0), enabled);
			ValidatorEnable($("#<%= revPicture.ClientID %>").get(0), enabled);
			ValidatorEnable($("#<%= rngSponsoring.ClientID %>").get(0), enabled);
		});

		function updateLink(element, href)
		{
			var link = $(element).nextAll("a.preview").get(0);
			if ($(element).val().length === 0)
			{
				if (link)
				{
					$(element).parent().children("br:last").remove();
					$(link).remove();
				}
				return;
			}

			if (!link)
			{
				link = $("<a>")
					.addClass("preview")
					.addClass("externallink")
					.attr("target", "_blank")
					.attr("disabled", "true");

				$(element).parent().children(":last").after("<br>");
				$(element).parent().children(":last").after(link);
			}

			$(link)
				.attr("href", href)
				.text(href);
		}

		$("#<%=txtXingUserName.ClientID %>").data("href", function(e) { return "http://www.xing.com/profile/" + $(e).val(); });
		$("#<%=txtTwitterUserName.ClientID %>").data("href", function(e) { return "http://twitter.com/" + $(e).val() + "/"; });
		$("#<%=txtBlog.ClientID %>").data("href", function(e) { return $(e).val(); });
		$("#<%=txtPicture.ClientID %>").data("href", function(e) { return $(e).val(); });

		$("#<%=txtXingUserName.ClientID %>, #<%=txtTwitterUserName.ClientID %>, #<%=txtBlog.ClientID %>, #<%=txtPicture.ClientID %>")
			.each(function(e)
			{
				$(this).focus(function()
				{
					$(this).keyup();
				});

				$(this).keyup(function()
				{
					updateLink(this, $(this).data("href")(this));
				});

				$(this).keyup();
			});
	});
</script>

<asp:Panel ID="AutoRegistrationPanel" runat="server">
	</table>
	<br />
	<p>
		<asp:Literal ID="litIntroduction1" runat="server" meta:resourcekey="litIntroduction1" />
		<asp:HyperLink ID="lnkAttendeeList1" runat="server" meta:resourcekey="lnkAttendeeList" NavigateUrl="Teilnehmer.ashx" /><asp:Literal
			ID="litIntroduction2" runat="server" meta:resourcekey="litIntroduction2" />
		<asp:HyperLink ID="lnkAttendeeList2" runat="server" meta:resourcekey="lnkAttendeePage" NavigateUrl="Teilnehmer.ashx" /><asp:Literal
			ID="litIntroduction3" runat="server" meta:resourcekey="litIntroduction3" />
	</p>
	<br />
	<table width="100%" cellpadding="0" cellspacing="4">
		<colgroup>
			<col width="30%" />
			<col width="*" />
		</colgroup>
		<tr>
			<td>
			</td>
			<td>
				<asp:CheckBox ID="chkAutoRegister" runat="server" meta:resourcekey="chkAutoRegister" Checked="true" Font-Bold="True" CausesValidation="True" />
			</td>
		</tr>
		<tr>
			<td>
				<p style="text-align: right;">
					<asp:Literal ID="lblName" runat="server" meta:resourcekey="lblName" />:</p>
			</td>
			<td>
				<asp:TextBox ID="txtName" runat="server" Width="200px" meta:resourcekey="txtName" CausesValidation="True" />
				<asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" meta:resourcekey="rfvRequired"><img src="Images/InputError.png" alt="*" /></asp:RequiredFieldValidator>
			</td>
		</tr>
		<tr>
			<td>
				<p style="text-align: right;">
					<asp:Literal ID="lblEmail" runat="server" meta:resourcekey="lblEmail" /></p>
			</td>
			<td>
				<asp:CheckBox ID="chkPublishEmail" runat="server" meta:resourcekey="chkPublishEmail" Checked="false" />
			</td>
		</tr>
		<tr>
			<td>
				<p style="text-align: right;">
					<asp:Literal ID="lblBlog" runat="server" meta:resourcekey="lblBlog" />:</p>
			</td>
			<td>
				<asp:TextBox ID="txtBlog" runat="server" Width="200px" meta:resourcekey="txtBlog" CausesValidation="True" />
				<asp:RegularExpressionValidator ID="revBlog" runat="server" ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&amp;=]*)?"
					ControlToValidate="txtBlog" meta:resourcekey="revUrl"><img src="Images/InputError.png" alt="*" /></asp:RegularExpressionValidator>
			</td>
		</tr>
		<tr>
			<td>
				<p style="text-align: right;">
					<asp:Literal ID="lblTwitterUserName" runat="server" meta:resourcekey="lblTwitterUserName" />:</p>
			</td>
			<td>
				<asp:TextBox ID="txtTwitterUserName" runat="server" Width="200px" meta:resourcekey="txtTwitterUserName" CausesValidation="True" />
			</td>
		</tr>
		<tr>
			<td>
				<p style="text-align: right;">
					<asp:Literal ID="lblXingUserName" runat="server" meta:resourcekey="lblXingUserName" />:</p>
			</td>
			<td>
				<asp:TextBox ID="txtXingUserName" runat="server" Width="200px" meta:resourcekey="txtXingUserName" CausesValidation="True" />
			</td>
		</tr>
		<tr>
			<td>
				<p style="text-align: right;">
					<asp:Literal ID="lblPicture" runat="server" meta:resourcekey="lblPicture" />:</p>
			</td>
			<td>
				<asp:TextBox ID="txtPicture" runat="server" Width="200px" meta:resourcekey="txtPicture" CausesValidation="True" />
				<asp:RegularExpressionValidator ID="revPicture" runat="server" ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/.*)?"
					ControlToValidate="txtPicture" meta:resourcekey="revUrl"><img src="Images/InputError.png" alt="*" /></asp:RegularExpressionValidator>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<p>
					Die Teilnahme am .NET Open Space 2009 in Leipzig ist völlig kostenlos. Wenn du möchtest, kannst du den <a href="Organisation.ashx">
						Organisatoren</a> einen Geldbetrag zukommen lassen, welcher für die Gestaltung (Abendveranstaltung, Getränke etc.) verwendet
					wird. Trage den Betrag hier mit in die Teilnehmerliste ein. <a href="mailto:tweber@netopenspace.de">Torsten</a> gibt dir dann per
					E-Mail wegen einer Rechnung Bescheid. Über die Höhe des Betrages, ob z. B. 25 EUR, 50 EUR, 100 EUR
					oder mehr, entscheidest du vollkommen frei und selbst. <strong>Bedenke, dass die Veranstaltung gerade vom Sponsoring der Teilnehmer
						lebt.</strong>
				</p>
			</td>
		</tr>
		<tr>
			<td>
				<p style="text-align: right;">
					<asp:Literal ID="lblSponsoring" runat="server" meta:resourcekey="lblSponsoring" />:</p>
			</td>
			<td>
				<p>
				<asp:TextBox ID="txtSponsoring" runat="server" Width="200px" meta:resourcekey="txtSponsoring" CausesValidation="True" />
				&euro;
				<asp:RangeValidator ID="rngSponsoring" runat="server" ControlToValidate="txtSponsoring" meta:resourcekey="rngSponsoring"
					MinimumValue="0" MaximumValue="9999999" Type="Currency"><img src="Images/InputError.png" alt="*" /></asp:RangeValidator>
				</p>
			</td>
		</tr>
	</table>
	<table width="100%" cellpadding="0" cellspacing="4">
		<colgroup>
			<col width="30%" />
			<col width="*" />
		</colgroup>
</asp:Panel>
