## faire tout ca sur SPACE !!!!!!
## Lancer pom, rflex et pilo
## Change


source rfid.tcl

while { 1 == 1} { 

	set nbTags [getRFIDDetections TagList]
		
	if {0 == $nbTags} {
		puts "NULL 0 0 0 0 0 0 0 0"
	} else {
		set TagList(a0) 0
		set TagList(a1) 0
		set TagList(a2) 0
		set TagList(a3) 0
		set TagList(a4) 0
		set TagList(a5) 0
		set TagList(a6) 0
		set TagList(a7) 0

		for {set i 0} {$i < $nbTags} {incr i} {

			
				set TagList(a0) [expr $TagList(a0)+ $TagList($i,a0)]
				set TagList(a1) [expr $TagList(a1)+ $TagList($i,a1)] 
				set TagList(a2) [expr $TagList(a2)+ $TagList($i,a2)]
				set TagList(a3) [expr $TagList(a3)+ $TagList($i,a3)] 
				set TagList(a4) [expr $TagList(a4)+ $TagList($i,a4)] 
				set TagList(a5) [expr $TagList(a5)+ $TagList($i,a5)] 
				set TagList(a6) [expr $TagList(a6)+ $TagList($i,a6)] 
				set TagList(a7) [expr $TagList(a7)+ $TagList($i,a7)]
			
		}
			
		puts "A0 = $TagList(a0)\tA1 = $TagList(a1)\tA2 = $TagList(a2)\tA3 = $TagList(a3)\tA4 = $TagList(a4)\tA5 = $TagList(a5)\tA6 = $TagList(a6)\tA7 = $TagList(a7)"
			
	} 


}
