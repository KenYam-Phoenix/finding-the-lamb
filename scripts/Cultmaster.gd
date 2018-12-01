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
			"spreads the word of our truth",
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
	var alive

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
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
