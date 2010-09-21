Hallo $user.Data.Name!

Beim Anlegen deines Eintrags in der Teilnehmerliste kam es leider zu Problemen. Die Administratoren sind benachrichtigt, bitte trage dich selbst ein.

${settings.MainUrl}Teilnehmer.ashx

Zusammenfassung deiner wichtigsten Daten:
Wiki-Benutzername: $user.UserName
Name für Namenschild: $!user.Data.Name
E-Mail-Adresse: $!user.Data.Email

Du sponserst $user.Data.Sponsoring EUR. #if ($user.Data.Sponsoring > 0)Vielen Dank dafür! Die Rechnung senden wir an:
$user.Data.InvoiceAddress#end


Beste Grüße,
Das ${settings.WikiTitle}-Team.