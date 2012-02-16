<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LanguageSelector.ascx.cs" Inherits="ScrewTurn.Wiki.LanguageSelector" %>

<asp:DropDownList ID="lstLanguages" runat="server" />
<asp:DropDownList ID="lstTimezones" runat="server">
    <asp:ListItem Value="-720" Text="(GMT-12:00) International Date Line West" />
    <asp:ListItem Value="-660" Text="(GMT-11:00) Midway Island, Samoa" />
    <asp:ListItem Value="-600" Text="(GMT-10:00) Hawaii" />
    <asp:ListItem Value="-540" Text="(GMT-09:00) Alaska" />
    <asp:ListItem Value="-480" Text="(GMT-08:00) Pacific" />
    <asp:ListItem Value="-420" Text="(GMT-07:00) Mountain" />
    <asp:ListItem Value="-360" Text="(GMT-06:00) Central" />
    <asp:ListItem Value="-300" Text="(GMT-05:00) Eastern" />
    <asp:ListItem Value="-240" Text="(GMT-04:00) Atlantic" />
    <asp:ListItem Value="-210" Text="(GMT-03:30) Newfoundland" />
    <asp:ListItem Value="-180" Text="(GMT-03:00) Greenland" />
    <asp:ListItem Value="-120" Text="(GMT-02:00) Mid-Atlantic" />
    <asp:ListItem Value="-60" Text="(GMT-01:00) Azores" />
    <asp:ListItem Value="0" Text="(GMT) Greenwich" />
    <asp:ListItem Value="60" Text="(GMT+01:00) Central European" />
    <asp:ListItem Value="120" Text="(GMT+02:00) Eastern European" />
    <asp:ListItem Value="180" Text="(GMT+03:00) Moscow, Baghdad" />
    <asp:ListItem Value="210" Text="(GMT+03:30) Iran" />
    <asp:ListItem Value="240" Text="(GMT+04:00) Abu Dhabi, Dubai" />
    <asp:ListItem Value="270" Text="(GMT+04:30) Kabul" />
    <asp:ListItem Value="300" Text="(GMT+05:00) Islamabad, Karachi" />
    <asp:ListItem Value="330" Text="(GMT+05:30) India" />
    <asp:ListItem Value="345" Text="(GMT+05:45) Kathmandu" />
    <asp:ListItem Value="360" Text="(GMT+06:00) Astana, Dhaka" />
    <asp:ListItem Value="390" Text="(GMT+06:30) Rangoon" />
    <asp:ListItem Value="420" Text="(GMT+07:00) Bangkok, Jakarta" />
    <asp:ListItem Value="480" Text="(GMT+08:00) China Coast, Western Australia" />
    <asp:ListItem Value="540" Text="(GMT+09:00) Japan, Korea" />
    <asp:ListItem Value="570" Text="(GMT+09:30) Central Australia" />
    <asp:ListItem Value="600" Text="(GMT+10:00) Eastern Australia" />
    <asp:ListItem Value="660" Text="(GMT+11:00) Magadan, Solomon Is." />
    <asp:ListItem Value="720" Text="(GMT+12:00) New Zealand, Fiji" />
    <asp:ListItem Value="765" Text="(GMT+12:45) Chatham Island NZ" />
    <asp:ListItem Value="780" Text="(GMT+13:00) Tonga, Phoenix Islands" />
    <asp:ListItem Value="840" Text="(GMT+14:00) Christmas Islands" />
</asp:DropDownList>
