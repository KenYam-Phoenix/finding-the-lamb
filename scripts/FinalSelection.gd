extends Control

const obj_transition = preload("res://objects/Transition.tscn")

onready var vbox = $VBox
onready var menu_lamb = $VBox/Menu_Lamb
onready var menu_spirit = $VBox/Menu_Spirit
onready var button_confirm = $Button_Confirm

var names = []

var which_spirit = -1
var which_lamb = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	menu_spirit.get_popup().add_item("The Red Spirit")
	menu_spirit.get_popup().add_item("The Green Spirit")
	menu_spirit.get_popup().add_item("The Blue Spirit")
	menu_spirit.get_popup().connect("id_pressed", self, "spirit_selected")
	for next_member in Cultmaster.members.values():
		var name = CultMember.get_full_name(next_member)
		menu_lamb.get_popup().add_item(name)
		names.append(name)
	menu_lamb.get_popup().connect("id_pressed", self, "lamb_selected")

func lamb_selected(id):
	menu_lamb.text = names[id]
	which_lamb = id
	if which_spirit != -1: 
		button_confirm.disabled = false
	
func spirit_selected(id):
	menu_spirit.text = ["The Red Spirit", "The Green Spirit", "The Blue Spirit"][id]
	which_spirit = id
	if which_spirit != -1: 
		button_confirm.disabled = false

func _confirm():
	Cultmaster.chosen_lamb = which_lamb
	Cultmaster.chosen_spirit = which_spirit
	var transition = obj_transition.instance()
	transition.destination = "res://scenes/Ending.tscn"
	add_child(transition)

func _tutorial_done():
	vbox.show()
	button_confirm.show()
