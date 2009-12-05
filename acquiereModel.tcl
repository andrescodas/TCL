## faire tout ca sur SPACE !!!!!!

## Lancer pom, rflex et pilo

source rfid.tcl
source mocap.tcl
source pilo.tcl
source moveTools.tcl	
		

set objective(x) 2.5
set objective(y) -2
set objective(theta) 0


while { $objective(y) <= 0 } {

	puts "----------------------Init Going to point"
	puts "x     = $objective(x)" 
	puts "y     = $objective(y)"
	puts "----------------------End Goint to point"
		
	moveXY objective
	turn $pi/2
	for {set i 0 } {$i < 18 } {incr i } {
		set cond [acquire detections.txt]
		puts "Acquire result == $cond"		
		turn $stepAngle
	}
	set cond [acquire detections.txt]

	set objective(y) [expr $objective(y) + 0.02]
}
