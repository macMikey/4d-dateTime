//%attributes = {}
var $x : cs.static

$x:=cs.static.new()  //now
ALERT($x.dateString)

$x:=cs.static.new("02/14/23")
ALERT(String($x.seconds))

$o:=New object("date"; Current date; "time"; Current time)
$x:=cs.static.new($o)
ALERT($x.ISO)

$x:=cs.static.new("+")  // quickenDate format
ALERT($x.dateTimeShortString)
