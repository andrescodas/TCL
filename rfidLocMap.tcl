if { [info exists _RFIDLOCMAP.TCL] == 0 } {
set _RFIDLOCMAP.TCL 1

source connectSpace.tcl

set home $env(HOME)
set rfidLocMapPath /workspace/rfidLocMapBin/Linux/

lm rfidLocMap path $home$rfidLocMapPath

proc getPositionRFIDLocMap { position } {

  upvar $position pos

  set format "status = OK\n"
  append format "RobotPosition.xRob = %f\n"
  append format "RobotPosition.yRob = %f\n"
  append format "RobotPosition.theta = %f\n"

  scan [rfidLocMap::RobotPositionRobotPositionPosterRead] $format xRob yRob theta 

  set pos(xRob) $xRob
  set pos(yRob) $yRob
  set pos(theta) $theta
 	
}


# ifndef

}
