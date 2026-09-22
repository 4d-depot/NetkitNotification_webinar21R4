If (FORM Event:C1606.code=On VP Ready:K2:59)
	Form:C1466.calendar:=cs:C1710.Form_Calendar.new()
	Form:C1466.calendar.viewProEvent()
End if 
