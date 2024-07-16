extends RichTextLabel

@onready var parent_node: CharacterPanel = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	print("My parent is " + (parent_node.character_name if parent_node else ''));
	text = parent_node.character_name.to_pascal_case()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
