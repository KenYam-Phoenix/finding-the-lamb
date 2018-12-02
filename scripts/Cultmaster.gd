extends Node

# This file deals with all of the behind-the-scenes stuff regarding the cult
# and the sacrifice that needs to be made.

# I'm storing these in dicts because Godot copies values where Java would reference them -
# in function arguments and the like - so it's better to instead deal with an object's ID,
# under which they'll be stored in these dicts.
var members
var lamb
var sages
var fake_sage

# The decisions the player makes
var chosen_lamb
var chosen_spirit

func get_member_by_id(id):
	return members[id]

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

func get_latest_generation():
	var result = 0
	for next in members.values():
		result = max(result, CultMember.get_generation(next))
	return result

# We assume that, for some strange reason, if someone has great-grandchildren, they have died.
func get_living_member_count():
	var gen = get_latest_generation()
	var result = 0
	for next in members.values():
		if CultMember.get_generation(next) >= gen - 2:
			result += 1
	return result

func get_member_count_for_generation(which):
	var result = 0
	for next in members.values():
		if CultMember.get_generation(next) == which: result += 1
	return result

func get_unique_surname_count_for_generation(which):
	var result = []
	for next in members.values():
		if CultMember.get_generation(next) == which:
			var surname = CultMember.get_last_name(next)
			if not surname in result: result.append(surname)
	return result.size()

# Takes a single man, finds him the first suitable non-married woman,
# and forces them to start a family. 10/10 cult simulation
func make_family():
	var husband_id = find_eligable_bachelor()
	if husband_id == null: return false
	var husband = members[husband_id]
	var wife_id = find_eligable_wife(husband)
	var wife = members[wife_id]
	#print("%s is marrying %s" % [CultMember.get_full_name(wife), CultMember.get_full_name(husband)])
	CultMember.set_spouse_id(husband, wife_id)
	CultMember.set_spouse_id(wife, husband_id)
	# Back off, everyone else; they're taken
	for next in [husband, wife]:
		CultMember.set_married(next, true)
	CultMember.set_last_name(wife, CultMember.get_last_name(husband))
	# Make a few kids
	if randf() > 0.15:
		for i in range(0, rand_range(1, 5)):
			var child = CultMember.make_child(wife, husband)
			CultMember.add_child_id(husband, CultMember.get_id(child))
			CultMember.add_child_id(wife, CultMember.get_id(child))
			members[CultMember.get_id(child)] = child
			#print("%s, child of %s and %s, is born" % [CultMember.get_full_name(child), CultMember.get_first_name(husband), CultMember.get_first_name(wife)])
	return true

func make_newcomer(gen):
	var newcomer = CultMember.make_newcomer(gen)
	members[CultMember.get_id(newcomer)] = newcomer
	#print("%s joined the village" % [CultMember.get_full_name(newcomer)])

func try_populating_cult():
	CultMember.reset()
	members = {}
	# Start by making just a few generation-zero members
	for i in range(0, 7):
		make_newcomer(0)
	# While (able to make babies): make_babies()
	while get_living_member_count() < 16:
		var gen = get_latest_generation()
		# Every 1 in 3 newcomers will be from outside the cult, not born within
		if randf() > 0.66: make_newcomer(gen)
		else: make_family()

# The generation algorithm we're using is a bit... crap.
# So rather than improve it, let's just impose a bunch of constraints,
# and make it repeat itself over and over, until it gives us what we want.
func setup_game():
	var acceptable = false
	while !acceptable:
		try_populating_cult()
		lamb = members.keys()[randi() % members.size()]
		acceptable = true
		for i in range (1, 3):
			if get_member_count_for_generation(i) < 4:
				acceptable = false
			if get_unique_surname_count_for_generation(i) < 3:
				acceptable = false
		if get_latest_generation() > 3:
			acceptable = false
		# Make sure we have at least four hints
		var hints = CultMember.get_hints(members[lamb])
		if hints.size() < 4: acceptable = false
		# Make sure we don't have any shared names
		var names = []
		for next_person in members.values():
			if CultMember.get_full_name(next_person) in names:
				acceptable = false
			else: names.append(CultMember.get_full_name(next_person))

func setup_sages():
	var hints = CultMember.get_hints(members[lamb])
	hints.resize(4)
	var hints_a = hints.duplicate()
	var hints_b = hints.duplicate()
	hints_a.resize(2)
	for i in range(0, 2): hints_b.remove(0)
	var fake_hints = CultMember.get_hints(members[randi() % 16])
	fake_hints.resize(2)
	sages = [hints_a, hints_b]
	fake_sage = randi() % 3
	sages.insert(fake_sage, fake_hints)

func _ready():
	setup_game()
	setup_sages()
	pass
#	setup_game()
#	for next in members.values():
#		print(CultMember.get_full_details(next))
#	setup_sages()
#	for i in range(0, 3):
#		print("Sage #%d says:" % int(i+1))
#		for next in sages[i]:
#			print("\"%s\"" % next)
#	print("The lamb is %s" % CultMember.get_full_name(members[lamb]))
#	print("The fake sage is #%d" % int(fake_sage+1))
	