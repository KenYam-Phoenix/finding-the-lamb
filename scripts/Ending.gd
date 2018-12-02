extends Control

onready var anim_player = $AnimationPlayer
onready var label_paragraph1 = $Center/VBox/Label_Paragraph1
onready var label_paragraph2 = $Center/VBox/Label_Paragraph2
onready var label_paragraph3 = $Center/VBox/Label_Paragraph3
onready var audio_ambience = $Audio_Ambience

var stage = 0

const SACRIFICE_A = [
	"Your entourage shuffles from the security of the village into the cold unknown. Few speak beyond the occasional murmur.",
	"The lamb is silent, and never once meets your eyes. You have to wonder if, somehow, it had known all along.",
	"Without ceremony, you reach the ceremonial grounds. A rudimentary altar juts from the ground. The lamb embraces its friends half-heartedly, then lies down.",
]
const SACRIFICE_B = [
	"The lamb writhes as you plunge the knife into its gut. Its eyes are open now, locked on yours as you return the blade to your side, your hand sticky with blood.",
	"It begins to gasp. As the minutes pass, its breathing becomes more desperate. It shivers from the cold. Eventually, it is still.",
	"The others look to you, silently asking the question: \"is it over?\""
]
const ENDING_GOOD = [
	"The air has not calmed, nor the sky lightened from its sombre tones... but you can feel it. The danger has passed.",
	"The spirits are silent, begrudgingly accepting your victory... and awaiting their next opportunity to toy with you.",
	"At your word, your fellowship begins the march back home."
]
const ENDING_WRONG_LAMB = [
	"But the scratching at the back of your mind is still there. The corpse now in front of you was not the lamb.",
	"You think you hear the chortling of three spirits from beyond. You may have won their game, but their deception is complete.",
	"You feel the eyes of those you led astray, and the knife is still in your hand..."
]
const ENDING_WRONG_SPIRIT = [
	"The sense of doom abates... only to be replaced with one of another kind. You chose true; the lamb is dead, the world's fate averted...",
	"But those who guided you named their price, and you failed to deliver. Their amused indifference to you is replaced with contempt.",
	"Your knuckles turn white as they clench around the handle of your blade. If this is the end, at least you can die on your own terms..."
]
const ENDING_BOTH_WRONG = [
	"Lucidity settles over you with a terrifying silence. For the first time tonight, you see the body of the person you murdered.",
	"In a sudden flash of clarity, you realise that you were wrong... about the lamb, about the sage; and about how much else?",
	"Doubt floods your mind. But you are certain of one thing; even if the world's fate is sealed, it doesn't matter now. The knife is still in your hand."
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
		next_block = SACRIFICE_A
	if stage == 2:
		next_block = SACRIFICE_B
	elif stage == 3:
		if Cultmaster.chosen_lamb == Cultmaster.lamb:
			if Cultmaster.chosen_spirit == Cultmaster.fake_sage:
				next_block = ENDING_GOOD
			else:
				next_block = ENDING_WRONG_SPIRIT
		else:
			if Cultmaster.chosen_spirit == Cultmaster.fake_sage:
				next_block = ENDING_WRONG_LAMB
			else:
				next_block = ENDING_BOTH_WRONG
	elif stage == 4:
		anim_player.play("FadeOut")
		return
	elif stage == 5:
		get_tree().change_scene("res://scenes/TitleScreen.tscn")
		return
	# Set it into paragraphs
	var paragraphs = [label_paragraph1, label_paragraph2, label_paragraph3]
	for i in range(0, 3):
		paragraphs[i].text = next_block[i]
	# Start the animation
	anim_player.play("Ending")

func _animation_finished(anim_name):
	stage += 1
	setup_block()
