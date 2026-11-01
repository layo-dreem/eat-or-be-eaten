extends Node3D

@export var time_before_action: float #En seconde
@export var movement_chance:float # En pourcentage

@export var far_positions: Array[Node3D]
@export var middle_positions: Array[Node3D]
@export var close_positions: Array[Node3D]

var all_positions: Array[Array]

@onready var action_timer: Timer = $ActionTimer

var position_index:int = 0
var proximity_index:int = 0
func _ready() -> void:
	action_timer.wait_time = time_before_action
	action_timer.start()
	all_positions = [far_positions, middle_positions, close_positions]

	position_index = randi_range(0, all_positions[0].size() - 1)
	position = all_positions[0][position_index].global_position

func _on_action_timer_timeout() -> void:
	var chance := randf() * 100.0
	if chance < movement_chance:
		var last_row := all_positions.size() - 1

		if randi_range(0, 1) == 0:
			if proximity_index < last_row:
				proximity_index += 1
				print("Get close")
			else:
				print("Perdu")
				action_timer.stop()
				return
		else:
			if position_index + 1 < all_positions[proximity_index].size():
				position_index += 1
			else:
				position_index = 0
			print("Not Get close")
	else:
		print("Miss")

	position_index = mini(position_index, all_positions[proximity_index].size() - 1)

	position = all_positions[proximity_index][position_index].global_position
