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

rfidLocMap::SetNumberRobotParticles 1
rfidLocMap::SetTagInertia 0.9

for { set k 677} { $k <= 1000 }  { set k [expr $k + 1] } {

	set numParticles $k
	puts "actual Iteration = $k"
	
	rfidLocMap::ClearTags
	rfidLocMap::SetNumberTagParticles $k
	rfidLocMap::StartInput
	rfidLocMap::StartRobotParticles 2 -0.25 1  ## n'import quois
	rfidLocMap::StartOdometry 2 -0.25 1
		
	set tagPosFile $home$path$fileTag$k$extension
	clearFile $tagPosFile 

	set i 1
	while { $i <= 323 } {
		
		
		rfidLocMap::ActualizePositions
	
##		getPositionRFIDLocMap positionRFID

		getTagPosition positionTag

##		set thetaRF [expr $positionRFID(theta)*180/$pi]
	
##		position2File $i $rfidPosFile positionRFID

		tagPosition2File $i $tagPosFile positionTag

##		puts "RFID:\t$positionRFID(xRob)\t$positionRFID(yRob)\t$thetaRF"
		
		incr i
	} 
}
