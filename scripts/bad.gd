extends CharacterBody2D

@onready var sprite = $Sprite2D
var hit_enemy_scene = preload("res://scene/trapped_bad.tscn")

func _ready():
	collision_layer = 1
	collision_mask = 1
	add_to_group("bad")

func _on_area_2d_body_entered(body):
	if body.is_in_group("projectile"):
		call_deferred("_handle_hit")
	if body.is_in_group("popped"):
		queue_free()

func _handle_hit():
	var hit_enemy = hit_enemy_scene.instantiate()
	hit_enemy.global_position = global_position + Vector2(400, 0)
	var parent = get_parent()
	var my_index = get_index()
	parent.add_child(hit_enemy)
	parent.move_child(hit_enemy, my_index)
	queue_free()
