extends TextureButton


# Declare member variables
export var time_left = 300
export var running = false


signal before_click()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if running:
		time_left -= delta
		
		# Make arms shake when all time is used
		if time_left < -1:
			time_left += 1
	
	# Show mm:ss as hh:mm:00
	# Clock should work backwards
	$Min.rotation_degrees = time_left * 360 / 60
	$Hour.rotation_degrees = time_left * 360 / (60 * 12)


func _on_pressed():
	var was_running = running
	emit_signal("before_click")
	running = !was_running
