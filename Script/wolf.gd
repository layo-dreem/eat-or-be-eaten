extends Node3D

@export var positions: Array[Node3D]
@export var time_before_action: float #En seconde
@export var movement_chance:float # En pourcentage

@onready var action_timer: Timer = $ActionTimer

var position_index:int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	action_timer.wait_time = time_before_action
	action_timer.start()


func _on_action_timer_timeout() -> void:
	if	randi_range(0, 100) < movement_chance:
		position_index = position_index +1
		if position_index >= positions.size():
			print("You lost")
		else:
			position = positions[position_index].position
