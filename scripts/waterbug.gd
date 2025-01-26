extends Node2D

var hit_enemy_scene = preload("res://scene/trapped_waterbug.tscn")

func _ready():
	add_to_group("bad")

func _on_area_2d_body_entered(body):
	if body.is_in_group("projectile"):
		call_deferred("_handle_hit", body)
	if body.is_in_group("maincharacter"):
		call_deferred("_slow_mc", body)
		#queue_free()

func _handle_hit(body):
	print("hit enemy");
	var hit_enemy = hit_enemy_scene.instantiate()
	hit_enemy.global_position = global_position + Vector2(10, -50)
	print(hit_enemy);
	var parent = get_parent()
	var my_index = get_index()
	parent.add_child(hit_enemy)
	parent.move_child(hit_enemy, my_index)
	queue_free()
	
func _slow_mc(body):
	body.velocity.x += 500
	
	
