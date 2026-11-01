extends Node3D
class_name MouseCorpse

@export var food: int = 0 # en %
var canBeAte

func feed(player: Player) -> void:
	if food <= 0 || !canBeAte:
		return
	food -= 1
	player.energy = mini(player.energy + 2, player.max_energy)
	print("Miam")

func _process(delta: float) -> void:
	if food <= 0:
		food = 0
		canBeAte = false
		$MeshInstance3D.hide()
	else:
		canBeAte = true
		$MeshInstance3D.show()
