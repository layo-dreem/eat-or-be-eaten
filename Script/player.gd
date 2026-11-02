extends MeshInstance3D

class_name	Player
@export var look_sensitivity: float = 0.005
@export var mouse_manager: MouseManager
@export var mouse_corpse: MouseCorpse

@onready var energy_bar: ProgressBar = $Control/EnergyBar
@onready var owl_sfx: AudioStreamPlayer = $owlSFX
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var ray_cast: RayCast3D = $Head/Camera3D/RayCast
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
		owl_sfx.play()

	if Input.is_action_just_pressed("attack") and ray_cast.is_colliding():
		var c = ray_cast.get_collider()
		# print(c.to_string())
		_on_attack(ray_cast.get_collider())

	energy_bar.value = energy

func _on_attack(collider: Object) -> void:
	var node := collider as Node
	# Remonte jusqu'à trouver une souris vivante ou un cadavre
	while node != null and not (node is MouseCorpse or node.is_in_group("mouse_alive")):
		node = node.get_parent()

	if node == null:
		return

	if node is MouseCorpse:
		node.feed(self)
	else:
		# Souris vivante : on la tue
		mouse_corpse.food = 100
		mouse_manager.call("GoToNewTarget") # même nom que dans le C#
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		yaw = clampf(yaw - event.relative.x * look_sensitivity, -TAU, TAU)
		pitch = clampf(pitch - event.relative.y * look_sensitivity, deg_to_rad(-80), deg_to_rad(80))

		head.rotation.y = yaw
		camera.rotation.x = pitch

	if event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
