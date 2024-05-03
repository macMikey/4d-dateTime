//%attributes = {}
var $x : cs.dateTime

$x:=cs.dateTime.new()  //now
ALERT($x.dateString)

$x:=cs.dateTime.new("02/14/23")
ALERT(String($x.seconds))

$o:=New object("date"; Current date; "time"; Current time)
$x:=cs.dateTime.new($o)
ALERT($x.ISO)

$x:=cs.dateTime.new("+")  // quickenDate format
ALERT($x.dateTimeShortString)
