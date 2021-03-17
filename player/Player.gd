extends KinematicBody2D

signal life_changed
signal dead
signal cherry_changed


export (PackedScene) var cherry_scene
export(int) var run_speed
export(int) var jump_speed
export(int) var gravity
export(int) var life

enum {IDLE, RUN, HURT, JUMP, DEAD}


var state
var anim
var new_anim
var velocity = Vector2()
var max_jump = 2
var jump_count = 0
var facing = 1
var current_facing = facing
var cherries = 0

func start(pos):
	position = pos
	show()
	change_state(IDLE)
	emit_signal("life_changed", life)


func _ready():
	change_state(IDLE)


func change_state(new_state):
	state = new_state

	match state:
		IDLE:
			new_anim = 'idle'
		RUN:
			new_anim = 'run'
		HURT:
			new_anim = 'hurt'
			$HurtAudio.play()
			hurt()
		JUMP:
			new_anim = 'jump_up'
			jump_count = 1
		DEAD:
			dead()


func _physics_process(delta):
	velocity.y += gravity * delta
	get_input()
	flip_x()
	
	if new_anim != anim:
		anim = new_anim
		$AnimationPlayer.play(anim)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	hit_enemy()


func get_input():
	if state == HURT or state == DEAD:
		return
	
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var jump = Input.is_action_just_pressed("jump")
	var shoot = Input.is_action_just_pressed("shoot")
	
	if shoot:
		if cherries > 0:
			shoot_cherry()
	
	velocity.x = 0
	
	if right:
		velocity.x += run_speed
		facing = 1
	
	if left:
		velocity.x -= run_speed
		facing = -1
		
	if jump and state == JUMP and jump_count < max_jump:
		new_anim = 'jump_up'
		velocity.y = jump_speed
		jump_count += 1
	
	if jump and is_on_floor():
		change_state(JUMP)
		velocity.y = jump_speed
	
	if state == IDLE and velocity.x != 0:
		change_state(RUN)
	
	if state == RUN and velocity.x == 0:
		change_state(IDLE)
	
	if state in [IDLE, RUN] and !is_on_floor():
		change_state(JUMP)
	
	if state == JUMP and is_on_floor():
		change_state(IDLE)
		$Dust.emitting = true
	
	if state == JUMP and velocity.y > 0:
		new_anim = 'jump_down'


func hit():
	if state != HURT:
		change_state(HURT)


func hurt():
	velocity.y = -200
	velocity.x = -100 * sign(velocity.x)
	life -= 1
	emit_signal('life_changed', life)
	yield(get_tree().create_timer(0.5), 'timeout')
	
	change_state(IDLE)
	
	if life <= 0:
		change_state(DEAD)


func dead():
	emit_signal('dead')
	hide()


func hit_enemy():
	if state == HURT:
		return

	for slide in range(get_slide_count()):
		var collision = get_slide_collision(slide)
		
		if collision.collider.is_in_group('enemies'):
			var player_feet = (position + $CollisionShape2D.shape.extents).y
			
			if player_feet < collision.collider.position.y:
				collision.collider.take_damage()
				velocity.y = -200
			else:
				hit()

func shoot_cherry():
	new_anim = 'shoot'
	var c = cherry_scene.instance()
	c.transform = $EjeCherry.global_transform
	get_parent().add_child(c)
	cherries -= 1
	emit_signal("cherry_changed", cherries)
	yield(get_tree().create_timer(0.5),"timeout")
	change_state(IDLE)


func flip_x():
	if facing !=0:
		if current_facing != facing:
			current_facing = facing
			scale.x *= -1


func pickup_cherry():
	cherries += 1
	emit_signal("cherry_changed", cherries)
	
