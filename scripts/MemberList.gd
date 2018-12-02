extends Control

const obj_memberoverview = preload("res://objects/MemberOverview.tscn")

onready var vbox_members = $ScrollContainer/VBox_Members
onready var audio_bookopen = $Audio_BookOpen

func _ready():
	audio_bookopen.play()
	# Make header row
	var header = obj_memberoverview.instance()
	vbox_members.add_child(header)
	header.setup_header()
	# Fill out member rows
	var members = Cultmaster.members.values()
	for next_member in members:
		var member_overview = obj_memberoverview.instance()
		vbox_members.add_child(member_overview)
		member_overview.setup(
			CultMember.is_male(next_member), CultMember.get_full_name(next_member),
			CultMember.get_mother_id(next_member), CultMember.get_father_id(next_member),
			CultMember.get_generation(next_member), CultMember.get_profession(next_member),
			CultMember.get_spouse_id(next_member), CultMember.get_children_ids(next_member)
		)

func _backToMenu():
	get_tree().change_scene("res://scenes/Overworld.tscn")
