extends CharacterBody2D

func get_input():
	rotation_direction = Input.get_axis("ui_left", "ui_right") 
	velocity = transform.x * Input.get_axis("ui_down", "ui_up") * speed
	velocity += recoil_velocity
	if Input.is_action_just_pressed("Shoot_2"):
		shoot()
	if Input.is_action_just_pressed("T1"):
		$tutorial.hide()
	if health < max_health:
		$tutorial.hide()
#common code
@export var speed = 500
@export var rotation_speed = 5
@export var bullet : PackedScene
@export var max_health = 100
@export var health = 0
@export var damage = 10
@export var heal_value = 20
var out_of_bounds = Vector2(3000,3000)
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
	$CanvasLayer2.hide()
	$tutorial.show()

func take_hit(bullet):
	hit.emit(bullet)

func _on_hit(bullet):
	health -= damage
	$CPUParticles2D.global_rotation = bullet.global_rotation
	$CPUParticles2D.restart()
	$HitHurt.play()
	print(name, " hit, health: ", health)
	if health < 1:
		position = out_of_bounds
		$CanvasLayer2.show()

func _on_heal_ditect_area_entered(area: Area2D) -> void:
	health += heal_value
	$Healsound.play()
	if health > max_health:
		health=max_health
	print("heal")
	area.queue_free()

#the buttons


func _on_replay_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	
func _on_quit_pressed() -> void:
	get_tree().quit()
