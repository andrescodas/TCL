if { [info exists _RFID.TCL] == 0 } {
set _RFID.TCL 1

source connectCity.tcl
lm rfid on city
rfid::InitDriver /dev/ttyUSB0


proc getRFIDDetections { TagList } {

	upvar $TagList REFTagList
	rfid::OneShot
	set outputPoster [rfid::TagListlistPosterRead]

	set format "status = %s\n"
	append format "list.nbTags = %d\n"

  	scan $outputPoster $format status nbTags

	set format [string map [list %s $status %d $nbTags] $format]
	
	set newString [string map [list $format ""] $outputPoster]

	if {[string compare $status "OK"] == 0} {
	
		for {set i 0} {$i < $nbTags} {incr i} {
			set format    "list.tags\[$i\].tagId = %s\n"	
			append format "list.tags\[$i\].angleMean = %f\n"
			append format "list.tags\[$i\].angleCov = %f\n"
			append format "list.tags\[$i\].distMean = %f\n"
			append format "list.tags\[$i\].distCov = %f\n"
			append format "list.tags\[$i\].antennas\[0\] = %d\n"
			append format "list.tags\[$i\].antennas\[1\] = %d\n"
			append format "list.tags\[$i\].antennas\[2\] = %d\n"
			append format "list.tags\[$i\].antennas\[3\] = %d\n"
			append format "list.tags\[$i\].antennas\[4\] = %d\n"
			append format "list.tags\[$i\].antennas\[5\] = %d\n"
			append format "list.tags\[$i\].antennas\[6\] = %d\n"
			append format "list.tags\[$i\].antennas\[7\] = %d\n"
			
		
			scan $newString $format tagId angleMean angleCov distMean distCov a0 a1 a2 a3 a4 a5 a6 a7

			set REFTagList($i,tagId) $tagId
			set REFTagList($i,a0) $a0
			set REFTagList($i,a1) $a1
			set REFTagList($i,a2) $a2
			set REFTagList($i,a3) $a3
			set REFTagList($i,a4) $a4
			set REFTagList($i,a5) $a5
			set REFTagList($i,a6) $a6
			set REFTagList($i,a7) $a7

			set format    "list.tags\[$i\].tagId = $tagId\n"
			append format "list.tags\[$i\].angleMean = $angleMean\n"
			append format "list.tags\[$i\].angleCov = $angleCov\n"
			append format "list.tags\[$i\].distMean = $distMean\n"
			append format "list.tags\[$i\].distCov = $distCov\n"
			append format "list.tags\[$i\].antennas\[0\] = $a0\n"
			append format "list.tags\[$i\].antennas\[1\] = $a1\n"
			append format "list.tags\[$i\].antennas\[2\] = $a2\n"
			append format "list.tags\[$i\].antennas\[3\] = $a3\n"
			append format "list.tags\[$i\].antennas\[4\] = $a4\n"
			append format "list.tags\[$i\].antennas\[5\] = $a5\n"
			append format "list.tags\[$i\].antennas\[6\] = $a6\n"
			append format "list.tags\[$i\].antennas\[7\] = $a7\n"

			set newString [string map [list $format ""] $newString]
		}


	} else {
		puts "Error:  Demande Thierry"
	}
	
	return $nbTags

}

# Save currentRobot Position(x,y,t) an tags(id,antennaWhichDetected) Detected to file
proc acquire { fileToWrite } {

	
	getPosition position 

	
		set nbTags [getRFIDDetections TagList]
	
		set filePointer [open $fileToWrite a]
	
		if {0 == $nbTags} {
			puts $filePointer "$position(xRob) $position(yRob) $position(theta) NULL 0 0 0 0 0 0 0 0"
		} else {

			for {set i 0} {$i < $nbTags} {incr i} {

				puts $filePointer "$position(xRob) $position(yRob) $position(theta) $TagList($i,tagId) $TagList($i,a0) $TagList($i,a1) $TagList($i,a2) $TagList($i,a3) $TagList($i,a4) $TagList($i,a5) $TagList($i,a6) $TagList($i,a7)"
			}
		} 
		close $filePointer

		return 0

}

# Save currentRobot Position(x,y,t) an tags(id,antennaWhichDetected) Detected to file
proc acquireMocap { fileToWrite } {

	
	getPositionMocap position 

	if {$position(status) == 0} {
	
		set nbTags [getRFIDDetections TagList]
	
		set filePointer [open $fileToWrite a]
	
		if {0 == $nbTags} {
			puts $filePointer "$position(xRob) $position(yRob) $position(theta) NULL 0 0 0 0 0 0 0 0"
		} else {

			for {set i 0} {$i < $nbTags} {incr i} {

				puts $filePointer "$position(xRob) $position(yRob) $position(theta) $TagList($i,tagId) $TagList($i,a0) $TagList($i,a1) $TagList($i,a2) $TagList($i,a3) $TagList($i,a4) $TagList($i,a5) $TagList($i,a6) $TagList($i,a7)"
			}
		} 
		close $filePointer

		return 0
	} else {
		return 1
	}
}

 # ifndef
}
