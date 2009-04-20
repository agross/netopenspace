PageName=Teilnehmer
ListStartPattern=^\s*==\[anchor\|#Teilnehmer\]Teilnehmer==\s*$
ListEndPattern=^\s*<!-- hier davor eintragen, nachfolgenden Zeilenumbruch bitte nicht entfernen -->\s*$
WaitingListEndPattern=^\s*<!-- hier davor alphabetisch sortiert eintragen, nachfolgenden Zeilenumbruch bitte nicht entfernen -->\s*$
EntryPattern=^#.*$
MaximumAttendees=90
EntryTemplate=# $user.Data.Name#if($user.Data.Email), [$user.Data.Email|E-Mail]#end#if($user.Data.Blog), [$user.Data.Blog|Blog]#end#if($user.Data.Twitter), [http://twitter.com/$user.Data.Twitter/|Twitter]#end#if($user.Data.Xing), [http://xing.com/profile/$user.Data.Xing|XING]#end#if($user.Data.Picture), [$user.Data.Picture|Bild]#end\n\n