extends CharacterBody2D

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
	velocity = Vector2.ZERO
	distance_moved = 0.0
	add_to_group("trapped")
	
func _physics_process(delta):
	match current_state:
		State.MOVING_UP:
			_move_up(delta)
		State.FINISHED:
			queue_free()
			
func _move_up(delta: float) -> void:
	velocity.y = -vertical_speed
	position.y += velocity.y * delta
	
	if position.y < -1000:
		current_state = State.FINISHED
		
func _on_area_2d_body_entered(body):
	print("Collision detected with:", body.get_groups())
	if body.is_in_group("maincharacter"):
		call_deferred("_handle_hit")
		
func _handle_hit():
	print("I am called cause I hit the mc")
	enemy_pop.play()
	#var hit_enemy = popped_enemy_scene.instantiate()
	
	 
	##get_node("CollisionShape2D").disabled = true   
	##$CollisionShape2D.z_index = -10;
	##$Sprite2D.z_index = -10;
	
	#hit_enemy.global_position = global_position + Vector2(400, 0)
	#var parent = get_parent()
	#var my_index = get_index()
	#parent.add_child(hit_enemy)
	#parent.move_child(hit_enemy, my_index)
	await enemy_pop.finished
	queue_free()
	
