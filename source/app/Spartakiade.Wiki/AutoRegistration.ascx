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

			var elements = $("#user-data input, #user-data textarea, #user-data .prefix");			
			elements.attr("disabled", enabled ? "" : "disabled");
			if (enabled)
			{
				elements.removeClass("disabled");
			}
			else
			{
				elements.addClass("disabled");
			}
			$(this).attr("disabled", "");
		});

		$("#<%=chkAutoRegister.ClientID %>").trigger("change");

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
					.attr("title", "Link testen");

				if (!$(element).hasClass("has-prefix"))
				{
					$(element).parent().children(":last").after("<br>");
				}

				$(element).parent().children(":last").after(link);
			}

			$(link).attr("href", href)

			if ($(element).hasClass("has-prefix"))
			{
				$(link).html("&#65279;");
			}
			else
			{
				$(link).text(href);
			}
		}

		$("#<%=txtXingUserName.ClientID %>").data("href", function(e) { return "http://www.xing.com/profile/" + $(e).val(); });
		$("#<%=txtTwitterUserName.ClientID %>").data("href", function(e) { return "http://twitter.com/" + $(e).val() + "/"; });
		$("#<%=txtBlog.ClientID %>").data("href", function(e) { return $(e).val(); });
		$("#<%=txtPicture.ClientID %>").data("href", function(e) { return $(e).val(); });

		$(".linkify")
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

		$("span.prefix")
			.each(function()
			{
				$(this).click(function()
				{
					$(this).next().focus();
				});
			});
	});
</script>

