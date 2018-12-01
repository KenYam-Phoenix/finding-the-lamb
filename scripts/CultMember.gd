extends Node

# You'll notice if you go back to the first couple of commits that I intended to do this properly
# (i.e. with Godot's classes)... but I could not get it to work because of some weird problem with
# the garbage collector. So you get this monstrosity instead.

const FIRST_NAMES_MALE = ["James", "John", "Robert", "Michael", "William", "David", "Richard", "Charles", "Joseph", "Thomas", "Christopher", "Daniel", "Paul", "Mark", "Donald", "George", "Kenneth"]
const FIRST_NAMES_FEMALE = ["Mary", "Patricia", "Linda", "Barbara", "Elizabeth", "Jennifer", "Maria", "Susan", "Margaret", "Dorothy", "Lisa", "Nancy", "Karen", "Betty", "Helen", "Sandra", "Donna", "Carol"]
const SURNAMES = ["Smith", "Johnson", "Williams", "Jones", "Brown", "Davis", "Miller", "Wilson", "Moore", "Taylor", "Anderson", "Thomas", "Jackson", "White", "Harris", "Martin", "Thompson", "Garcia", "Hall", "Allen", "Young", "Hernandez", "King", "Wright", "Lopez", "Hill", "Scott", "Green", "Adams", "Baker", "Gonzalez", "Nelson", "Carter"]

const PROFESSIONS = {
	"NONE": {
		"title": "Unemployed",
		"hints": [
			"is a leech on our society",
			"does not do their part"
		]
	},
	"DOCTOR": {
		"title": "Doctor",
		"hints": [
			"tends to the sick",
			"is well-acquainted with the scalpel",
			"does not shy at the sight of blood"
		]
	},
	"LOOKOUT": {
		"title": "Lookout",
		"hints": [
			"has keen eyes",
			"watches over us all"
		]
	},
	"MEDIUM": {
		"title": "Medium",
		"hints": [
			"communes with the faithful departed",
			"pierces the veil of death, and speaks to those beyond"
		]
	},
	"BLACKSMITH": {
		"title": "Blacksmith",
		"hints": [
			"forges mighty steel",
			"bends iron to their will"
		]
	},
	"FARMER": {
		"title": "Farmer",
		"hints": [
			"ploughs the Earth",
			"tends the land"
		]
	},
	"TEACHER": {
		"title": "Teacher",
		"hints": [
			"plants the seeds of faith in the minds of the children",
			"spreads the word of truth",
			"holds at bay the scourge of rebellious thought"
		]
	}
}

var counter = 0

const TEMPLATE = {
	"id": -1,
	"first_name": "",
	"last_name": "",
	"is_male": true,	# Binary choice, partly due to time constraints and partly because
						# this game is depressing enough without considering how enbies fare in cults.
						# Same goes for why you'll only find heterosexual partnerships herein.
	"profession": "NONE",
	"mother_id": -1,
	"father_id": -1,
	"spouse_id": -1,
	"children_ids": [],
	"generation": -1,
	"married": false,
	"alive": true
}

