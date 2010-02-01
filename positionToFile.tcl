if { [info exists _POSITIONTOFILE.TCL] == 0 } {
set _POSITIONTOFILE 1

# Save currentRobot Position(x,y,t) an tags(id,antennaWhichDetected) Detected to file
proc position2File { index fileToWrite position } {
	
	upvar $position pos
	
	set filePointer [open $fileToWrite a]
	
	puts $filePointer "$index $pos(xRob) $pos(yRob) $pos(theta)"
	
	close $filePointer

}

proc tagPosition2File { index fileToWrite position } {
	
	upvar $position pos
	
	set filePointer [open $fileToWrite a]
	
	puts $filePointer "$index $pos(x) $pos(y)"
	
	close $filePointer

}


proc covariance2File { index fileToWrite covariance } {
	
	upvar $covariance cov
	
	set filePointer [open $fileToWrite a]
	
	puts $filePointer "$index $cov(0) $cov(1) $cov(2) $cov(3) $cov(4) $cov(5)"	

	close $filePointer

}

proc clearFile { fileToWrite } {

	set filePointer [open $fileToWrite w]
	close $filePointer

}


}
