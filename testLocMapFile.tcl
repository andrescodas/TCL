source positionToFile.tcl
source rfidLocMap.tcl

set pi 3.1415
set i 1

rfidLocMap::SetRobotInertia 0.9
rfidLocMap::SetNumberRobotParticles 500
rfidLocMap::StartRobotParticles 3 3 1
rfidLocMap::StartOdometry 0 0 0
rfidLocMap::StartInput 

set home $env(HOME)
set path /simulation/results/
set fileName rfidPositionSet.txt


set rfidPosFile $home$path$fileName

clearFile $rfidPosFile


while { $i <= 323 } {
		
		
		rfidLocMap::ActualizePositions
	
		getPositionRFIDLocMap positionRFID

		set thetaRF [expr $positionRFID(theta)*180/$pi]
	
		position2File $i $rfidPosFile positionRFID

		puts "RFID:\t$positionRFID(xRob)\t$positionRFID(yRob)\t$thetaRF"
		
		incr i

} 
