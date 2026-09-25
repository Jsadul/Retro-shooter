extends Node

@export var heal_scene: PackedScene
@export var map_size = Rect2(0, 0, 1920, 1080)
@export var spawn_interval = 5

func _ready():
	var timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.timeout.connect(spawn_heal)
	add_child(timer)
	timer.start()

func spawn_heal():
	var heal = heal_scene.instantiate()
	heal.position = Vector2(
		randf_range(map_size.position.x, map_size.position.x + map_size.size.x),
		randf_range(map_size.position.y, map_size.position.y + map_size.size.y)
	)
	add_child(heal)
