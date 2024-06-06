extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func show_overlay():
	visible = true

func hide_overlay():
	visible = false
