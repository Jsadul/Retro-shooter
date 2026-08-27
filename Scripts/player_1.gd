extends CharacterBody2D

@export var speed = 500
@export var rotation_speed = 5

var rotation_direction = 0

func get_input():
	rotation_direction = Input.get_axis("A", "D") 
	velocity = transform.x * Input.get_axis("W", "S") * speed

func _physics_process(delta):
	get_input()
	rotation += rotation_direction * rotation_speed * delta 
	move_and_slide()
