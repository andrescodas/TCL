
source positionToFile.tcl
source rfidPositioner.tcl



set pi 3.1415
set i 1

rfidPositioner::StartParticules 0.177314 -0.509451 -2.681079

clearFile rfidPositionSet.txt


while { $i <= 256 } {
		
		rfidPositioner::TrackPosition
	
		getPositionRFID positionRFID

		set thetaRF [expr $positionRFID(theta)*180/$pi]
	
		position2File $i rfidPositionSet.txt positionRFID

		puts "RFID:\t$positionRFID(xRob)\t$positionRFID(yRob)\t$thetaRF"
		incr i

} 
 
	
