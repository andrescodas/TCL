
source positionToFile.tcl
source rfidPositioner.tcl



set pi 3.1415
set i 1

rfidPositioner::StartParticules 1.99697586685 -0.239945161151 -1.01811648264

set home $env(HOME)
set path /simulation/results/
set fileName rfidPositionSet.txt


set rfidPosFile $home$path$fileName

clearFile $rfidPosFile





while { $i <= 256 } {
		
		
		rfidPositioner::TrackPosition
		
		getPositionRFID positionRFID

		set thetaRF [expr $positionRFID(theta)*180/$pi]
	
		position2File $i $rfidPosFile positionRFID

		puts "RFID:\t$positionRFID(xRob)\t$positionRFID(yRob)\t$thetaRF"
		incr i

} 
 
	
