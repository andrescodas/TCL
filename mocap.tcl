if { [info exists _MOCAP.TCL] == 0 } {
set _MOCAP.TCL 1

source connectSpace.tcl

lm mocap on space path /home/acodas/workspace/mocapBin/Linux/

proc getPositionMocap { position } {

  upvar $position pos

  set format "status = OK\n"
  append format "Position.status = %d\n"
  append format "Position.padding = %d\n"
  append format "Position.x = %f\n"
  append format "Position.y = %f\n"
  append format "Position.theta = %f\n"
  

  scan [mocap::EstimatedPositionPositionPosterRead] $format status padding xRob yRob theta 
 	
  while { $status != 0 } { 
	  after 200
	  scan [mocap::EstimatedPositionPositionPosterRead] $format status padding xRob yRob theta
	  puts "Bad getPositionMocap Read"
  }

  set pos(status) $status
  set pos(xRob) $xRob
  set pos(yRob) $yRob
  set pos(theta) $theta

}


proc getPositionMocapTreatError { position } {

  upvar $position pos

  set format "status = OK\n"
  append format "Position.status = %d\n"
  append format "Position.padding = %d\n"
  append format "Position.x = %f\n"
  append format "Position.y = %f\n"
  append format "Position.theta = %f\n"
  

  scan [mocap::EstimatedPositionPositionPosterRead] $format status padding xRob yRob theta 
 	
  set pos(status) $status
  set pos(xRob) $xRob
  set pos(yRob) $yRob
  set pos(theta) $theta

}


proc initMocapCalib {} {
	global pi
	mocap::Init
	mocap::ClearCalib	
	for {set i 0} {$i < 3} {incr i} {
		turn [expr {2*$pi/3}]
		mocap::SetCalibPoint
	}
		move 0.3
		mocap::SetCalibPoint
		move -0.3

mocap::ReadMarkers -ack

after 100

}

proc initMocapFile {} {
puts "initing Mocap"
mocap::Init
puts "Start Reading Markers"
mocap::ReadMarkers -ack
puts "Wait a Little bit to read firts marker"
after 200
}


#ifndef
}
