extends Control

const obj_transition = preload("res://objects/Transition.tscn")

onready var vbox_menu = $VBox_Menu
onready var vbox_areyousure = $VBox_AreYouSure

func transition(scene):
	var transition = obj_transition.instance()
	transition.destination = scene
	add_child(transition)

func _gotoFinalSelection():
	transition("res://scenes/FinalSelection.tscn")

func _displayAreYouSure():
	vbox_menu.hide()
	vbox_areyousure.show()

func _consultSpirits():
	transition("res://scenes/SpiritCommunication.tscn")

func _seeMemberRecords():
	get_tree().change_scene("res://scenes/MemberList.tscn")

func _backToMenu():
	vbox_menu.show()
	vbox_areyousure.hide()

func _tutorial_done():
	vbox_menu.show()

func _ready():
	if Tutorials.tutorial_already_shown("hub"):
		vbox_menu.show()
