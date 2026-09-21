extends CharacterBody2D

@export var speed = 500
@export var rotation_speed = 5
@export var bullet : PackedScene
@export var health = 100
@export var damage = 5
var rotation_direction = 0
var recoil_velocity = Vector2.ZERO
func get_input():
	rotation_direction = Input.get_axis("ui_left", "ui_right") 
	velocity = transform.x * Input.get_axis("ui_down", "ui_up") * speed
	velocity += recoil_velocity
	if Input.is_action_just_pressed("Shoot_2"):
		shoot()

func _physics_process(delta):
	get_input()
	rotation += rotation_direction * rotation_speed * delta 
	move_and_slide()
	
	recoil_velocity = recoil_velocity.lerp(Vector2.ZERO, delta * 5) 

func shoot():
	var b = bullet.instantiate()
	owner.add_child(b)
	b.transform = $Muzzle.global_transform
	
	recoil_velocity -= transform.x * 2000
	
signal hit(bullet)

func _ready():
	hit.connect(_on_hit)
	$CanvasLayer/Hex_bar.value = health
	$CanvasLayer/Hex_bar/Hex_lable.text = str(health) + "%"
func take_hit(bullet):
	hit.emit(bullet)

func _on_hit(bullet):
	health -= damage
	$CPUParticles2D.global_rotation = bullet.global_rotation
	$CPUParticles2D.restart()
	print(name, " hit, health: ", health)
	$CanvasLayer/Hex_bar.value = health
	$CanvasLayer/Hex_bar/Hex_lable.text = str(health) + "%"
	if health < 1:
		queue_free()
