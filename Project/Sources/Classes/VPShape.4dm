// Name of the View Pro area containing the shapes.
property areaName:=""
// JavaScript expression used to access the active worksheet.
property activeSheet:="var activeSheet=Utils.spread.getActiveSheet();"
// Default shape appearance.
property defaultBackColor:="#DCEBFF"
property defaultTextColor:="black"
property defaultFont:="11px Arial"

// Stores the View Pro area name.
Class constructor($areaName : Text)
	
	This:C1470.areaName:=$areaName
	
// Creates a non-editable rounded rectangle positioned over a range.
// Algorithm: Builds JavaScript to add Spread.js shape with custom styling and positioning.
// Constructs style object with fill color, text color, font, line properties, applies to shape,
// then sets position offsets and grid coordinates from the provided range.
Function addFromRange($name : Text; $text : Text; $range : Object; $textColor : Text; $backgroundColor : Text)
	
	var $js; $answer : Text
	var $rangeTmp : cs:C1710.VPRangeReader
	
	// Default to background color if text color not provided
	$textColor:=$textColor#"" ? $textColor : This:C1470.defaultBackColor
	// Default to background color if background color not provided
	$backgroundColor:=$backgroundColor#"" ? $backgroundColor : This:C1470.defaultBackColor
	
	// Parse range object to extract coordinates
	$rangeTmp:=cs:C1710.VPRangeReader.new($range)
	
	// Initialize JavaScript with active sheet reference
	$js:=This:C1470.activeSheet
	
	// Create rounded rectangle shape in Spread.js
	$js+="var shape=activeSheet.shapes.add('"+$name+"', GC.Spread.Sheets.Shapes.AutoShapeType.roundedRectangle, 0, 0, 1, 1);"
	
	// Fetch current shape style object
	$js+="var oldStyle = shape.style();"
	// Apply background fill color
	$js+="oldStyle.fill.color = '"+$backgroundColor+"';"
	
	// Apply text color (also called textEffect in Spread.js)
	$js+="oldStyle.textEffect.color = '"+$textColor+"';"
	// Apply font styling
	$js+="oldStyle.textEffect.font = '"+This:C1470.defaultFont+"';"
	// Center text vertically in shape
	$js+="oldStyle.textFrame.vAlign = GC.Spread.Sheets.VerticalAlign.center;"
	// Center text horizontally in shape
	$js+="oldStyle.textFrame.hAlign = GC.Spread.Sheets.HorizontalAlign.center;"
	
	// Set line style to solid
	$js+="oldStyle.line.lineStyle = GC.Spread.Sheets.Shapes.PresetLineDashStyle.solid;"
	// Set border color to grey
	$js+="oldStyle.line.color = 'grey';"
	// Set border width to 0 (invisible border)
	$js+="oldStyle.line.width = 0;"
	// Set line cap style to square
	$js+="oldStyle.line.capType=GC.Spread.Sheets.Shapes.LineCapStyle.square; "
	// Set line join style to miter
	$js+="oldStyle.line.joinType=GC.Spread.Sheets.Shapes.LineJoinStyle.miter; "
	// Apply double compound line type
	$js+="oldStyle.line.compoundType = GC.Spread.Sheets.Shapes.CompoundType.double;"
	// Set transparency to 90% (mostly opaque at 10%)
	$js+="oldStyle.line.transparency = 0.9;"
	
	// Apply the complete style to the shape
	$js+="shape.style(oldStyle);"
	
	// Disable shape movement by user
	$js+="shape.allowMove(false);"
	// Disable shape resizing by user
	$js+="shape.allowResize(false);"
	// Disable shape rotation by user
	$js+="shape.allowRotate(false);"
	// Keep shape unlocked
	$js+="shape.isLocked(false);"
	// Hide selection handles
	$js+="shape.showHandle(false);"
	
	// Set shape text content, escaping single quotes for JavaScript string
	$js+="shape.text('"+Replace string:C233(String:C10($text); "'"; "\\'")+"');"
	
	// Set row/column offsets to 0 (no offset from grid position)
	$js+="shape.startRowOffset(0);"
	$js+="shape.startColumnOffset(0); "
	$js+="shape.endRowOffset(0);"
	$js+="shape.endColumnOffset(0);"
	
	// Set shape starting row from range
	$js+="shape.startRow("+String:C10($rangeTmp.row())+"); "
	// Set shape starting column from range
	$js+="shape.startColumn("+String:C10($rangeTmp.column())+");"
	// Set shape ending row (row + height - 1)
	$js+="shape.endRow("+String:C10($rangeTmp.row()+$rangeTmp.rowCount()-1)+"); "
	// Set shape ending column (column + width)
	$js+="shape.endColumn("+String:C10($rangeTmp.column()+$rangeTmp.columnCount())+");"
	
	// Execute JavaScript and retrieve result
	$answer:=WA Evaluate JavaScript:C1029(*; This:C1470.areaName; $js)
	
