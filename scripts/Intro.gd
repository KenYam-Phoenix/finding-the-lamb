extends Control

onready var anim_player = $AnimationPlayer
onready var label_paragraph1 = $Center/VBox/Label_Paragraph1
onready var label_paragraph2 = $Center/VBox/Label_Paragraph2
onready var label_paragraph3 = $Center/VBox/Label_Paragraph3
onready var audio_ambience = $Audio_Ambience

var stage = 0

const INTRO_A = [
	"The end is nigh.",
	"Away from the incessant din of modern civilisation, your creed has lived its humble life, keeping the grounds of those who first brought the word of faith to those that would hear it.",
	"Now, from your quiet perch, you can hear the death knell that none other will heed. The earth itself trembles with fear at an unseen executioner..."
]
const INTRO_B = [
	"But those that dwell beyond live by strange rules. The destruction of humanity can be averted... at a cost.",
	"Amongst your people walks The Lamb; one whose life will appease the gods of destruction that now regard the world with hungry eyes.",
	"The faith is yours to command. Any one of them would give themselves at your word. You need only determine who it is."
]

func _ready():
	audio_ambience.play()
	anim_player.play("FadeIn")

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		anim_player.playback_speed = 10
	else:
		anim_player.playback_speed = 1

func setup_block():
	var next_block
	if stage == 1:
		next_block = INTRO_A
	if stage == 2:
		next_block = INTRO_B
	elif stage == 3:
		anim_player.play("FadeOut")
		return
	elif stage == 4:
		get_tree().change_scene("res://scenes/Overworld.tscn")
		return
	# Set it into paragraphs
	var paragraphs = [label_paragraph1, label_paragraph2, label_paragraph3]
	for i in range(0, 3):
		paragraphs[i].text = next_block[i]
	# Start the animation
	anim_player.play("Intro")

func _animation_finished(anim_name):
	stage += 1
	setup_block()
