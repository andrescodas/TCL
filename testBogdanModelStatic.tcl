source pilo.tcl
source moveTools.tcl
#source mocap.tcl
source rfid.tcl
source positionToFile.tcl
source rfidPositioner.tcl
#source mocapRflex.tcl

set objective(x) 0
set objective(y) 0
set objective(theta) 0




#initMocap

#getPositionMocap position
#rfidPositioner::StartParticules $position(xRob) $position(yRob) $position(theta) 
#rflex::SetPos $position(xRob) $position(yRob) 0 $position(theta)

rfidPositioner::StartParticules 0 0 0 
rflex::SetPos 0 0 0 0
clearOdometryErr



clearFile rflexPositionSet.txt
clearFile mocapPositionSet.txt
clearFile rfidPositionSet.txt
clearFile detectionsBogdanTest.txt

#set step [expr $pi*2/180]
#set ang 0


proc getPosition { position } { 
	upvar $position pos
	getPositionRFLEX pos
}

#for {set i 1} {$i <= 3600} {incr i} {
		
	set i 1

#	defineObjective objective ang

	if {$i == 1} {
	
		set objective(x) 0
		set objective(y) 0
	}

	puts "----------------------Init Going to point"
	puts "x     = $objective(x)" 
	puts "y     = $objective(y)"
	puts "----------------------End Goint to point"
	
#	moveXY objective

	getPositionRFLEX positionRFLEX
	set theta [expr $positionRFLEX(theta)*180/$pi]
	puts "RFLEX:\t$positionRFLEX(xRob)\t$positionRFLEX(yRob)\t$theta"	
	position2File $i rflexPositionSet.txt positionRFLEX

#	getPositionMocap positionMOCAP
#	set theta [expr $positionMOCAP(theta)*180/$pi]
#	puts "MOCAP:\t$positionMOCAP(xRob)\t$positionMOCAP(yRob)\t$theta"
#	position2File $i mocapPositionSet.txt positionMOCAP
	
	acquire detectionsBogdanTest.txt
	rfidPositioner::TrackPosition
	clearOdometryErr
	
	getPositionRFID positionRFID
	set theta [expr $positionRFID(theta)*180/$pi]
	puts "RFID:\t$positionRFID(xRob)\t$positionRFID(yRob)\t$theta"
	position2File $i rfidPositionSet.txt positionRFID

	#set ang [expr $ang + $step]

	
#}
