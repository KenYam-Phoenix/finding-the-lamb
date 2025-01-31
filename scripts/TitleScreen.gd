extends Control

const obj_transition = preload("res://objects/Transition.tscn")

func _play():
	Cultmaster.setup_game()
	Cultmaster.setup_sages()
	var transition = obj_transition.instance()
	transition.destination = "res://scenes/Intro.tscn"
	add_child(transition)

func _exit():
	get_tree().quit()
