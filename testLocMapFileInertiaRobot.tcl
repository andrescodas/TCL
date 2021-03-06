source positionToFile.tcl
source rfidLocMap.tcl

set pi 3.1415

set home $env(HOME)
set path /simulation/results/
set fileName rfidPositionSet.txt
set extension .txt

set fileTag tagPositionSet.txt

set rfidPosFile $home$path$fileName
set tagPosFile $home$path$fileTag

clearFile $rfidPosFile


for { set k 0.0 } { $k <= 100.0 }  { set k [expr $k + 1.0] } {

	set inertia [expr $k/100]
	puts "actual Iteration = $inertia"
	
	rfidLocMap::SetRobotInertia $inertia 
	rfidLocMap::StartInput
	rfidLocMap::StartRobotParticles 2 -0.25 1
	rfidLocMap::StartOdometry 2 -0.25 1
	
	set rfidPosFile $home$path$fileName$k$extension
	clearFile $rfidPosFile 

	set i 1
	while { $i <= 323 } {
		
		
		rfidLocMap::ActualizePositions
	
		getPositionRFIDLocMap positionRFID

##		getTagPosition positionTag

		set thetaRF [expr $positionRFID(theta)*180/$pi]
	
		position2File $i $rfidPosFile positionRFID

##		tagPosition2File $i $tagPosFile positionTag

		puts "RFID:\t$positionRFID(xRob)\t$positionRFID(yRob)\t$thetaRF"
		
		incr i

	} 

}
