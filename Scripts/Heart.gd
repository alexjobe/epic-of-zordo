# Heart.gd
extends TextureRect

var full_texture = preload("res://Assets/Sprites/UI/HeartFull.png")
var three_fourths_texture = preload("res://Assets/Sprites/UI/Heart_3.png")
var half_texture = preload("res://Assets/Sprites/UI/Heart_2.png")
var one_fourth_texture = preload("res://Assets/Sprites/UI/Heart_1.png")
var empty_texture = preload("res://Assets/Sprites/UI/HeartEmpty.png")

enum FILLED {EMPTY, ONE_FOURTH, HALF, THREE_FOURTHS, FULL}

func _ready():
	set_filled(FULL)
			
func set_filled(filled):
	match filled:
		FULL:
			set_texture(full_texture)
		THREE_FOURTHS:
			set_texture(three_fourths_texture)
		HALF:
			set_texture(half_texture)
		ONE_FOURTH:
			set_texture(one_fourth_texture)
		EMPTY:
			set_texture(empty_texture)
