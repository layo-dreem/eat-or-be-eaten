extends MeshInstance3D

class_name	PlayerController
@export var look_sensitivity: float = 0.005
@export var mouse_manager: MouseManager
@export var mouse_corpse: MouseCorpse

@onready var energy_bar: ProgressBar = $Control/EnergyBar
@onready var owl_sfx: AudioStreamPlayer = $owlSFX
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var mouse_raycast: RayCast3D = $Head/Camera3D/MouseRaycast
@onready var wolf_raycast: RayCast3D = $Head/Camera3D/WolfRaycast
@onready var transition: Transition = $Transition

const MOUSE = preload("uid://cn1cde8nx5vc1")

var yaw: float = 0.0
var pitch: float = 0.0
@export var energy = 25
@export var max_energy := 100

func _ready() -> void:
	yaw = head.rotation.y
	pitch = camera.rotation.x


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("howl") and not owl_sfx.playing:
		_howl(wolf_raycast.get_collider())

	if Input.is_action_just_pressed("attack") and mouse_raycast.is_colliding():
		_on_attack(mouse_raycast.get_collider())

	energy_bar.value = energy


func _on_attack(collider: Object) -> void:
	var node := collider as Node
	while node != null and not (node is MouseCorpse or node is Mouse):
		node = node.get_parent()

	if node == null:
		return

	if node is MouseCorpse:
		node.feed(self)
		if energy >= 100:
			$"You Win".show()
			$AnimationPlayer.play("FlyAway")
			transition.show()
			transition._transition()
			$Timer.start()
			
	else:
		mouse_corpse.food += 5
		mouse_manager.call("GoToNewTarget")

func _howl(collider: Object) -> void:
	if energy < 12:
		return
	energy -= 12
	owl_sfx.play()

	var node := collider as Node
	while node != null and not (node is Wolf):
		node = node.get_parent()

	if node == null:
		print("Null")
		return

	print("wolf trouvé, proximity = ", node.proximity_index)
	if node.proximity_index > 0:
		node.proximity_index -= 1
		if node.position_index + 1 < node.all_positions[node.proximity_index].size():
			node.position_index += 1
		else:
			node.position_index = 0
		node._move()
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		yaw = clampf(yaw - event.relative.x * look_sensitivity, -TAU, TAU)
		pitch = clampf(pitch - event.relative.y * look_sensitivity, deg_to_rad(-80), deg_to_rad(80))

		head.rotation.y = yaw
		camera.rotation.x = pitch

	if event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _game_over() -> void:
	$"Game Over".show()
	transition.show()
	transition._transition()
	$Timer.start()


func _on_timer_timeout() -> void:
	get_tree().quit()
