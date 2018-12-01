extends Node

# This file deals with all of the behind-the-scenes stuff regarding the cult
# and the sacrifice that needs to be made.

const FIRST_NAMES_MALE = ["James", "John", "Robert", "Michael", "William", "David", "Richard", "Charles", "Joseph", "Thomas", "Christopher", "Daniel", "Paul", "Mark", "Donald", "George", "Kenneth"]
const FIRST_NAMES_FEMALE = ["Mary", "Patricia", "Linda", "Barbara", "Elizabeth", "Jennifer", "Maria", "Susan", "Margaret", "Dorothy", "Lisa", "Nancy", "Karen", "Betty", "Helen", "Sandra", "Donna", "Carol"]
const SURNAMES = ["Smith", "Johnson", "Williams", "Jones", "Brown", "Davis", "Miller", "Wilson", "Moore", "Taylor", "Anderson", "Thomas", "Jackson", "White", "Harris", "Martin", "Thompson", "Garcia", "Hall"]

const PROFESSION = {
	"DOCTOR": {
		"title": "Doctor",
		"clues": [
			"tends to the sick",
			"is well-acquainted with the scalpel",
			"does not shy at the sight of blood"
		]
	},
	"LOOKOUT": {
		"title": "Lookout",
		"clues": [
			"has keen eyes",
			"watches over us all"
		]
	},
	"MEDIUM": {
		"title": "Medium",
		"clues": [
			"communes with the faithful departed",
			"pierces the veil of death, and speaks to those beyond"
		]
	},
	"BLACKSMITH": {
		"title": "Blacksmith",
		"clues": [
			"forges mighty steel",
			"bends iron to their will"
		]
	},
	"FARMER": {
		"title": "Farmer",
		"clues": [
			"ploughs the Earth",
			"tends the land"
		]
	},
	"TEACHER": {
		"title": "Teacher",
		"clues": [
			"plants the seeds of faith in the minds of the children",
			"spreads the word of truth",
			"holds at bay the scourge of rebellious thought"
		]
	}
}

const WEAPON_MATERIAL = {
	"STEEL": {},
	"COPPER": {},
	"GOLD": {},
	"WOOD": {}
}

const WEAPON_TYPE = {
	"DAGGER": {},
	"SCYTHE": {}
}

const LOCATION_GROUND = {
	"EARTH": {},
	"WATER": {},
	"STONE": {}
}

class Sacrifice:
	var subject_id
	var weapon_id
	var location_id
	var time
	
	func _init(_subject, _weapon, _location, _time):
		subject_id = _subject
		weapon_id = _weapon
		location_id = _location
		time = _time

class Subject:
	var id
	var mother_id
	var father_id
	var children_ids
	var first_name
	var last_name
	var is_male # Binary choice, partly due to time constraints and partly because
				# this game is depressing enough without considering how enbies fare in cults.
				# Same goes for why you'll only find heterosexual partnerships herein.
	var generation
	var married
	var alive
	
	func _init(_mother_id, _father_id, _first_name, _last_name, _is_male, _generation):
		id = randi() # TODO: replace this with something less prone to breaking horribly
		mother_id = _mother_id
		father_id = _father_id
		children_ids = []
		first_name = _first_name
		last_name = _last_name
		is_male = _is_male
		generation = _generation
		married = false
		alive = true

class Weapon:
	var id
	var owner_id

class Location:
	var id
	var ground

# I'm storing these in dicts because Godot copies values where Java would reference them -
# in function arguments and the like - so it's better to instead deal with an object's ID,
# under which they'll be stored in these dicts.
var subjects = {}
var weapons = {}
var locations = {}

const SACRIFICE_TIME = {
	"SUNRISE": {},
	"NOON": {},
	"SUNSET": {},
	"MIDNIGHT": {}
}

# For making the members of the first generation
func make_family_starter():
	var is_male = true
	if randf() > 0.5: is_male = false
	# Choose a first name
	var first_name
	if is_male:
		first_name = FIRST_NAMES_MALE[randi() % FIRST_NAMES_MALE.size()]
	else:
		first_name = FIRST_NAMES_FEMALE[randi() % FIRST_NAMES_FEMALE.size()]
	var last_name = SURNAMES[randi() % SURNAMES.size()]
	return Subject.new(-1, -1, first_name, last_name, is_male, 0)

func make_descendent(mother, father):
	var is_male = true
	if randf() > 0.5: is_male = false
	# Choose a first name
	var first_name
	if is_male:
		first_name = FIRST_NAMES_MALE[randi() % FIRST_NAMES_MALE.size()]
	else:
		first_name = FIRST_NAMES_FEMALE[randi() % FIRST_NAMES_FEMALE.size()]
	return Subject.new(mother.id, father.id, first_name, father.last_name, is_male, father.generation + 1)

func find_eligable_bachelor():
	for next_candidate in subjects:
		if !next_candidate.is_alive: continue
		if !next_candidate.is_male: continue
		if next_candidate.married: continue
		# Now let's skip ahead a bit, and make sure there's actually someone he can hook up with
		if find_eligable_wife(next_candidate) == null: continue
		return next_candidate.id
	print("Couldn't find an eligable bachleor")
	return null

func find_eligable_wife(male):
	for next_candidate in subjects:
		if !next_candidate.is_alive: continue
		if next_candidate.is_male: continue
		if next_candidate.married: continue
		if next_candidate.last_name == male.last_name: continue # Not 100% incest-proof, but for a cult, it's more than enough
		if next_candidate.generation != male.generation: continue
		return next_candidate.id
	print("Couldn't find an eligable wife for %s %s" % [male.first_name, male.last_name])
	return null

# Takes a single man, finds him the first suitable non-married woman,
# and forces them to start a family. 10/10 cult simulation
func make_family():
	var husband_id = find_eligable_bachelor()
	if husband_id == null: return false
	var husband = subjects[husband_id]
	var wife_id = find_eligable_wife(husband)
	var wife = subjects[wife_id]
	print("%s %s is marrying %s %s" % [husband.first_name, husband.last_name, wife.first_name, wife.last_name])
	husband.is_married = true
	wife.is_married = true
	wife.last_name = husband.last_name
	# Make a few kids
	for i in range(0, rand_range(2, 6)):
		var child = make_descendent(wife, husband)
		husband.children_ids.append(child.id)
		wife.children_ids.append(child.id)
		subjects[child.id] = child
		print("%s %s, child of %s and %s, is born" % [child.first_name, child.last_name, husband.first_name, wife.first_name])
	return true

func make_cult_population():
	# Start by making just a few generation-zero members
	for i in range(0, 6):
		var newbie = make_family_starter()
		subjects[newbie.id] = newbie
		print("%s %s joined the village" % [newbie.first_name, newbie.last_name])
	# While (able to make babies): make_babies()
	var result = true
	while result == true:
		result = make_family()

# Of all the items generated so far, randomly select the ones that will be needed
func choose_necessary_sacrifice():
	var subject = subjects.keys()[randi() % subjects.size()]
	var weapon = weapons.keys()[randi() % weapons.size()]
	var location = locations.keys()[randi() % locations.size()]
	var time = SACRIFICE_TIME.keys()[randi() % SACRIFICE_TIME.size()]
	# Put it all together
	var sacrifice = Sacrifice.new(subject, weapon, location, time)
	return sacrifice

func _ready():
	make_cult_population()
