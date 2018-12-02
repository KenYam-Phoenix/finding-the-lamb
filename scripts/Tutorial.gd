extends Control

export (String, MULTILINE) var text

onready var bumpf = $Bumpf

func _ready():
	bumpf.text = text

func _done():
	queue_free()
