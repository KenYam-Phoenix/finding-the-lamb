extends Control

onready var label_name = $HBoxContainer/Label_Name
onready var label_parents = $HBoxContainer/Label_Parents
onready var label_profession = $HBoxContainer/Label_Profession
onready var label_maritalstatus = $HBoxContainer/Label_MaritalStatus
onready var label_children = $HBoxContainer/Label_Children

func setup(male, _name, mother_id, father_id, generation, profession, spouse_id, children_ids):
	label_name.text = _name
	# Set parent label
	if mother_id == -1:
		if generation == 0: label_parents.text = "Founder"
		else: label_parents.text = "Convert"
	else:
		var father_name = CultMember.get_first_name(Cultmaster.get_member_by_id(father_id))
		var mother_name = CultMember.get_first_name(Cultmaster.get_member_by_id(mother_id))
		var father_initial = father_name.substr(0, 1)
		var mother_initial = mother_name.substr(0, 1)
		var surname = CultMember.get_last_name(Cultmaster.get_member_by_id(mother_id))
		label_parents.text = "%s. & %s. %s" % [father_initial, mother_initial, surname]
	# Set profession label
	label_profession.text = CultMember.get_profession_title(profession)
	# Set marital status label
	if spouse_id == -1:
		label_maritalstatus.text = "Unmarried"
	else:
		var partner_name = CultMember.get_full_name(Cultmaster.get_member_by_id(spouse_id))
		label_maritalstatus.text = partner_name
	# Set children label
	if children_ids.size() == 0:
		label_children.text = "No children"
	else:
		var children_string = ""
		for i in range(0, children_ids.size()):
			var next_child_id = children_ids[i]
			var child_name = CultMember.get_first_name(Cultmaster.get_member_by_id(next_child_id))
			children_string += child_name
			if i < children_ids.size() - 1:
				children_string += ", "
		label_children.text = children_string