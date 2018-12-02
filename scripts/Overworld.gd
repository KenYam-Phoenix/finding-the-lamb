extends Control

onready var vbox_menu = $VBox_Menu
onready var vbox_areyousure = $VBox_AreYouSure


func _gotoFinalSelection():
	get_tree().change_scene("res://scenes/FinalSelection.tscn")

func _displayAreYouSure():
	vbox_menu.hide()
	vbox_areyousure.show()

func _consultSpirits():
	get_tree().change_scene("res://scenes/SpiritCommunication.tscn")

func _seeMemberRecords():
	get_tree().change_scene("res://scenes/MemberList.tscn")

func _backToMenu():
	vbox_menu.show()
	vbox_areyousure.hide()
