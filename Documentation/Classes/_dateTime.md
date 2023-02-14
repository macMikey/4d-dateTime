<!-- Class for date/time maniupulation -->

# class _dateTime ( $input : variant { $timezone : text } )



## Description

* Class for more date/time manipulations

* Accepts:

  * Seconds 

  * An object with date/time

  * A [Quicken-format date](#quicken-formatted-date)

* Uses zulu or local timezone

  

## Class Constructor

**Creating the class will also assign all the properties, including converting the time passed into the various properties**

**Note:** LC will send zulu seconds

  

**First parameter (initial value) options**:

Parameters | Datatype | Description
--|--|--
***(omitted)*** | N/A | * Populates the object with now()<br>* Ignores the timezone callout
quicken-format date | text | assumes local timezone
dateTimeObject | object | object with the following structure:<br>*"date"*: 4D Date<br>*"time"*: 4D Time
seconds | longint | seconds<br>**Ignores 2nd param (timezone)**: seconds are always seconds from the epoch (January 1, 1970, 00:00 GMT) 
 date | date |4d date (assumes midnight on that date)



**Second parameter (timezone) options**:

Parameters | Datatype | Mandatory | Description | Default if omitted
--|--|--|--|--
timezone | text | optional | "local"<br>"zulu" | local<br>see above for cases when it is ignored 



## Quicken-Formatted Dates <a name="quicken-formatted-date"></a>

* Quicken-formatted dates are a way to quickly express a date without having to remember the date or look it up.
* Quicken-formatted dates can also be full-length or shortened-versions of dates:
	* M/D/Y, MM/DD/YY, etc.
	* M/D (assumes current year)
	* D (as in the date in the current month in the current year)
* Other delimiters, such as comma, space, dot are also accepted.
* There are additional codes, as well:

Code | Meaning
-- | --
T | Today
\+ | Tomorrow (as in Today +1) 
\- | Yesterday (as in Today -1) 
M | First day of the current (M)onth
H | Last day of the current mont(H)
W | First day of the (W)eek (Assume Sunday)
K | Last day of the wee(K) (Assume Saturday)
Y | First day of the (Y)ear
R | Last day of the yea(R)




## Public Properties

Don't forget that setting one of these properties will not trigger the others to update.

Property | time zone |Description | Datatype
--|--|--|--
.date | local | Date in 4D Date format | date
.dateString | local |string representation of date | text
.dateTimeShortString | local | MM/DD/YY HH:MM AM/PM | text
.dateTimeString | local | **.dateString** <sp> **.timeString** | text
.dayNumber | local | 1 (sunday) .. 7 (saturday) | integer
.ISO | local |Date/Time in ISO format | text  
.nowSeconds | **zulu** | now(), regardless of what was passed in | longint 
.seconds | **zulu** | Seconds in zulu timezone, because it's less confusing if we just keep them in zulu | longint
.time | local |Time in 4D Time format | time
.timeString | local |String representation of time | text
.timezoneOffsetSeconds | N/A |Time offset to zulu | longint 
.YYYYMMDD | local | duh |string





## Public API

N/A



## Examples
```4d
$dt:=cDateTime.new( $seconds )
alert ( $dt.dateString ) // because $seconds were passed, the date is computed
```



## Private Properties

Don't forget that setting one of these properties will not trigger the others to update.

Property | time zone |Description | Datatype
--|--|--|--
._localSeconds | local | the seconds of the object (now or whatever was passed in). Private b/c not intended for use except for conversions | longint



## Private API

### **_computeNowSeconds**()

* Called when class is instantiated if no value is passed in to populate with now()
* Returns zulu seconds



### _computeTimezoneOffset()

* Called when class instantiated

* Calculates **.timezoneOffset** based on current timezone.

* the offset is negative for points west of GMT0, i.e. USA is negative



### **_computeProperties**()

* Uses the seconds for the instance to compute the other properties




### _dateTimeToSeconds($dateTimeObject : Object; $timezone : Variant) -> $seconds : longint
* Uses a dateTime object to compute seconds 
* Output is in zulu for seeding the object
