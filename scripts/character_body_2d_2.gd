extends CharacterBody2D

const SPEED = 7000.0
const JUMP_FORCE = -800.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_started = false

@export var projectile_scene: PackedScene
@export var spawn_interval: float = 1.0
@export var projectile_spawn: Node2D
@onready var bubble_spawn = $bubbleSpawn
var spawn_timer: float = 0.0

func _process(delta: float) -> void:
	if has_started:
		spawn_timer += delta
		
		if spawn_timer >= spawn_interval:
			spawn_projectile()
			spawn_timer = 0.0

func spawn_projectile() -> void:
	var projectile = projectile_scene.instantiate()
	projectile.collision_layer = 0  # Disable collisions initially
	get_parent().add_child(projectile)
	projectile.global_position = projectile_spawn.global_position
	projectile.velocity = Vector2.ZERO
	bubble_spawn.play()
	
	# Re-enable collisions after delay
	await get_tree().create_timer(0.1).timeout
	projectile.collision_layer = 1

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_FORCE
		if not has_started:
			has_started = true
	
	if has_started:
		velocity.x = SPEED * delta
	
	move_and_slide()
