extends Area2D

var speed = 750
var shooter: Node

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_area_entered(area: Area2D) -> void:
	var target = area.get_parent()
	if target == shooter:
		return
	if target.has_method("take_hit"):
		target.take_hit(self)
	queue_free()