<asp:Panel ID="AutoRegistrationPanel" runat="server">
	</table>
	<h1 class="pagetitlesystem">Registrierung zum .NET Open Space</h1>
	<p>
		<asp:Literal ID="litIntroduction1" runat="server" meta:resourcekey="litIntroduction1" />
		<asp:HyperLink ID="lnkAttendeeList1" runat="server" meta:resourcekey="lnkAttendeeList" NavigateUrl="Teilnehmer.ashx" />
		<asp:Literal ID="litIntroduction2" runat="server" meta:resourcekey="litIntroduction2" />
		<asp:HyperLink ID="lnkAttendeeList2" runat="server" meta:resourcekey="lnkAttendeePage" NavigateUrl="Teilnehmer.ashx" />
		<asp:Literal ID="litIntroduction3" runat="server" meta:resourcekey="litIntroduction3" />
	</p>
	<br />
	<table width="100%" cellpadding="0" cellspacing="4" id="user-data">
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
				<asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" meta:resourcekey="rfvRequired" Display="Dynamic" CssClass="resulterror" />
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
				<asp:TextBox ID="txtBlog" runat="server" Width="200px" meta:resourcekey="txtBlog" CssClass="linkify" CausesValidation="True" />
				<asp:RegularExpressionValidator ID="revBlog" runat="server" ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&amp;=]*)?"
					ControlToValidate="txtBlog" meta:resourcekey="revUrl" Display="Dynamic" CssClass="resulterror" />
			</td>
		</tr>
		<tr>
			<td>
				<p style="text-align: right;">
					<asp:Literal ID="lblTwitterUserName" runat="server" meta:resourcekey="lblTwitterUserName" />:</p>
			</td>
			<td>
				<span class="prefix">http://twitter.com/</span><asp:TextBox ID="txtTwitterUserName" runat="server" Width="261px" meta:resourcekey="txtTwitterUserName" CssClass="linkify has-prefix" CausesValidation="True" />
			</td>
		</tr>
		<tr>
			<td>
				<p style="text-align: right;">
					<asp:Literal ID="lblXingUserName" runat="server" meta:resourcekey="lblXingUserName" />:</p>
			</td>
			<td>
				<span class="prefix">http://www.xing.com/profile/</span><asp:TextBox ID="txtXingUserName" runat="server" Width="200px" meta:resourcekey="txtXingUserName" CssClass="linkify has-prefix" CausesValidation="True" />
			</td>
		</tr>
		<tr>
			<td>
				<p style="text-align: right;">
					<asp:Literal ID="lblPicture" runat="server" meta:resourcekey="lblPicture" />:</p>
			</td>
			<td>
				<asp:TextBox ID="txtPicture" runat="server" Width="200px" meta:resourcekey="txtPicture" CssClass="linkify" CausesValidation="True" />
				<asp:RegularExpressionValidator ID="revPicture" runat="server" ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/.*)?"
					ControlToValidate="txtPicture" meta:resourcekey="revUrl" Display="Dynamic" CssClass="resulterror" />
			</td>
		</tr>
		<tr class="highlight">
			<td colspan="2">
				<p>
					Die Teilnahme am .NET Open Space ist v�llig kostenlos. Wenn du m�chtest, kannst du der
					<a href="Organisation.ashx">Organisation</a> einen Geldbetrag zukommen lassen, welcher f�r die Gestaltung
					(Mittagessen, Getr�nke etc.) verwendet wird.
					�ber die H�he des Betrages, ob z. B. 25 EUR, 50 EUR, 100 EUR oder mehr, entscheidest du vollkommen frei und selbst.
					<strong>Bedenke, dass die Veranstaltung gerade vom Sponsoring der Teilnehmer lebt.</strong>
					<br/>
					<br/>
				</p>
				<%--<p>
					Die Organisation weist darauf hin, dass wir aufgrund der gro�en Teilnehmerzahl aktuell Neuanmeldungen, die keinen freiwilligen
					Sponsoringbetrag zur Ausgestaltung der Veranstaltung leisten, auf die Warteliste setzen.
				</p>--%>
			</td>
		</tr>
		<tr class="highlight">
			<td>
				<p style="text-align: right;">
					<asp:Literal ID="lblSponsoring" runat="server" meta:resourcekey="lblSponsoring" />:</p>
			</td>
			<td>
				<asp:TextBox ID="txtSponsoring" runat="server" Width="200px" meta:resourcekey="txtSponsoring" CausesValidation="True" />
				&euro;
				<asp:RangeValidator ID="rngSponsoring" runat="server" ControlToValidate="txtSponsoring" meta:resourcekey="rngSponsoring"
					MinimumValue="0" MaximumValue="9999999" Type="Currency" Display="Dynamic" CssClass="resulterror" />
			</td>
		</tr>
		<tr class="highlight">
			<td>
				<p style="text-align: right;">
					<asp:Label ID="lblInvoiceAddress" runat="server" meta:resourcekey="lblInvoiceAddress" />:</p>
			</td>
			<td>
				<asp:TextBox ID="txtInvoiceAddress" runat="server" Width="75%" Height="100px" meta:resourcekey="txtInvoiceAddress" 
					CausesValidation="True" TextMode="MultiLine"/>
				<br />
				<asp:CustomValidator ID="rfvInvoiceAddress" 
									 Display="Dynamic"
									 runat="server"  
									 ControlToValidate="txtInvoiceAddress" 
									 OnServerValidate="rfvInvoiceAddress_ServerValidate" 
									 meta:resourcekey="rfvInvoiceAddress" 
									 EnableClientScript="False"
									 CssClass="resulterror" ValidateEmptyText="True" />
				<div>
					<asp:Literal ID="litInvoice" runat="server" meta:resourcekey="litInvoice" />
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<p>Die <a href="Veranstalter.ashx">Veranstalter</a> behalten sich das Recht vor, die Veranstaltung aus wichtigen Gr�nden zu verschieben, �nderungen vorzunehmen oder abzusagen. Gezahlte Betr�ge werden dann erstattet. �nderungen an der Agenda sind m�glich.</p>
			</td>
		</tr>
	</table>
	<table style="width: 100%; margin-top: 2em;" cellpadding="0" cellspacing="4">
		<colgroup>
			<col width="30%" />
			<col width="*" />
		</colgroup>
</asp:Panel>
