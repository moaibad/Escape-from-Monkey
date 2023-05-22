extends Label



var milisecond : int = 0
var second : int = 0
var minute : int = 0


func _ready():
	pass # Replace with function body.

func _start_timer(timer):
	if timer > 9:
		milisecond += 1
		timer = 0
		
	if milisecond > 59:
		second += 1
		milisecond = 0
	
	if second > 59:
		minute += 1
		second = 0
	
	set_text(str(minute) + ":" + str(second) + ":" + str(milisecond))
	
