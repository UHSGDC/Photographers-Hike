extends CanvasLayer

var seconds: float = 0
var minutes: int = 0
var hours: int = 0

func _ready():
	Global.speedrun_timer = self


func _process(delta):
	seconds += delta
	if seconds >= 60:
		minutes += 1
		seconds -= 60
	if minutes >= 60:
		hours += 1
		minutes -= 60
	
	$Time.text = "%02d:%02d:%05.2f" % [hours, minutes, seconds]
