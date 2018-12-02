extends Control

onready var anim_player = $AnimationPlayer

var destination

func _ready():
	get_tree().paused = true
	anim_player.play("FadeOut")

func _animation_finished(anim_name):
	get_tree().paused = false
	get_tree().change_scene(destination)
