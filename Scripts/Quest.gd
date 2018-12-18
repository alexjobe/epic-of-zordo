extends Node

var quest_id = 0
enum STAGE {START, IN_PROGRESS, COMPLETED}

signal stage_changed

export (String) var start_text = ""
export (String) var progress_text = ""
export (String) var completed_text = ""

func _ready():
	set_stage(Global.quest_stage)
	
func set_stage(new_stage):
	Global.quest_stage = new_stage
	
	match new_stage:
		START:
			emit_signal("stage_changed", start_text)
		IN_PROGRESS:
			emit_signal("stage_changed", progress_text)
		COMPLETED:
			emit_signal("stage_changed", completed_text)
