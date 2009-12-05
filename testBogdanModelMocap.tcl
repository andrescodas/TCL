source pilo.tcl
source moveTools.tcl
source mocap.tcl
source rfid.tcl
source positionToFile.tcl
source rfidPositioner.tcl
source mocapRflex.tcl

set objective(x) 0
set objective(y) 0
set objective(theta) 0


#initMocap
initMocapFile

set mocapWellInited 1
while { $mocapWellInited } { 
	getPositionMocapTreatError position
	set mocapWellInited $position(status)
}

rfidPositioner::StartParticules $position(xRob) $position(yRob) $position(theta) 
rflex::SetPos $position(xRob) $position(yRob) 0 $position(theta)

after 100 ## need to set up correctly rflex before initiating getPositionMocapRflex


clearFile rflexPositionSet.txt
clearFile rflexCovarianceSet.txt
clearFile mocapPositionSet.txt
clearFile rfidPositionSet.txt
clearFile detectionsBogdanTest.txt

proc getPosition { position } { 
	upvar $position pos
	getPositionMocapRflex pos
}

contourPoints points

while { 1 == 1} {
	for {set i 1} {$i <= $points(length)} {incr i} {
			
		set objective(x) $points($i,x)
		set objective(y) $points($i,y)
		set objective(theta) 0

		

		puts "----------------------Init Going to point"
		puts "x     = $objective(x)" 
		puts "y     = $objective(y)"
		puts "----------------------End Goint to point"


		moveXY objective

		getPositionRFLEX positionRFLEX
		set thetaO [expr $positionRFLEX(theta)*180/$pi]
		
		position2File $i rflexPositionSet.txt positionRFLEX
				
		getCovRFLEX cov
		covariance2File $i rflexCovarianceSet.txt cov

		getPosition positionMOCAP
		set thetaM [expr $positionMOCAP(theta)*180/$pi]
	
		position2File $i mocapPositionSet.txt positionMOCAP
	
		acquire detectionsBogdanTest.txt
		rfidPositioner::TrackPosition
		clearOdometryErr
	
		getPositionRFID positionRFID
		set thetaRF [expr $positionRFID(theta)*180/$pi]
	
		position2File $i rfidPositionSet.txt positionRFID

		puts "RFLEX:\t$positionRFLEX(xRob)\t$positionRFLEX(yRob)\t$thetaO"
		puts "MOCAP:\t$positionMOCAP(xRob)\t$positionMOCAP(yRob)\t$thetaM"
		puts "RFID:\t$positionRFID(xRob)\t$positionRFID(yRob)\t$thetaRF"
	}
} 
 
	
