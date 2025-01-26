extends Node2D

enum State {
	MOVING_RIGHT,
	MOVING_UP,
	FINISHED
}

var current_state: State = State.MOVING_UP
var initial_position: Vector2
var distance_moved: float = 0.0
@export var vertical_speed: float = 50.0
@onready var enemy_pop = $enemy_pop
##@onready var collision_shape = $CollisionShape2D;
##@onready var sprite_shape = $Sprite2D;
var popped_enemy_scene = preload("res://scene/popped_bad.tscn")

func _ready():
	initial_position = position
	distance_moved = 0.0
	add_to_group("trapped")
	var node2D = get_node(".")
	node2D.set_process(true)
	
func _physics_process(delta):
	match current_state:
		State.MOVING_UP:
			_move_up(delta)
		State.FINISHED:
			queue_free()
			
func _move_up(delta: float) -> void:
	
	if position.y < -1000:
		current_state = State.FINISHED
		
#func _on_area_2d_body_entered(body):
	#print("Collision detected with:", body.get_groups())
	#if body.is_in_group("maincharacter"):
		#enemy_pop.play()
		#var node2D = get_node(".")
		#node2D.set_process(true)
		#await enemy_pop.finished
		#queue_free()

func _process(delta):
	position.y -= 50 * delta  