func get_hints(member):
	var hints = []
	# Child count hints
	var child_count = get_children_ids(member).size()
	if child_count == 0:
		hints.append("The lamb is without child.")
	else:
		if is_male(member):
			hints.append("The lamb has sired an heir.")
		else:
			hints.append("The lamb has brought life into this world.")
		# No partner
		if get_spouse_id(member) == -1:
			hints.append("The lamb is solitary.")
	# Are they a newcomer to the cult?
	if get_mother_id(member) == -1:
		hints.append("The lamb is a newcomer to the creed.")
	else:
		# Were either/both of their parents newcomers to the cult?
		var mother = Cultmaster.get_member_by_id(get_mother_id(member))
		var father = Cultmaster.get_member_by_id(get_father_id(member))
		if get_mother_id(mother) == -1:
			if get_mother_id(father) == -1:
				hints.append("The lamb's parents were newcomers to the creed.")
			else:
				hints.append("The lamb's mother was not born into our faith.")
		else:
			if get_mother_id(father) == -1:
				hints.append("The lamb's father was not born into our faith.")
			else:
				hints.append("The lamb is well-rooted within our society.")
	# Hints relating to their profession
	var profession_hints = PROFESSIONS[get_profession(member)]["hints"]
	hints.append("The lamb " + profession_hints[randi() % profession_hints.size()] + ".")
	# Hints relating to their mother
	if get_mother_id(member) != -1:
		var mother = Cultmaster.get_member_by_id(get_mother_id(member))
		var mother_profession_hints = PROFESSIONS[get_profession(mother)]["hints"]
		hints.append("The lamb's mother " + mother_profession_hints[randi() % mother_profession_hints.size()] + ".")
	# Hints relating to their father
	if get_father_id(member) != -1:
		var father = Cultmaster.get_member_by_id(get_father_id(member))
		var father_profession_hints = PROFESSIONS[get_profession(father)]["hints"]
		hints.append("The lamb's father " + father_profession_hints[randi() % father_profession_hints.size()] + ".")
	# Hints relating to their spouse
	if get_spouse_id(member) != -1:
		var spouse = Cultmaster.get_member_by_id(get_spouse_id(member))
		var spouse_profession_hints = PROFESSIONS[get_profession(spouse)]["hints"]
		hints.append("The lamb's partner " + spouse_profession_hints[randi() % spouse_profession_hints.size()] + ".")
	return hints

func get_id(member):
	return member["id"]

func get_first_name(member):
	return member["first_name"]

func get_last_name(member):
	return member["last_name"]

func get_full_name(member):
	return "%s %s" % [member["first_name"], member["last_name"]]

func is_male(member):
	return member["is_male"]

func get_profession(member):
	return member["profession"]

func get_mother_id(member):
	return member["mother_id"]

func get_father_id(member):
	return member["father_id"]

func get_spouse_id(member):
	return member["spouse_id"]

func get_children_ids(member):
	return member["children_ids"]

func get_generation(member):
	return member["generation"]

func is_married(member):
	return member["married"]

func is_alive(member):
	return member["alive"]

func get_full_details(member):
	return "%d: %s %s, %d, %s, %d, %d, %d" % [member["id"], member["first_name"], member["last_name"], member["generation"], member["profession"], member["mother_id"], member["father_id"], member["spouse_id"]]

func set_last_name(member, value):
	member["last_name"] = value

func set_married(member, value):
	member["married"] = value

func set_spouse_id(member, id):
	member["spouse_id"] = id

func add_child_id(member, id):
	member["children_ids"].append(id)

func make_newcomer(generation):
	randomize()
	var is_male = true
	if randf() > 0.5: is_male = false
	# Choose a first name
	var first_name
	if is_male:
		first_name = FIRST_NAMES_MALE[randi() % FIRST_NAMES_MALE.size()]
	else:
		first_name = FIRST_NAMES_FEMALE[randi() % FIRST_NAMES_FEMALE.size()]
	var last_name = SURNAMES[randi() % SURNAMES.size()]
	# Put it all together
	var member = TEMPLATE.duplicate(true)
	member["id"] = counter
	member["first_name"] = first_name
	member["last_name"] = last_name
	member["is_male"] = is_male
	member["profession"] = PROFESSIONS.keys()[randi() % PROFESSIONS.size()]
	member["generation"] = generation
	counter += 1
	return member

func make_child(mother, father):
	randomize()
	var is_male = true
	if randf() > 0.5: is_male = false
	# Choose a first name
	var first_name
	if is_male:
		first_name = FIRST_NAMES_MALE[randi() % FIRST_NAMES_MALE.size()]
	else:
		first_name = FIRST_NAMES_FEMALE[randi() % FIRST_NAMES_FEMALE.size()]
	# Put it all together
	var member = TEMPLATE.duplicate(true)
	member["id"] = counter
	member["first_name"] = first_name
	member["last_name"] = get_last_name(father)
	member["is_male"] = is_male
	member["profession"] = PROFESSIONS.keys()[randi() % PROFESSIONS.size()]
	member["mother_id"] = get_id(mother)
	member["father_id"] = get_id(father)
	member["generation"] = get_generation(father) + 1
	member["id"] = counter
	counter += 1
	return member

func reset():
	randomize()
	counter = 0
