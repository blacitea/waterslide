extends CharacterBody2D

const SPEED = 7000.0
const JUMP_FORCE = -800.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_started = false

func _physics_process(delta):
	if not is_on_floor():
		#print_debug("not on floor")
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			#print_debug("on floor and jump")
			velocity.y = JUMP_FORCE
		if not has_started:
			has_started = true
	
	if has_started:
		velocity.x = SPEED * delta
		
	move_and_slide()
