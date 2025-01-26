extends CharacterBody2D
var current_state: State = State.MOVING_RIGHT
var initial_position: Vector2
var distance_moved: float = 0.0
enum State {
	MOVING_RIGHT,
	MOVING_UP,
	FINISHED
}

@export var horizontal_speed: float = 100
@onready var enemy_pop = $enemy_pop

func _ready():
	initial_position = position
	velocity = Vector2.ZERO
	distance_moved = 0.0
	add_to_group("popped")
	collision_layer = 1
	collision_mask = 1
	
func _physics_process(delta):
	match current_state:
		State.MOVING_RIGHT:
			_move_right(delta)
		State.FINISHED:
			queue_free()

func _move_right(delta: float) -> void:
	var movement = horizontal_speed * delta
	velocity.x = horizontal_speed
	position.x += movement
	distance_moved += movement
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("bad") or body.is_in_group("trapped"):
		enemy_pop.play()
		# Use call_deferred to queue the free after the sound
		call_deferred("_handle_pop", body)

func _handle_pop(body):
	await enemy_pop.finished
	# Queue both objects for deletion
	if is_instance_valid(body):  # Check if other object still exists
		body.queue_free()
	queue_free()

	
