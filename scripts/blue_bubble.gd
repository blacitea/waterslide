extends CharacterBody2D

enum State {
	MOVING_RIGHT,
	MOVING_UP,
	FINISHED
}

@export var horizontal_speed: float = 500.0
@export var vertical_speed: float = 500.0
@export var horizontal_distance: float = 3000.0

var current_state: State = State.MOVING_RIGHT
var initial_position: Vector2
var distance_moved: float = 0.0

func _ready():
	initial_position = position
	velocity = Vector2.ZERO
	distance_moved = 0.0
	add_to_group("projectile")


func _physics_process(delta):
	match current_state:
		State.MOVING_RIGHT:
			_move_right(delta)
		State.MOVING_UP:
			_move_up(delta)
		State.FINISHED:
			queue_free()

func _move_right(delta: float) -> void:
	if distance_moved < horizontal_distance:
		var movement = horizontal_speed * delta
		velocity.x = horizontal_speed
		position.x += movement
		distance_moved += movement
	else:
		current_state = State.MOVING_UP
		velocity.x = 0

func _move_up(delta: float) -> void:
	velocity.y = -vertical_speed
	position.y += velocity.y * delta
	
	if position.y < -1000:
		current_state = State.FINISHED
