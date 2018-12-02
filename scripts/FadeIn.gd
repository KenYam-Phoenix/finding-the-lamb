extends Control

onready var anim_player = $AnimationPlayer

func _ready():
	anim_player.play("FadeIn")

func _animation_finished(anim_name):
	queue_free()
