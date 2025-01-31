extends Control

const obj_transition = preload("res://objects/Transition.tscn")

onready var spirit_message = $SpiritMessage
onready var blur = $Blur
onready var hbox_inhale = $HBox_Inhale
onready var button_exhale = $Button_Exhale
onready var button_done = $Button_Done
onready var sound_inhale = $Inhale
onready var sound_exhale = $Exhale
onready var sound_drone = $Ambience

var hallucinate_actual = 0.0
var hallucinate_target = 0.0

func _ready():
	if Tutorials.tutorial_already_shown("spirits"):
		_tutorial_done()

func _process(delta):
	hallucinate_actual = lerp(hallucinate_actual, hallucinate_target, delta/3.0)
	spirit_message.modulate.a = pow(hallucinate_actual, 5.0)
	blur.get_material().set_shader_param("amount", hallucinate_actual)

func _inhale_red():
	spirit_message.set_message(Cultmaster.sages[0][0], Cultmaster.sages[0][1])
	blur.get_material().set_shader_param("tint", Vector3(1.0, 0.5, 0.5))
	hallucinate_target = 0.75
	hbox_inhale.visible = false
	button_done.visible = false
	button_exhale.visible = true
	sound_inhale.play()

func _inhale_green():
	spirit_message.set_message(Cultmaster.sages[1][0], Cultmaster.sages[1][1])
	blur.get_material().set_shader_param("tint", Vector3(0.5, 1.0, 0.5))
	hallucinate_target = 0.75
	hbox_inhale.visible = false
	button_done.visible = false
	button_exhale.visible = true
	sound_inhale.play()

func _inhale_blue():
	spirit_message.set_message(Cultmaster.sages[2][0], Cultmaster.sages[2][1])
	blur.get_material().set_shader_param("tint", Vector3(0.5, 0.75, 1.0))
	hallucinate_target = 0.75
	hbox_inhale.visible = false
	button_done.visible = false
	button_exhale.visible = true
	sound_inhale.play()

func _exhale():
	hallucinate_target = 0.0
	hbox_inhale.visible = true
	button_done.visible = true
	button_exhale.visible = false
	sound_exhale.play()

func _backToMenu():
	sound_exhale.stop()
	sound_drone.stop()
	var transition = obj_transition.instance()
	transition.destination = "res://scenes/Overworld.tscn"
	add_child(transition)

func _tutorial_done():
	hbox_inhale.visible = true
	button_done.visible = true
