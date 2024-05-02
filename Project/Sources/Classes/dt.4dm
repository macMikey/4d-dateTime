Class constructor($theThing : Variant; $zuluOrLocal : Variant)
	This._computeTimezoneOffset()  // do first b/c we're going to immediately start computing offsets to it
	This.nowSeconds:=This._computeNowSeconds()
	This.seconds:=This.nowSeconds
	This._localSeconds:=This.nowSeconds+This.timezoneOffsetSeconds
	
	//<populate or compute this.seconds and this.localSeconds>
	If (Value type($theThing)=Is text)  // quicken date
		$date:=This._qDate($theThing)
		$zuluOrLocal:="local"
		$theThing:=$date
	End if   // $valueType= "is text"
	
	$valueType:=Value type($theThing)
	$zuluOrLocal:=$zuluOrLocal || "local"  //default to local for objects and dates b/c 4d date/time are local
	Case of 
		: ($valueType=Is object)  // passed dateTimeObject
			This.seconds:=This._dateTimeToSeconds($theThing; $zuluOrLocal)
		: ($valueType=Is real)  //passed seconds // 4d can't tell that integers are just integers
			$zuluOrLocal:="zulu"  // don't accept local seconds
			This.seconds:=$theThing
		: ($valueType=Is date)
			var $o : Object
			$o:=New object("date"; $theThing; "time"; Time("00:00:00"))
			This.seconds:=This._dateTimeToSeconds($o; $zuluOrLocal)
		Else   //nothing or something else passed for value type, i.e. now()
			//already computed .nowSeconds, do nothing
	End case 
	This._localSeconds:=This.seconds+This.timezoneOffsetSeconds
	//</populate or compute this.seconds and this.localSeconds>
	
	This._computeProperties()  // date, time, strings
	// _______________________________________________________________________________________________________________
	
	
	
Function _computeNowSeconds()  // in zulu
	$Epoch_Date_D:=Date("1/1/1970")
	
	$today:=Current date
	$days:=$today-$Epoch_Date_D
	$secondsToToday:=$days*86400
	$timeString:=String(Current time)
	$hourString:=Substring($timeString; 1; 2)
	$hour:=Num($hourString)
	$minuteString:=Substring($timeString; 4; 2)
	$minute:=Num($minuteString)
	$secondString:=Substring($timeString; 7; 2)
	$second:=Num($secondString)
	$secondsSinceMidnight:=(3600*$hour)+(60*$minute)+$second
	return $secondsToToday+$secondsSinceMidnight-This.timezoneOffsetSeconds  // 4D date/time are in local, and we are returning zulu
	// _______________________________________________________________________________________________________________
	
	
	
Function _computeTimezoneOffset()
	$zuluTimestamp:=Timestamp
	$localTimestamp:=Substring($zuluTimestamp; 1; 23)  // remove the z
	
	This.timezoneOffsetSeconds:=((Date($zuluTimestamp)-Date($localTimestamp))*86400)+((Time($zuluTimestamp)-Time($localTimestamp))*1)
	// _______________________________________________________________________________________________________________
	
	
	
