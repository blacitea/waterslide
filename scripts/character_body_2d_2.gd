extends CharacterBody2D

const SPEED = 300.0
const JUMP_FORCE = -600.0
const FALL_THROUGH_SPEED = 200.0
const MINIMUM_SPEED = 300;

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_started = true
var is_on_platform = false
var can_fall_through = false
var max_jump_count = 10;
var jump_count = 0;

@export var projectile_scene: PackedScene
@export var spawn_interval: float = 2.0
@export var projectile_spawn: Node2D
@onready var bubble_spawn = $bubbleSpawn
@onready var mc_jump = $characterJump

var spawn_timer: float = 0.0

func _ready() -> void:
		add_to_group("maincharacter")
		##character.floor_snap_length = 10000.0;
		

func _process(delta: float) -> void:
	if has_started:
		spawn_timer += delta
		
		##if spawn_timer >= spawn_interval:
		##	spawn_projectile()
		##	spawn_timer = 0.0

func spawn_projectile() -> void:
	var projectile = projectile_scene.instantiate()
	##projectile.collision_layer = 0  # Disable collisions initially
	get_parent().add_child(projectile)
	projectile.global_position = projectile_spawn.global_position
	projectile.velocity = Vector2.ZERO
	bubble_spawn.play()
	
	var projectile_ref = weakref(projectile)
	
	await get_tree().create_timer(0.1).timeout
	if projectile_ref.get_ref():
		projectile_ref.get_ref().collision_layer = 1


func _physics_process(delta):
	##if has_started:
	##	velocity.x = SPEED * delta
	
	
		
	
		
	
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("shoot_bubble"):
		spawn_projectile();
	
	if Input.is_action_pressed("ui_accept"):
		if is_on_floor() && get_floor_normal().x >= 0:
			velocity.y = JUMP_FORCE
			mc_jump.play()
			set_floor_snap_length(100);
			await mc_jump.finished
			
			
			
		if not has_started:
			has_started = true
			
	if Input.is_action_pressed("ui_right"):
		if is_on_floor():
			if velocity.x < 2000:
			
				velocity.x += 100;
				##var normal = get_slide_collision(0).get_normal();
				##velocity += normal.rotated(PI/2) * 10 * delta;
				
				

	if Input.is_action_pressed("ui_left"):
			if is_on_floor():
				if velocity.x > 300:
					velocity.x = velocity.x - 100;
				
	if Input.is_action_pressed("ui_down") :
		position.y += 1  # Move slightly down to trigger collision exit
		velocity.y = FALL_THROUGH_SPEED
		
	print("Before R: ", velocity.x);
		
	if velocity.x < MINIMUM_SPEED && velocity.x > 0:
		var ratio = MINIMUM_SPEED/velocity.x;	
		print("Ratio: ", ratio);
		
		velocity *= ratio;
		##print("Velocity: ", velocity);
	
	if is_on_floor():	
		set_floor_snap_length(100);
		apply_floor_snap();

	velocity.x = clamp(velocity.x,300,2000);
	#velocity.y = clamp(velocity.y,300,2000);
		
	move_and_slide()
	_update_platform_status()
	
	##print("VelocityX: ", velocity.x);
	##print("VelocityY: ", velocity.y);
	
	print("Normal:", get_floor_normal());
	##print("Angle:", get_floor_angle());
	
	
	
func _update_platform_status():
	is_on_platform = false
	can_fall_through = false

# Check collisions
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("platform"):
			is_on_platform = true
			can_fall_through = true
		elif collision.get_collider().is_in_group("ground"):
			is_on_platform = true
