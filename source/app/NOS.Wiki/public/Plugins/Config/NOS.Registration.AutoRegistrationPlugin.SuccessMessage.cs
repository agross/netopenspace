Hallo $user.Data.Name!

Deinem Wunsch nach automatischer Eintragung in die Teilnehmerliste sind wir nachgekommen, du bist nun auf der Teilnehmerliste bzw. Warteliste eingetragen. Bitte prüfe deinen Eintrag online unter:

${settings.MainUrl}Teilnehmer.ashx

Zusammenfassung deiner wichtigsten Daten:
Wiki-Benutzername: $user.UserName
Name für Namenschild: $!user.Data.Name
E-Mail-Adresse: $!user.Data.Email

Du sponserst $user.Data.Sponsoring EUR. #if ($user.Data.Sponsoring > 0)Vielen Dank dafür! Die Rechnung senden wir an:
$user.Data.InvoiceAddress#end


Beste Grüße,
Das ${settings.WikiTitle}-Team.