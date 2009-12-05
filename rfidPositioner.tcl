if { [info exists _RFIDPOSITIONER.TCL] == 0 } {
set _RFIDPOSITIONER.TCL 1

source connectSpace.tcl

lm rfidPositioner path /home/andres/workspace/rfidPositionerBin/Linux/

proc getPositionRFID { position } {

  upvar $position pos

  set format "status = OK\n"
  append format "position.xRob = %f\n"
  append format "position.yRob = %f\n"
  append format "position.theta = %f\n"

  scan [rfidPositioner::PositionpositionPosterRead] $format xRob yRob theta 

  set pos(xRob) $xRob
  set pos(yRob) $yRob
  set pos(theta) $theta
 	
}


# ifndef

}
