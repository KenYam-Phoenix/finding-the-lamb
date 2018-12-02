extends Control

onready var messageA = $Label_MessageA
onready var messageB = $Label_MessageB

var rotation_amount = 150

func set_message(textA, textB):
	messageA.text = textA
	messageB.text = textB

func _process(delta):
	rotation_amount += delta * 10
	var x = (cos(deg2rad(rotation_amount)) * 30) + (cos(deg2rad(rotation_amount)) * 10) + (cos(deg2rad(rotation_amount)) * 3)
	var y = (sin(deg2rad(rotation_amount)) * 60) + (sin(deg2rad(rotation_amount)) * 20) + (sin(deg2rad(rotation_amount)) * 6)
	messageA.rect_position.x = -560+x
	messageA.rect_position.y = 232-y
	messageB.rect_position.x = -560-x
	messageB.rect_position.y = 232+y
