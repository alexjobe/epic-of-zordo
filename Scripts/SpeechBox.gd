extends TextureRect

onready var label = $Label

func _on_Quest_stage_changed(new_text):
	label.text = new_text
