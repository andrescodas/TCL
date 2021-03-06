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

##  Only for the first tag... for more tags generate a List as the readings of the rfid
proc getTagPosition { position } {

  upvar $position pos

  set format "status = %s\n"
  append format "TagsPosition.nbTags = %d\n"
  append format "TagsPosition.tags\[0\].tagId = %s\n"
  append format "TagsPosition.tags\[0\].tag_position.x = %f\n"
  append format "TagsPosition.tags\[0\].tag_position.y = %f\n"

  scan [rfidLocMap::TagsPositionTagsPositionPosterRead] $format status nbTags tagId x y 

  set pos(nbTags) $nbTags
  set pos(tagId) $tagId
  set pos(x) $x
  set pos(y) $y

}


# ifndef

}
