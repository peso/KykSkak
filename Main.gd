extends Control

onready var in_play: Node = find_node("InPlay")
onready var rules: Node = find_node("Rules")
onready var clocks: Node = find_node("GameClocks")
onready var rule_progress = find_node("Progress")

var timer_variation := 15
var timer_time := 60

var current_rule : Dictionary

func _ready():
	randomize()
	$AcceptRule.get_cancel().text = "Decline"
	$AcceptRule.add_button("Wait").connect("pressed", self, "_on_Wait_pressed")
	var tab_container = find_node("TabContainer")
	tab_container.set_tab_title(0,"Regler i spil")
	tab_container.set_tab_title(1,"Alle regler")


func _process(delta: float) -> void:
	rule_progress.value = 100 - $Timer.time_left*100/$Timer.wait_time


func _on_Timer_timeout():
	_new_rule()

func _new_rule():
	current_rule = rules.get_rule()
	if current_rule:
		$NotifySound.play()
		$AcceptRule/Text.text = "Vil du acceptere reglen:\n" + current_rule.name
		$AcceptRule/Text.hint_tooltip = current_rule.description
		$AcceptRule.popup()


func _wait_for_rule() -> void:
	$Timer.wait_time = max(0.1,timer_time + randi()%(2*timer_variation) - timer_variation)
	$Timer.start()


func _on_AcceptRule_confirmed():
	rules.put_rule_in_game(current_rule.id)
	in_play.add(current_rule.name, current_rule.description, current_rule.id)
	$Timer.start()
	current_rule = {}
	_wait_for_rule()


func _on_AcceptRule_popup_hide():
	yield(get_tree(), "idle_frame")
	if current_rule:
		$Timer.wait_time = .2
		$Timer.start()


func _on_Wait_pressed() -> void:
	current_rule = {}
	_wait_for_rule()
	$AcceptRule.hide()


func _on_Start_pressed():
	rules.start_game()
	in_play.reset()
	_new_rule()
	clocks.reset()


func _on_Stop_pressed():
	$Timer.stop()
	clocks.stop()


func _on_NewRule_pressed():
	if $Timer.time_left > 0:
		$Timer.stop()
		_new_rule()


func _on_GameTime_value_changed(value):
	clocks.time_per_player = value


func _on_RuleTime_value_changed(value):
	timer_time = value
