extends MeshInstance3D

@onready var owl_sfx: AudioStreamPlayer = $owlSFX

@export var look_sensitivity: float = 0.005
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D

var yaw: float = 0.0
var pitch: float = 0.0

func _ready() -> void:
	yaw = head.rotation.y
	pitch = camera.rotation.x

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("howl") && !owl_sfx.playing:
		owl_sfx.play()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		yaw = clampf(yaw - event.relative.x * look_sensitivity, -TAU, TAU)
		pitch = clampf(pitch - event.relative.y * look_sensitivity, deg_to_rad(-80), deg_to_rad(80))

		head.rotation.y = yaw
		camera.rotation.x = pitch

	if event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
