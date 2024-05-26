extends Area2D

signal npc_entered(npc)

signal npc_exited(npc)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	
func _on_body_entered(body):
	if body.is_in_group("NPC"):
		emit_signal("npc_entered", body)

func _on_body_exited(body):
	if body.is_in_group("NPC"):
		emit_signal("npc_exited", body)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
