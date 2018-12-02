extends Node

var tutorials_shown = []

func tutorial_already_shown(which):
	if which in tutorials_shown: return true
	return false

func tutorial_shown(which):
	tutorials_shown.append(which)