extends HBoxContainer


# Time available to each player at game start
export var time_per_player = 300


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func reset():
	stop()
	$LeftClock.time_left = time_per_player
	$RightClock.time_left = time_per_player
	
func stop():
	$LeftClock.running = false
	$RightClock.running = false

func start_left():
	$LeftClock.running = true
	$RightClock.running = false

func start_right():
	$LeftClock.running = false
	$RightClock.running = true
