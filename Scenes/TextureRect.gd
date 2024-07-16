extends TextureRect

@onready var parent_node: CharacterPanel = $".."
# Called when the node enters the scene tree for the first time.
func _ready():
	var char_name = parent_node.character_name.to_lower()
	print("Loading character image: " + char_name)
	print("Image path " + "res://Assets/Characters/" + char_name + '.jpg')
	var image = Image.load_from_file("res://Assets/Characters/" + char_name + '.jpg')
	texture = ImageTexture.create_from_image(image)
	queue_redraw()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
