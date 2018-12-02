extends Control

export (String) var slug
export (String, MULTILINE) var text

onready var bumpf = $Bumpf

func _ready():
	if Tutorials.tutorial_already_shown(slug): queue_free()
	bumpf.text = text

func _done():
	Tutorials.tutorial_shown(slug)
	queue_free()
