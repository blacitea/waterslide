extends CharacterBody2D

@onready var sprite = $Sprite2D

func _ready():
	collision_layer = 1
	collision_mask = 1

func _on_area_2d_body_entered(body):
	if body.is_in_group("projectile"):
		print_debug("Bubble hit me")
		sprite.texture = load("res://sprites/traffic cop bubbled.png")
