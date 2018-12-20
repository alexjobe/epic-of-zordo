# SceneChange.gd
extends Area2D

export(String, FILE, "*.tscn") var next_scene
# Where the player will spawn in the next scene
export(Vector2) var spawn_location

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			Global.player_location = spawn_location
			get_tree().change_scene(next_scene)