extends Node

var current_level = 0
var num_level = 0

var main_scene = 'res://main/Main.tscn'
var title_scene = 'res://title_screen/TitleScreen.tscn'

var levels = [
	'res://levels/Level01.tscn',
	'res://levels/Level02.tscn'
]

func _ready():
	num_level = len(levels)

func restar_game():
	get_tree().change_scene(title_scene)


func next_level():
	current_level += 1
	
	if current_level < num_level:
		get_tree().reload_current_scene()
