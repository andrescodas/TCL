source positionToFile.tcl
source rfidLocMap.tcl

set pi 3.1415

set home $env(HOME)
set path /simulation/results/
set fileName rfidPositionSet
set extension .txt

set fileTag tagPositionSet

set rfidPosFile $home$path$fileName
set tagPosFile $home$path$fileTag

clearFile $rfidPosFile

rfidLocMap::SetRobotInertia 0.95 
	

for { set k 510} { $k <= 1000 }  { set k [expr $k + 10] } {

	set inertia $k
	puts "actual Iteration = $inertia"
	
	rfidLocMap::SetNumberRobotParticles $k
	rfidLocMap::StartInput
	rfidLocMap::StartRobotParticles 0 0 0
	rfidLocMap::StartOdometry 0 0 0
	
	set rfidPosFile $home$path$fileName$k$extension
	clearFile $rfidPosFile 

	set i 1
	while { $i <= 323 } {
		
		
		rfidLocMap::ActualizePositions
	
		getPositionRFIDLocMap positionRFID

##		getTagPosition positionTag

##		set thetaRF [expr $positionRFID(theta)*180/$pi]
	
		position2File $i $rfidPosFile positionRFID

##		tagPosition2File $i $tagPosFile positionTag

##		puts "RFID:\t$positionRFID(xRob)\t$positionRFID(yRob)\t$thetaRF"
		
		incr i

	} 

}
