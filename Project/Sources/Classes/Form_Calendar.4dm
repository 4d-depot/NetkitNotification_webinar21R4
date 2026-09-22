// Path to the calendar resource file.
property _FilePath : Text:=Folder:C1567(fk resources folder:K87:11).file("Scheduler.sjs").platformPath
// Name of the View Pro area hosting the calendar.
property _VPArea : Text:="ViewProArea"
// Calendar display helper used by the form.
property _calendarDisplay : Object

// Creates the calendar display helper.
Class constructor
	This:C1470._calendarDisplay:=cs:C1710.CalendarDisplay.new(This:C1470._VPArea)
	
	// Imports the calendar template when the View Pro area is ready.
Function viewProEvent()
	If (FORM Event:C1606.code=On VP Ready:K2:59)
		
		VP IMPORT DOCUMENT(This:C1470._VPArea; This:C1470._FilePath; {formula: Formula:C1597(Form:C1466.calendar.initCalendar())})
		
	End if 
	
	// Displays the supplied events in the calendar.
Function displayCalendar($events : Collection)
	This:C1470._calendarDisplay.displayCalendar($events)
	
	// Initializes the calendar grid and current-day indicators.
Function initCalendar()
	This:C1470._calendarDisplay.initCalendar()