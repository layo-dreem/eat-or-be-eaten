extends MeshInstance3D

@onready var owl_sfx: AudioStreamPlayer = $owlSFX


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("howl") && !owl_sfx.playing:
		owl_sfx.play()
	
	


func _on_turn_right_pressed() -> void:
	rotate(Vector3(0,1,0), deg_to_rad(90))


func _on_turn_left_pressed() -> void:
	rotate(Vector3(0,1,0), deg_to_rad(-90))