Function _computeProperties()
	var $EpochDtTi_L; $SecsPerDay_L; $SecToToday_L; $Rem_L : Integer
	var $Today_D : Date
	var $Time_H : Time
	
	$Epoch_Date_D:=Date("1/1/1970")
	$SecsPerDay_L:=60*60*24
	
	
	//<compute props for local time>
	$theSeconds:=This._localSeconds
	$SecToToday_L:=$theSeconds\$SecsPerDay_L
	$Today_D:=Add to date($Epoch_Date_D; 0; 0; $SecToToday_L)
	
	$Rem_L:=$theSeconds-($SecToToday_L*86400)
	$Time_H:=Time($Rem_L)
	
	This.date:=$today_D
	This.YYYYMMDD:=String(Year of($today_d); "0000")+String(Month of($today_D); "00")+String(Day of($today_D); "00")
	This.dateString:=String($today_D)  // no particular format
	This.dayNumber:=Day number(This.date)
	This.time:=Time($Rem_L)  // 4d doesn't assign times (even declared times) properly
	This.timeString:=String($time_H)  // no particular format
	This.dateTimeString:=This.dateString+" "+This.timeString
	//<generate a longer version of HH MM AMPM b/c HH MM AMPM does not give 2 digts for hour if hour < 10
	$timeString:=String(Time(This.time); HH MM AM PM)
	If (Length($timeString)#8)
		$timeString:="0"+$timeString
	End if   //Length($timeString)#8
	//</generate a longer version of HH MM AMPM b/c HH MM AMPM does not give 2 digts for hour if hour < 10
	This.dateTimeShortString:=String(This.date; Internal date short special)+" "+$timeString
	This.ISO:=String($Today_D; ISO date; $Time_H)  // ISO format
	//</computed props for local time>
	
	// _______________________________________________________________________________________________________________
	
	
	
Function _dateTimeToSeconds($dateTimeObject : Object; $timezone : Variant)  //computes zulu for seeding the object
	$timezone:=$timezone || "local"  //4d's date and time are local, so we expect them to come in local
	
	$Epoch_Date_D:=Date("1/1/1970")
	
	$numDays:=$dateTimeObject.date-$Epoch_Date_D
	$secondsToToday:=$numDays*86400
	$secondsSinceMidnight:=Num($dateTimeObject.time)
	If ($timezone="zulu")
		$offset:=0
	Else 
		$offset:=This.timezoneOffsetSeconds  // but negate, below in the math b/c we expect to go from local to zulu
	End if 
	return $secondsToToday+$secondsSinceMidnight-$offset  // returning zulu from presumed local.
	// _______________________________________________________________________________________________________________
	
	
	
Function _qDate($string : Text)->$date : Date
	
	$currentMonthString:=String(Month of(Current date(*)))
	$currentYearString:=String(Year of(Current date(*)))
	$firstDateOfThisMonth:=Date($currentMonthString+"/01/"+$currentYearString)
	
	Case of 
		: ($string="T")  // today
			$date:=Current date(*)
		: ($string="Y")  // first date of year
			$date:=Date("01/01/"+$currentYearString)
		: ($string="R")  // last date of year
			$date:=Date("12/31/"+$currentYearString)
		: ($string="M")  // first date of month
			$date:=$firstDateOfThisMonth
		: ($string="H")  // last date of month
			$date:=Add to date($firstDateOfThisMonth; 0; 1; -1)  // i.e. advance a month and move back a day or
			// subtract a day and advance a month.  Either way, since we have the first day
			// of this month, and we want the last day of this month, we need to get to either
			// the first day of next month and subtract a day or the last day of last month 
			// and add a month.
		: ($string="W")  // first date of week.  Assume Sunday
			$date:=Current date(*)-(Day number(Current date(*))-1)  // b/c Sunday is number 1 not number 0.
		: ($string="K")  // last date of week.  Assume Saturday.
			$date:=Current date(*)+(7-Day number(Current date(*)))  // Saturday is day 7.
		: ($string="+")
			$date:=Current date(*)+1
		: ($string="-")
			$date:=Current date(*)-1
		Else   // none of the above, just a date-ish string.  Could be month, day and year, or
			// or month and day or just day.    
			$TestDate:=Date($string)
			If ($TestDate=!00-00-00!)  // Isn't a valid date as-is, so tack on year first, try again.    
				$string:=$string+"/"+$currentYearString
				$TestDate:=Date($string)
				If ($TestDate=!00-00-00!)  // Still isn't valid, so tack on month, too.
					$string:=$currentMonthString+"/"+$string
					$TestDate:=Date($string)
				End if   // ($TestDate=!00/00/00!)
			End if   // ($TestDate=!00/00/00!)    
			$date:=$TestDate
	End case 
	// _______________________________________________________________________________________________________________