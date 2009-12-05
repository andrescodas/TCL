if { [info exists _MOCAPRFLEX.TCL] == 0 } {
set _MOCAPRFLEX.TCL 1

source moveTools.tcl
source pilo.tcl
source mocap.tcl

## Return close to (0,0) to clean odometry 
proc goToclearOdometry { pos } {
	global pi
	upvar $pos position

	set REFobjective(x) [expr $position(xRob)/2]	
	set REFobjective(y) [expr $position(yRob)/2]

	findDistance dx dy d REFobjective position
	findTheta dx dy dt position
	

	if {[expr {abs($dt)}] > [expr $pi/2]} {

		set dt [expr $dt + $pi]
		wrapAngle dt
		set d -$d
	}

	turn $dt
	move $d

}

proc areEqualPosition { pos1 pos2 } {

	upvar $pos1 position1
	upvar $pos2 position2

	if { $position1(xRob) == $position2(xRob) } {
		if { $position1(yRob) == $position2(yRob) } {
			if { $position1(theta) == $position2(theta) } {
				return 1
			} else {
				return 0
			}

		} else {
			return 0
		}		

	} else {
		return 0
	}
}

proc setPositionArray {destination origin} {
	upvar $destination d
	upvar $origin o
	
	set d(xRob) $o(xRob)
	set d(yRob) $o(yRob)
	set d(theta) $o(theta)
}

## pos(from) == 1 from Mocap
## pos(from) == 0 from RFLEX
set rflexOld(xRob) 0
set rflexOld(yRob) 0
set rflexOld(theta) 0

set mocapLast(xRob) 0
set mocapLast(yRob) 0
set mocapLast(theta) 0

set lastPosition(xRob) 0
set lastPosition(yRob) 0
set lastPosition(theta) 0

set distanceWithoutMocap(d) 0
set distanceWithoutMocap(t) 0

set equalPositionsCount 0


set initialized 0

proc getPositionMocapRflex { position } {

   upvar $position pos

   global mocapLast
   global rflexOld
   global lastPosition 
   global initialized
   global distanceWithoutMocap
   global equalPositionsCount

   getPositionMocapTreatError pos 
   set pos(from) 1

   getPositionRFLEX posRflex
   
   if { $equalPositionsCount > 20 } { 
	set pos(status) 77
	set equalPositionsCount 0
   }	

   if { $pos(status) == 0 } { 
	
	set cond [areEqualPosition pos mocapLast]
	
	if { $cond == 1 } {
		parray pos
		mocap::Stop
		mocap::ReadMarkers -ack
		after 100
		puts "$pos(xRob) $pos(yRob) $pos(theta) Doubt equal positions! $equalPositionsCount\n$mocapLast(xRob) $mocapLast(yRob) $mocapLast(theta)"
		

		set equalPositionsCount [expr $equalPositionsCount + 1]
		
		getPositionMocapRflex pos
		
	} 

	if { $pos(from) == 1} { 
		set distanceWithoutMocap(d) 0
		set distanceWithoutMocap(t) 0
		setPositionArray mocapLast pos
		set equalPositionsCount 0

		if { $initialized == 0} { 
			set initialized 1
		}
	}

   } else {

	if { $initialized  == 0 } {
		error "Not initialized mocapMeasurement"
	}	

	puts "Position Mocap Status == $pos(status)"

	set deslocRflex(xRob) [expr $posRflex(xRob) - $rflexOld(xRob)]
	set deslocRflex(yRob) [expr $posRflex(yRob) - $rflexOld(yRob)]
	set deslocRflex(theta) [expr $posRflex(theta) - $rflexOld(theta)]

	set distanceWithoutMocap(d) [expr $distanceWithoutMocap(d)+sqrt($deslocRflex(yRob)*$deslocRflex(yRob)+$deslocRflex(xRob)*$deslocRflex(xRob))]
	set distanceWithoutMocap(t) [expr $distanceWithoutMocap(t) + $deslocRflex(theta)]

	rotation deslocRflex [expr $lastPosition(theta) - $rflexOld(theta)]

	set pos(xRob) [expr $lastPosition(xRob) + $deslocRflex(xRob)]	
	set pos(yRob) [expr $lastPosition(yRob) + $deslocRflex(yRob)]	
	set pos(theta) [expr $lastPosition(theta) + $deslocRflex(theta)]	

	set pos(from) 0

	parray pos
	parray distanceWithoutMocap

	set condition 0

	while { $condition != 1 } {
		puts "Press 1 to continue"
		gets stdin condition
	}
   }
	
   setPositionArray rflexOld posRflex
   setPositionArray lastPosition pos
}
 # ifnded
}
