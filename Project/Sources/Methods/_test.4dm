//%attributes = {}
var $x : cs._dateTime

$x:=cs._dateTime.new()  //now
ALERT($x.dateString)

$x:=cs._dateTime.new("02/14/23")
ALERT(String($x.seconds))

$o:=New object("date"; Current date; "time"; Current time)
$x:=cs._dateTime.new($o)
ALERT($x.ISO)

$x:=cs._dateTime.new("+")  // quickenDate format
ALERT($x.dateTimeShortString)