// Updates an existing shape's text, colors, and position.
// Algorithm: Retrieves shape by name, updates style properties (fill, text color),
// refreshes text content, and recalculates position offsets based on new range.
Function update($name : Text; $text : Text; $range : Object; $textColor : Text; $backgroundColor : Text)
	
	var $js; $answer : Text
	
	// Default to default text color if not provided
	$textColor:=$textColor#"" ? $textColor : This:C1470.defaultTextColor
	// Default to default background color if not provided
	$backgroundColor:=$backgroundColor#"" ? $backgroundColor : This:C1470.defaultBackColor
	// Parse range object to extract new coordinates
	var $rangeTmp:=cs:C1710.VPRangeReader.new($range)
	
	// Initialize JavaScript with active sheet reference
	$js:=This:C1470.activeSheet
	
	// Retrieve existing shape by name
	$js+="var shape=activeSheet.shapes.get('"+$name+"');"
	// Conditional update only if shape exists
	$js+="if (shape) {"
	// Update shape text content with escaped quotes
	$js+="shape.text('"+Replace string:C233(String:C10($text); "'"; "\\'")+"');"
	// Fetch current style for modification
	$js+="var oldStyle = shape.style();"
	// Update background fill color
	$js+="oldStyle.fill.color = '"+$backgroundColor+"';"
	// Update text color
	$js+="oldStyle.textEffect.color = '"+$textColor+"';"
	// Apply updated style back to shape
	$js+="shape.style(oldStyle);"
	// Reset position offsets to align with new range
	$js+="shape.startRowOffset(0);"
	$js+="shape.startColumnOffset(0); "
	$js+="shape.endRowOffset(0);"
	$js+="shape.endColumnOffset(0);"
	// Update shape starting row from new range
	$js+="shape.startRow("+String:C10($rangeTmp.row())+"); "
	// Update shape starting column from new range
	$js+="shape.startColumn("+String:C10($rangeTmp.column())+");"
	// Update shape ending row (row + height - 1)
	$js+="shape.endRow("+String:C10($rangeTmp.row()+$rangeTmp.rowCount()-1)+"); "
	// Update shape ending column (column + width)
	$js+="shape.endColumn("+String:C10($rangeTmp.column()+$rangeTmp.columnCount())+");"
	// Close conditional block
	$js+="}"
	
	// Execute JavaScript update
	$answer:=WA Evaluate JavaScript:C1029(*; This:C1470.areaName; $js)
	
// Creates a line shape positioned over a range.
Function addLine($name : Text; $range : Object; $color : Text; $presetLineDashStyle : Integer)
	
	var $js; $answer : Text
	var $rangeTmp : cs:C1710.VPRangeReader
	
	$rangeTmp:=cs:C1710.VPRangeReader.new($range)
	
	$js:=This:C1470.activeSheet
	
	$js+="var shape=activeSheet.shapes.add('"+$name+"', GC.Spread.Sheets.Shapes.AutoShapeType.line, 0, 0, 1, 1);"
	
	$js+="var oldStyle = shape.style();"
	
	$js+="oldStyle.line.lineStyle = "+($presetLineDashStyle=1 ? "GC.Spread.Sheets.Shapes.PresetLineDashStyle.solid" : "GC.Spread.Sheets.Shapes.PresetLineDashStyle.squareDot")+"; "
	$js+="oldStyle.line.color = '"+$color+"';"
	$js+="oldStyle.line.width = 2;"
	
	$js+="oldStyle.line.transparency = 0;"
	
	$js+="shape.style(oldStyle);"
	
	$js+="shape.allowMove(false);"
	$js+="shape.allowResize(false);"
	$js+="shape.allowRotate(false);"
	$js+="shape.isLocked(true);"
	
	$js+="shape.startRowOffset(0);"
	$js+="shape.startColumnOffset(0); "
	$js+="shape.endRowOffset(0);"
	$js+="shape.endColumnOffset(0);"
	
	$js+="shape.startRow("+String:C10($rangeTmp.row())+"); "
	$js+="shape.startColumn("+String:C10($rangeTmp.column())+");"
	$js+="shape.endRow("+String:C10($rangeTmp.row()+$rangeTmp.rowCount()-1)+"); "
	$js+="shape.endColumn("+String:C10($rangeTmp.column()+$rangeTmp.columnCount())+");"
	
	
	$answer:=WA Evaluate JavaScript:C1029(*; This:C1470.areaName; $js)
	
// Removes a shape by name.
Function remove($name : Text)
	
	var $js; $answer : Text
	
	$js:=This:C1470.activeSheet
	$js+="activeSheet.shapes.remove('"+$name+"');"
	
	$answer:=WA Evaluate JavaScript:C1029(*; This:C1470.areaName; $js)
	
// Removes all shapes from the active worksheet.
Function clearAll()
	var $js; $answer : Text
	
	$js:=This:C1470.activeSheet
	$js+="activeSheet.shapes.clear();"
	
	$answer:=WA Evaluate JavaScript:C1029(*; This:C1470.areaName; $js)
	
