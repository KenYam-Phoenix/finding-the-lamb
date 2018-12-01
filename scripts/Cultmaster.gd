extends Node

# This file deals with all of the behind-the-scenes stuff regarding the cult
# and the sacrifice that needs to be made.
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

class Weapon:
	var id
	var owner_id

class Location:
	var id
	var ground

# I'm storing these in dicts because Godot copies values where Java would reference them -
# in function arguments and the like - so it's better to instead deal with an object's ID,
# under which they'll be stored in these dicts.
var members = {}
var weapons = []
var locations = []

const SACRIFICE_TIME = {
	"SUNRISE": {},
	"NOON": {},
	"SUNSET": {},
	"MIDNIGHT": {}
}

func find_eligable_bachelor():
	for next_candidate in members.values():
		if !CultMember.is_alive(next_candidate): continue
		if !CultMember.is_male(next_candidate): continue
		if CultMember.is_married(next_candidate): continue
		# Now let's skip ahead a bit, and make sure there's actually someone he can hook up with
		if find_eligable_wife(next_candidate) == null: continue
		return CultMember.get_id(next_candidate)
	#print("Couldn't find an eligable bachleor")
	return null

func find_eligable_wife(male):
	for next_candidate in members.values():
		if !CultMember.is_alive(next_candidate): continue
		if CultMember.is_male(next_candidate): continue
		if CultMember.is_married(next_candidate): continue
		if CultMember.get_last_name(next_candidate) == CultMember.get_last_name(male): continue # Not 100% incest-proof, but for a cult, it's more than enough
		if CultMember.get_generation(next_candidate) != CultMember.get_generation(male): continue
		return CultMember.get_id(next_candidate)
	#print("Couldn't find an eligable wife for %s" % [CultMember.get_full_name(male)])
	return null

# Takes a single man, finds him the first suitable non-married woman,
# and forces them to start a family. 10/10 cult simulation
func make_family():
	var husband_id = find_eligable_bachelor()
	if husband_id == null: return false
	var husband = members[husband_id]
	var wife_id = find_eligable_wife(husband)
	var wife = members[wife_id]
	print("%s is marrying %s" % [CultMember.get_full_name(wife), CultMember.get_full_name(husband)])
	# Back off, everyone else; they're taken
	for next in [husband, wife]:
		CultMember.set_married(next, true)
	CultMember.set_last_name(wife, CultMember.get_last_name(husband))
	# Make a few kids
	for i in range(0, rand_range(1, 4)):
		var child = CultMember.make_child(wife, husband)
		CultMember.add_child_id(husband, CultMember.get_id(child))
		CultMember.add_child_id(wife, CultMember.get_id(child))
		members[CultMember.get_id(child)] = child
		print("%s, child of %s and %s, is born" % [CultMember.get_full_name(child), CultMember.get_first_name(husband), CultMember.get_first_name(wife)])
	return true

func make_cult_population():
	# Start by making just a few generation-zero members
	for i in range(0, 6):
		var newcomer = CultMember.make_newcomer()
		members[CultMember.get_id(newcomer)] = newcomer
		print("%s joined the village" % [CultMember.get_full_name(newcomer)])
	# While (able to make babies): make_babies()
	var result = true
	while result == true:
		result = make_family()

# Of all the items generated so far, randomly select the ones that will be needed
func choose_necessary_sacrifice():
	var subject = members.keys()[randi() % members.size()]
	var weapon = weapons.keys()[randi() % weapons.size()]
	var location = locations.keys()[randi() % locations.size()]
	var time = SACRIFICE_TIME.keys()[randi() % SACRIFICE_TIME.size()]
	# Put it all together
	var sacrifice = Sacrifice.new(subject, weapon, location, time)
	return sacrifice

func _ready():
	make_cult_population()
