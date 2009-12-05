if { [info exists _MOVETOOLS.TCL] == 0 } {
set _MOVETOOLS.TCL 1

set pi 3.14159265358979

proc wrapAngle {angle} {

      upvar $angle newAngle
      global pi
      if {$newAngle > $pi} {
        set newAngle [expr $newAngle - [expr 2 * $pi]]
      }

      if {$newAngle <= -$pi} {
        set newAngle [expr $newAngle + [expr 2 * $pi]]
      }

}

proc findDistance {dx dy d objective position} {

	upvar $dx REFdx
	upvar $dy REFdy
	upvar $d REFd
	upvar $objective REFobjective
	upvar $position REFposition

	set REFdx [expr $REFobjective(x) - $REFposition(xRob)]
	set REFdy [expr $REFobjective(y) - $REFposition(yRob)]
	set REFd  [expr sqrt($REFdx * $REFdx + $REFdy * $REFdy)]

}

proc findTheta {dx dy dt position} {

	upvar $dx REFdx
	upvar $dy REFdy
	upvar $dt REFdt
	upvar $position REFposition

	set newTheta [expr atan2($REFdy,$REFdx)]
	set REFdt [expr $newTheta - $REFposition(theta)]

	wrapAngle REFdt
}


## first turn towards direction
## Then move to the objective xfinal yfinal
## Verify and repeat if necessary
proc moveXY {objective} {

	upvar $objective REFobjective	
	global pi

	getPosition position 
	findDistance dx dy d REFobjective position
	findTheta dx dy dt position

	if {[expr abs($dt)] > [expr $pi/2]} {
		set dt [expr $dt + $pi]
		wrapAngle dt
		set d -$d
	}

	if { [expr abs($d)] > 0.10 } {
		if { [expr abs($dt)] > [expr $pi/180*5] } {
			set aux [expr $dt*180/$pi]
			puts "Manque turner $aux"
			turn $dt
			moveXY REFobjective

		} else {
			if { [expr abs($d)] > 0.10 } {	
				puts "Manque avancer $d"
	
				if { abs($d) > 1 } {
					set d [expr $d/2]
				}
				move $d
				moveXY REFobjective
			}


		}
	}
}

proc moveT {objective} {
	
	upvar $objective REFobjective
	global pi

	getPosition position 
	set dt [expr $REFobjective(theta) - $position(theta)]
    	wrapAngle dt

	if {[expr {abs($dt)}] > [expr $pi/180]} {
		puts "manque turner : $dt"
		turn $dt
		moveT REFobjective
	} else {

	}
}


proc moveXYT {objective} {
	
	upvar $objective REFobjective
	
	moveXY REFobjective
	moveT  REFobjective

}



proc defineObjective { varObjective upAngle } { 

	upvar $varObjective objective
	upvar $upAngle ang

	set yMax 1.25
	set xMax 1.5

	set centerX 0.5
	set centerY -0.25

	set xun [expr cos($ang)]
	set yun [expr sin($ang)]

	if {$xun == 0} {
		
		set objective(x) 0

		if {$yun >= 0} {	
			set objective(y) $yMax
		} else {
			set objective(y) -$yMax		
		}

	} elseif {$xun > 0} {
	
		set objective(x) $xMax			

		set objective(y) [expr $xMax*$yun/$xun]

		if {$objective(y) >= $yMax} { 
		
			set objective(y) $yMax
			set objective(x) [expr $yMax*$xun/$yun]				

		} elseif {$objective(y) < -$yMax} {
	
			set objective(y) -$yMax
			set objective(x) [expr -$yMax*$xun/$yun]
		}

	} else {
		set objective(x) -$xMax			
		set objective(y) [expr -$xMax*$yun/$xun]
	
		if {$objective(y) > $yMax} { 
		
			set objective(y) $yMax
			set objective(x) [expr $yMax*$xun/$yun]				

		} elseif {$objective(y) < -$yMax} {
	
			set objective(y) -$yMax
			set objective(x) [expr -$yMax*$xun/$yun]
		}
	}
	set objective(x) [expr $objective(x)+$centerX]
	set objective(y) [expr $objective(y)+$centerY]

	limitObjective objective
}

proc limitObjective { objective } {

	upvar $objective REFobjective

	if { $REFobjective(x) > 2.5 } {
		set REFobjective(x) 2.5
	} elseif { $REFobjective(x) < -3.5 } {
		set REFobjective(x) -3.5
	}
	if { $REFobjective(y) > 2 } {
		set REFobjective(y) 2
	} elseif { $REFobjective(y) < -2 } {
		set REFobjective(y) -2
	}

}


proc contourPoints { REFpoints } { 

	upvar $REFpoints points

	set yMax 1.25
	set xMax 1.5

	set centerX 0.5
	set centerY -0.25	

	set k 0

	set i 1
	for {set j 0} { $j <= 1} {incr j} { 
		incr k
	
		set points($k,x) [expr $centerX + $i*$xMax]
		set points($k,y) [expr $centerY + $j*$yMax]

	}
	set j 1
	for {set i 0} { $i >= -1} {set i [expr $i-1]} { 
		incr k
		set points($k,x) [expr $centerX + $i*$xMax]	
		set points($k,y) [expr $centerY + $j*$yMax]
	}
	set i -1
	for {set j 0} { $j >= -1} {set j [expr $j-1]} { 
		incr k
		set points($k,x) [expr $centerX + $i*$xMax]	
		set points($k,y) [expr $centerY + $j*$yMax]
	}
	set j -1
	for {set i 0} { $i <= 1} {set i [expr $i+1]} { 
		incr k
		set points($k,x) [expr $centerX + $i*$xMax]	
		set points($k,y) [expr $centerY + $j*$yMax]
	}
	
	set points(length) $k

}


proc rotation { vector angleRad } { 
	upvar $vector v

	set cosAngle [expr cos($angleRad)]
	set sinAngle [expr sin($angleRad)]

	set vx [expr $cosAngle*$v(xRob)-$sinAngle*$v(yRob)]
	set vy [expr $sinAngle*$v(xRob)+$cosAngle*$v(yRob)]

	set v(xRob) $vx
	set v(yRob) $vy
} 


}

