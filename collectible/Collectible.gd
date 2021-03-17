extends Area2D

signal pickup

var textures = {
	'cherry':'res://assets/sprites/cherry.png',
	'gem':'res://assets/sprites/gem.png'
}

var _type


func setup(type, pos):
	$Sprite.texture = load(textures[type])
	position = pos
	_type = type


func _on_Collectible_body_entered(body):
	if _type == 'cherry':
		body.pickup_cherry()
	emit_signal("pickup")
	queue_free()
