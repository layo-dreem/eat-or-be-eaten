extends Node3D
@export var min_delay: float = 2.0
@export var max_delay: float = 6.0

@onready var forest: AudioStreamPlayer = $forest
@onready var wind: AudioStreamPlayer = $wind
@onready var crow: AudioStreamPlayer = $crow
@onready var crow_timer: Timer = $CrowTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_start_timer()
	
func _start_timer() -> void:
	crow_timer.start(randf_range(min_delay, max_delay))


func _on_crow_timer_timeout() -> void:
	crow.play()
	_start_timer()
