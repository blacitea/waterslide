extends CharacterBody2D

enum State {
	SHOOTING,
	RISING,
	FINISHED
}

var base_velocity := Vector2.ZERO
var additional_velocity := Vector2.ZERO
var displacement := Vector2.ZERO
var shooting_velocity: Vector2 = Vector2.RIGHT * 1000.0
@export var rising_speed: float = 150.0
@export var horizontal_distance: float = 300.0
@onready var bubble_pop = $bubble_pop

var current_state: State = State.SHOOTING
var initial_position: Vector2
var spawn_position: float = 0.0;

func _ready():
	initial_position = position
	additional_velocity = Vector2.ZERO
	add_to_group("projectile")
	collision_layer = 1
	collision_mask = 1
	transition_to_state(State.SHOOTING)


func transition_to_state(new_state: State) -> void:
	match new_state:
		State.SHOOTING:
			additional_velocity = shooting_velocity
		State.RISING:
			additional_velocity.x = 0
			additional_velocity.y = -rising_speed
			base_velocity *= 0.5
		State.FINISHED:
			queue_free()
	
	current_state = new_state

func _physics_process(delta):
	match current_state:
		State.SHOOTING:
			if displacement.x > horizontal_distance:
				transition_to_state(State.RISING)
		State.RISING:
			if displacement.y < -1000:
				transition_to_state(State.SHOOTING)
		State.FINISHED:
			pass
	
	var dx : Vector2 = (base_velocity + additional_velocity) * delta
	position += dx
	displacement += dx


func _on_area_2d_body_entered(body):
	if body.is_in_group("maincharacter"):
		#var timer = get_tree().create_timer(0.25)
		#await timer.timeout
		# Add offset based on sprite height difference
		bubble_pop.play()
		await bubble_pop.finished
		queue_free()
