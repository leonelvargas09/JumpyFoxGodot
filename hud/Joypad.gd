extends Node2D

onready var right_pad = $RightPad

func _ready():
	var screen_size = get_viewport_rect().size
	right_pad.position = Vector2(screen_size.x,0.0)
	
