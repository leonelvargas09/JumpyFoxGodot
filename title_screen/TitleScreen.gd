extends CanvasLayer
onready var label = $Control/MarginContainer/MessageLabel

func _ready():
	if OS.get_name() in ['Android']:
		label.hide()

func _input(event):
	if event.is_action_pressed("ui_select"):
		get_tree().change_scene(Game.main_scene)
