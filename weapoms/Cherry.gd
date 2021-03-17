extends Area2D

export(int)var speed



func _physics_process(delta):
	position += transform.x * speed * delta



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Cherry_body_entered(body):
	if body.is_in_group('enemies'):
		body.take_damage()
	
	queue_free()
