extends Control

export (String) var slug
export (String, MULTILINE) var text

onready var bumpf = $Bumpf

signal tutorial_done

func _ready():
	if Tutorials.tutorial_already_shown(slug): queue_free()
	bumpf.text = text

func _done():
	Tutorials.tutorial_shown(slug)
	emit_signal("tutorial_done")
	queue_free()
