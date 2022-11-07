option explicit

!INC Local Scripts.EAConstants-VBScript
!INC Common.Print-Array
!INC Common.color-picker
!INC EAScriptLib.VBScript-Logging
!INC PlantUML.Create-Activity-Diagram
!INC PlantUML.Create-Class-Diagram
!INC PlantUML.Create-Component-Diagram
!INC PlantUML.Create-Deployment-Diagram
!INC PlantUML.Create-Sequence-Diagram
!INC PlantUML.Create-UseCase-Diagram
!INC PlantUML.Create-C4-Diagram

'LOGLEVEL=0		'ERROR
'LOGLEVEL=1		'INFO
LOGLEVEL=2		'WARNING
'LOGLEVEL=3		'DEBUG
'LOGLEVEL=4		'TRACE
'
' Script Name: Run PlantUML Script
' Author: David Anderson
' Purpose: Wrapper script to appear in the Diagram Scripting group  
' 		   responsible for directing to the relevant script by diagram type.  
' Date: 11-March-2019
'
' 25-Sept-2022:		Support C4 Diagrams
'
Dim currentDiagram as EA.Diagram
Dim currentPackage as EA.Package
Dim selectedObject as EA.DiagramObject
Dim theSelectedElement as EA.Element

dim layout_array (99, 7)			'store cooridinates of all sequences and fragments that needs to be positioned
dim l								'layout array index

sub OnDiagramScript()
	'Show the script output window
	Repository.EnsureOutputVisible "Script"
	call LOGInfo ("------VBScript Run PlantUML script------" )

	' Get a reference to the current diagram
	set currentDiagram = Repository.GetCurrentDiagram()
	set currentPackage = Repository.GetPackageByID(currentDiagram.PackageID)

	if not currentDiagram is nothing then
		dim selectedObjects as EA.Collection
		set selectedObjects = currentDiagram.SelectedObjects
		if selectedObjects.Count = 1 then
			set selectedObject = selectedObjects.GetAt (0)
			set theSelectedElement = Repository.GetElementByID(selectedObject.ElementID)
			' One or more diagram objects are selected
			if not theSelectedElement is nothing _
				and theSelectedElement.ObjectType = otElement _
				and theSelectedElement.Type = "Note" then
				select case currentDiagram.Type
					case "Activity"		call CreateActivityDiagram ()
					case "Logical"		call CreateClassDiagram ()
					case "Component"	call CreateComponentDiagram ()
					case "Deployment"	call CreateDeploymentDiagram ()
					case "Sequence"		call CreateSequenceDiagram ()
					case "Use Case"		call CreateUseCaseDiagram ()
					case else			call LOGWarning("This script does not yet support " & currentDiagram.Type & " diagrams")
				end select
				call LOGInfo ( "Script Complete" )
				call LOGInfo ( "===============" )
				Session.Prompt "Done" , promptOK
			else
				Session.Prompt "A note object with the valid PlantUML script should be selected" , promptOK
			end if
		else
			if selectedObjects.Count = 0 then
				' Nothing is selected
				Session.Prompt "A note object with the valid PlantUML script should be selected" , promptOK
			else
				Session.Prompt "Only one object should be selected" , promptOK				
			end if
		end if
	else
		Session.Prompt "This script requires a diagram to be visible", promptOK
	end if

end sub

OnDiagramScript