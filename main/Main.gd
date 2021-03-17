extends Node

func _ready():
	var level = load(Game.levels[Game.current_level]).instance()
	add_child(level)
