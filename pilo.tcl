if { [info exists _PILO.TCL] == 0 } {

set _PILO.TCL 1

source connectSpace.tcl

lm rflex on space
lm pom on space
lm pilo on space


pom::SetModel /usr/local/openrobots/data/robots/rackham/geom/b21r.geom
pilo::Init  pomPos
rflex::InitClient /dev/ttyR0 115200
rflex::SetPos 0 0 0 0
rflex::TrackSpeedStart -ack piloSpeedRef



puts "I--- GetWdogRef ---I"
puts [rflex::GetWdogRef]
puts "F--- GetWdogRef ---F"
puts "I--- GetMode ---I"
puts [rflex::GetMode]
puts "F--- GetMode ---F"

proc move {d} {
	
	if {$d != 0} then {
		pilo::Move $d 20 20
	}
}

proc turn {dt} {
	
	if {$dt != 0} then {
        
		pilo::Turn $dt 0 20 20
      	}
}


proc getPositionRFLEX { position } {

  upvar $position pos

  set format "status = OK\n"
  append format "Position.xRef = %f\nPosition.yRef = %f\nPosition.zRef = %f\n"
  append format "Position.xRob = %f\nPosition.yRob = %f\nPosition.zRob = %f\n"
  append format "Position.theta = %f\n"

  scan [rflex::RobotPositionPosterRead] $format xRef yRef zRef xRob yRob zRob theta 

  set pos(xRob) $xRob
  set pos(yRob) $yRob
  set pos(zRob) $zRob
  set pos(theta) $theta
}

proc getCovRFLEX { covariance } {

   upvar $covariance cov

  set format "status = OK\n"
  append format "PosError.var\[0\] = %f\n"
  append format "PosError.var\[1\] = %f\n"
  append format "PosError.var\[2\] = %f\n"
  append format "PosError.var\[3\] = %f\n"
  append format "PosError.var\[4\] = %f\n"
  append format "PosError.var\[5\] = %f\n"

  scan [rflex::RobotPosErrorPosterRead] $format var0 var1 var2 var3 var4 var5

  set cov(0) $var0
  set cov(1) $var1
  set cov(2) $var2
  set cov(3) $var3
  set cov(4) $var4
  set cov(5) $var5
}

proc clearOdometryErr {  } {
	
	rflex::SetPosErr 0 0 0 0 0 0

}

#ifndef
}
