//%attributes = {}
#DECLARE() : Boolean

// Retrieve the authentication token
// This may open a web browser if user login/consent is required
var $token : Object:=Try(cs:C1710.OfficeProvider.me.getToken())

// Proceed only if we have a valid token and a non-empty email address
If (($token#Null:C1517) && (cs:C1710.OfficeProvider.me.emailAddress#""))
	
	// Store the authenticated user's email address in the form.
	Form:C1466.microsoftEmailAddress:=cs:C1710.OfficeProvider.me.emailAddress
	
	return True:C214
Else 
	ALERT:C41("Sign-in error: unable to obtain authentication token")
	return False:C215
End if 