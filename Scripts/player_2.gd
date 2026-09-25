extends CharacterBody2D

func get_input():
	rotation_direction = Input.get_axis("A", "D") 
	velocity = transform.x * Input.get_axis("S", "W") * speed
	velocity += recoil_velocity
	if Input.is_action_just_pressed("shoot"):
		shoot()
#common code
@export var speed = 500
@export var rotation_speed = 5
@export var bullet : PackedScene
@export var max_health = 100
@export var health = 0
@export var damage = 5
var recoil_strength = 1200
var rotation_direction = 0
var recoil_velocity = Vector2.ZERO

func _process(delta: float) -> void:
	$CanvasLayer/Hex_bar.value = health
	$CanvasLayer/Hex_bar/Hex_lable.text = str(health) + "%"
	
func _physics_process(delta):
	get_input()
	rotation += rotation_direction * rotation_speed * delta 
	move_and_slide()
	recoil_velocity = recoil_velocity.lerp(Vector2.ZERO, delta * 5) 
	
func shoot():
	var b = bullet.instantiate()
	owner.add_child(b)
	b.transform = $Muzzle.global_transform
	
	recoil_velocity -= transform.x * recoil_strength
	
signal hit(bullet)

func _ready():
	hit.connect(_on_hit)
	$CanvasLayer/Hex_bar.value = max_health
	health = max_health
	$CanvasLayer/Hex_bar/Hex_lable.text = str(health) + "%"

func take_hit(bullet):
	hit.emit(bullet)

func _on_hit(bullet):
	health -= damage
	$CPUParticles2D.global_rotation = bullet.global_rotation
	$CPUParticles2D.restart()
	print(name, " hit, health: ", health)
	if health < 1:
		queue_free()

func _on_heal_ditect_area_entered(area: Area2D) -> void:
	health += 50
	print("heal")
	area.queue_free()
