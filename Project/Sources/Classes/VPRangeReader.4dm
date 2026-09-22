// Reads the coordinates and dimensions of a View Pro range or combined range.
property range : Object
// Index of the range currently being read.
property _rangeNumber : Integer

// Stores the supplied range and selects its first component.
Class constructor($range : Object)
	
	If ($range=Null:C1517)
		This:C1470.range:=New object:C1471  // Original range
	Else 
		This:C1470.range:=$range  // Original range
	End if 
	
	// Number of the 'current' range 
	This:C1470._rangeNumber:=0
	
// Returns the name of the View Pro area containing the range.
Function areaName()->$name : Text
	$name:=This:C1470.range.area
	
	// Sets or returns the index of the current range component.
Function rangeNumber($number : Integer)->$rangeNumber : Integer
	If (Count parameters:C259>0)
		If ($number<This:C1470.length())
			This:C1470._rangeNumber:=$number
		End if 
	End if 
	$rangeNumber:=This:C1470._rangeNumber
	
	
	// Returns the number of components in the original range.
Function length()->$length : Integer
	$length:=This:C1470.range.ranges.length
	
	// Indicates whether the original range has no components.
Function isEmpty()->$isEmpty : Boolean
	$isEmpty:=(This:C1470.length()=0)
	
	// Returns the starting row of the current range component.
Function row()->$row : Integer
	If (This:C1470.isEmpty())
		$row:=0
	Else 
		If (This:C1470.range.ranges[This:C1470._rangeNumber].row#Null:C1517)
			$row:=Num:C11(This:C1470.range.ranges[This:C1470._rangeNumber].row)
		Else 
			$row:=0
		End if 
	End if 
	
	// Returns the number of rows in the current range component.
Function rowCount()->$rowc : Integer
	If (This:C1470.isEmpty())
		$rowc:=1
	Else 
		If (This:C1470.range.ranges[This:C1470._rangeNumber].rowCount#Null:C1517)
			$rowc:=Num:C11(This:C1470.range.ranges[This:C1470._rangeNumber].rowCount)
		Else 
			If (This:C1470.range.ranges[This:C1470._rangeNumber].row#Null:C1517)
				$rowc:=1
			Else 
				$rowc:=-1
			End if 
		End if 
	End if 
	
	// Returns the starting column of the current range component.
Function column()->$column : Integer
	If (This:C1470.isEmpty())
		$column:=0
	Else 
		If (This:C1470.range.ranges[This:C1470._rangeNumber].column#Null:C1517)
			$column:=Num:C11(This:C1470.range.ranges[This:C1470._rangeNumber].column)
		Else 
			$column:=0
		End if 
	End if 
	
	// Returns the number of columns in the current range component.
Function columnCount()->$columnc : Integer
	If (This:C1470.isEmpty())
		$columnc:=1
	Else 
		If (This:C1470.range.ranges[This:C1470._rangeNumber].columnCount#Null:C1517)
			$columnc:=Num:C11(This:C1470.range.ranges[This:C1470._rangeNumber].columnCount)
		Else 
			If (This:C1470.range.ranges[This:C1470._rangeNumber].column#Null:C1517)
				$columnc:=1
			Else 
				$columnc:=-1
			End if 
		End if 
	End if 
	
	// Returns the worksheet index of the current range component.
Function sheet()->$sheet : Integer
	var $js : Text
	If (This:C1470.isEmpty())
		$js:="(function (){"
		$js:=$js+"return Utils.spread.getActiveSheetIndex();"
		$js:=$js+"})();"
		$sheet:=WA Evaluate JavaScript:C1029(*; This:C1470.range.area; $js; Is integer:K8:5)
	Else 
		If (This:C1470.range.ranges[This:C1470._rangeNumber].sheet=Null:C1517)
			$js:="(function (){"
			$js:=$js+"return Utils.spread.getActiveSheetIndex();"
			$js:=$js+"})();"
			$sheet:=WA Evaluate JavaScript:C1029(*; This:C1470.range.area; $js; Is integer:K8:5)
		Else 
			$sheet:=Num:C11(This:C1470.range.ranges[This:C1470._rangeNumber].sheet)
		End if 
	End if 
	
	// Returns the first component of the original range.
Function firstRange()->$range : Object
	If (This:C1470.length()>1)
		$range:=This:C1470._splitRange(0)
	Else 
		$range:=This:C1470.range
	End if 
	
	// Returns the last component of the original range.
Function lastRange()->$range : Object
	If (This:C1470.length()>1)
		$range:=This:C1470._splitRange(This:C1470.length()-1)
	Else 
		$range:=This:C1470.range
	End if 
	
// Advances to and returns the next range component.
Function nextRange()->$range : Object
	This:C1470._rangeNumber:=This:C1470._rangeNumber+1
	If (This:C1470._rangeNumber<This:C1470.length())
		$range:=This:C1470._splitRange(This:C1470._rangeNumber)
	Else 
		$range:=Null:C1517
	End if 
	
	// Returns the currently selected range component.
Function currentRange()->$range : Object
	If (This:C1470.length()>1)
		$range:=This:C1470._splitRange(This:C1470._rangeNumber)
	Else 
		$range:=This:C1470.range
	End if 
	
	// Creates a single-range object for a component of the original range.
Function _splitRange($pos : Integer)->$newRange : Object
	$newRange:=New object:C1471("area"; This:C1470.range.area; "ranges"; New collection:C1472())
	$newRange.ranges.push(This:C1470.range.ranges[$pos])
	
	// Converts the current range coordinates to A1 notation.
Function toLetter()->$formula : Text
	var $js : Text
	
	$js:="(function (){"
	$js:=$js+"var range=[new GC.Spread.Sheets.CellRange("+String:C10(This:C1470.sheet())+","+String:C10(This:C1470.row())+","+String:C10(This:C1470.column())+","+String:C10(This:C1470.rowCount())+","+String:C10(This:C1470.columnCount())+")];"
	$js:=$js+"return GC.Spread.Sheets.CalcEngine.rangesToFormula(range);"
	$js:=$js+"})();"
	$formula:=WA Evaluate JavaScript:C1029(*; This:C1470.areaName(); $js; Is text:K8:3)
	