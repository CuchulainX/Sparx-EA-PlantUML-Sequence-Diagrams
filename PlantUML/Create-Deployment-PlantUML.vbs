'
' Script Name: Create Deployment PlantUML
' Author: David Anderson
' Purpose: Callable routine for dealing with the creation of a deployment PlantUML script
' Date: 21-Feb-2021
'
' Change Log:
' 18-Sept-2022:		Add C4 Diagram support
'
sub CreateDeploymentPlantUML ()

	call LOGInfo("Create Deployment PlantUML Script activated " & currentDiagram.Stereotype)
	if Left(currentDiagram.Stereotype,2) = "C4" then
		CreateC4PlantUML ()
	else
		LOGWarning("This script does not yet support " & currentDiagram.Type & " diagrams")
	end if
	call LOGInfo ( "Create Deployment PlantUML Script Complete" )
	call LOGInfo ( "=========================================" )

end sub
