extends Node2D
signal score_changed

onready var pickups = $PickupItems

var Collectible_scn = preload("res://collectible/Collectible.tscn")
var score

onready var joypad = $HUD/Joypad

func _ready():
	score = 0
	emit_signal("score_changed", score)
	$Player.start($PlayerStartPostion.position)
	set_camera_limits()
	pickups.hide()
	spawn_items()
	var screen_size = get_viewport_rect().size
	var joypad_position_y = screen_size.y - (screen_size.y / 6)
	joypad.position = Vector2(0.0, joypad_position_y)


func set_camera_limits():
	var map_size = $World.get_used_rect()
	var cell_size = $World.cell_size
	
	var top_limit = (map_size.position.y - 15) * cell_size.y
	var bottom_limit = (map_size.end.y) * cell_size.y
	var left_limit = (map_size.position.x - 5) * cell_size.x
	var right_limit = (map_size.end.x + 5) * cell_size.x
	
	$Player/Camera2D.limit_left = left_limit
	$Player/Camera2D.limit_right = right_limit
	$Player/Camera2D.limit_top = top_limit
	$Player/Camera2D.limit_bottom = bottom_limit
	
	$ParallaxBackground.scroll_limit_end = Vector2(left_limit,bottom_limit)


func spawn_items():
	for cell in pickups.get_used_cells():
		var id = pickups.get_cellv(cell)
		var type = pickups.tile_set.tile_get_name(id)
		
		if type in ['gem', 'cherry']:
			var item = Collectible_scn.instance()
			var pos = pickups.map_to_world(cell)
			item.setup(type, pos + pickups.cell_size / 2)
			add_child(item)
			item.connect("pickup", self, "_on_collectible_pickup")


func _on_collectible_pickup():
	score += 1
	emit_signal("score_changed", score)



func _on_Player_dead():
	yield(get_tree().create_timer(0.5),'timeout')
	Game.restar_game()
