extends CharacterBody2D

@onready var sprite = $Sprite2D
var hit_enemy_scene = preload("res://scene/trapped_bad.tscn")

func _ready():
	collision_layer = 1
	collision_mask = 1

func _on_area_2d_body_entered(body):
	if body.is_in_group("projectile"):
		var hit_enemy = hit_enemy_scene.instantiate()
		# Add offset based on sprite height difference
		hit_enemy.global_position = global_position + Vector2(0, 16)  # Adjust 16 to match your sprites		get_parent().add_child(hit_enemy)
		var parent = get_parent()
		var my_index = get_index()
		parent.add_child(hit_enemy)
		parent.move_child(hit_enemy, my_index)
		queue_free()