// Returns all shapes from the active worksheet.
Function all() : Collection
	
	var $js:="(function (){"
	$js+=This:C1470.activeSheet
	$js+="return activeSheet.shapes.all();"
	$js+="})();"
	return WA Evaluate JavaScript:C1029(*; This:C1470.areaName; $js; Is collection:K8:32)
	
// Returns a shape by name.
Function get($name : Text) : Object
	
	var $js:="(function (){"
	$js+=This:C1470.activeSheet
	$js+="return activeSheet.shapes.get('"+$name+"');"
	$js+="})(); "
	return WA Evaluate JavaScript:C1029(*; This:C1470.areaName; $js; Is object:K8:27)
	
// Indicates whether a named shape is selected.
Function isSelected($name : Text) : Boolean
	
	var $js:="(function (){"
	$js+=This:C1470.activeSheet
	$js+="shape=activeSheet.shapes.get('"+$name+"');"
	$js+="return shape.isSelected();"
	$js+="})(); "
	return WA Evaluate JavaScript:C1029(*; This:C1470.areaName; $js; Is boolean:K8:9)
	
// Returns the text displayed by a named shape.
Function getText($name : Text) : Text
	
	var $js:="(function (){"
	$js+=This:C1470.activeSheet
	$js+="shape=activeSheet.shapes.get('"+$name+"');"
	$js+="return shape.text();"
	$js+="})(); "
	return WA Evaluate JavaScript:C1029(*; This:C1470.areaName; $js; Is text:K8:3)
	
// Moves a named shape to the front of the worksheet.
Function bringToFront($name : Text) : Boolean
	
	var $js:="(function (){"
	$js+=This:C1470.activeSheet
	$js+="var total=activeSheet.shapes.all().length; "
	$js+="activeSheet.shapes.zIndex('"+$name+"', total - 1);"
	$js+="})(); "
	return WA Evaluate JavaScript:C1029(*; This:C1470.areaName; $js; Is boolean:K8:9)
	
// Installs a JavaScript listener that calls a 4D method on double-click.
// Algorithm: Tracks consecutive clicks with 300ms debounce window.
// When two clicks detected within timeout period, extracts shape info and invokes 4D callback.
// Hit detection uses Spread.js hitTest API to identify clicked shape from viewport coordinates.
Function doubleClickOnShape($MethodName : Text)
	
	// Test bridge initialization
	$js:="try { $4d."+$MethodName+"({}); } catch(e) { console.error('$4d error:', e); }"
	
	var $answer:=WA Evaluate JavaScript:C1029(*; This:C1470.areaName; $js; Is text:K8:3)
	
	// Double-click detection logic
	var $js:="    var clickCount = 0;"  // Track sequential clicks
	$js+="    var clickTimer = null;"  // Timeout reference for debounce
	$js+="    var DOUBLE_CLICK_DELAY = 300;"  // 300ms window for double-click
	$js+="    Utils.spread.getHost().addEventListener('click', function (e) {"  // Attach click listener to Spread area
	$js+="        var rect = this.getBoundingClientRect();"  // Get viewport boundaries
	$js+="        var x = e.clientX - rect.left;"  // Convert mouse X to local viewport coordinates
	$js+="        var y = e.clientY - rect.top;"  // Convert mouse Y to local viewport coordinates
	$js+=""  
	$js+="        var result = Utils.spread.hitTest(x, y);"  // Test if click hit a shape
	$js+="        if (!result || !result.worksheetHitInfo) {"  // Validate hit test result
	$js+="            clickCount = 0;"  // Reset counter if miss
	$js+="            clearTimeout(clickTimer);"  // Clear pending timer
	$js+="            return;"  
	$js+="        }"  
	$js+=""  
	$js+="        var shapeHitInfo = result.worksheetHitInfo.shapeHitInfo;"  // Extract shape data from hit info
	$js+="        if (!shapeHitInfo || !shapeHitInfo.shape) {"  // Validate shape hit info
	$js+="            clickCount = 0;"  // Reset if no shape hit
	$js+="            clearTimeout(clickTimer);"  
	$js+="            return;"  
	$js+="        }"  
	$js+=""  
	$js+="        var shape = shapeHitInfo.shape;"  // Cache clicked shape object
	$js+=""  
	$js+="        clickCount++;"  // Increment click counter
	$js+="        clearTimeout(clickTimer);"  // Reset debounce timer
	$js+=""  
	$js+="        if (clickCount === 2) {"  // Double-click detected
	$js+="            clickCount = 0;"  // Reset for next sequence
	$js+="            console.log('doubleclick shape');"  // Debug log
	$js+="            try { $4d."+$MethodName+"(shape); } catch(e) { console.error('$4d error:', e); }"  // Invoke 4D callback with shape object
	$js+="        } else {"  // Single click - wait for potential second click
	$js+="            clickTimer = setTimeout(function () {"  // Debounce: ignore clicks outside window
	$js+="                clickCount = 0;"  // Reset counter if second click doesn't arrive
	$js+="            }, DOUBLE_CLICK_DELAY);"  
	$js+="        }"  
	$js+="    });"  
	
	$answer:=WA Evaluate JavaScript:C1029(*; This:C1470.areaName; $js; Is text:K8:3)
	