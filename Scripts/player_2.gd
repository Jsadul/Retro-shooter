extends CharacterBody2D

@export var speed = 500
@export var rotation_speed = 5
@export var bullet : PackedScene

var rotation_direction = 0
var recoil_velocity = Vector2.ZERO

func get_input():
	rotation_direction = Input.get_axis("ui_left", "ui_right") 
	velocity = transform.x * Input.get_axis("ui_down", "ui_up") * speed
	velocity += recoil_velocity
	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(delta):
	get_input()
	rotation += rotation_direction * rotation_speed * delta 
	move_and_slide()
	
	recoil_velocity = recoil_velocity.lerp(Vector2.ZERO, delta * 5)  # decay speed, tune the 5

func shoot():
	var b = bullet.instantiate()
	owner.add_child(b)
	b.transform = $Muzzle.global_transform
	
	recoil_velocity -= transform.x * 2000
