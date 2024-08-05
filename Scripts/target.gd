extends Node2D
var sprite

signal target_clicked(target)

func _ready():
	sprite = $Sprite2D
	$Area2D.connect("input_event", Callable(self,"_on_target_input_event"))
	


func _on_body_entered(body):
	print("collision_entered")
	pass


func _on_target_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("target clicked from target script")
		emit_signal("target_clicked", self)
