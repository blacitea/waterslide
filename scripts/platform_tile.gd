extends Node2D
func _ready() -> void:
		add_to_group("ground")
		
func _on_area_2d_body_entered(body):
	if body.is_in_group("maincharacter"):
		#var timer = get_tree().create_timer(0.25)
		#await timer.timeout
		# Add offset based on sprite height difference
		get_tree().change_scene_to_file("res://scene/win_loss_canvas_layer.tscn")
		queue_free()
