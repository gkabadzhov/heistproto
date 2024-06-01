extends Sprite2D

var path = []
var path_index = 0
var speed = 100.0 #pixels per second
var dragging = false
var following = false

func input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and is_inside_tree() and get_rect().has_point(to_local(event.position)):
				dragging = true
			else:
				dragging = false
				
	if event is InputEventMouseMotion and dragging:
		global_position = event.position

func follow_path(delta):
	if path.is_empty() or not following:
		return
		
	var target = path[path_index]
	var direction = (target - position).normalized()
	var distance = speed * delta
	
	if position.distance_to(target) <= distance:
		position = target
		path_index += 1
		if path_index >= path.size():
			path.clear()
			following = false
	else:
		position += direction * distance

func start_following():
	following = true
	print("Character started following the path: ", path)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not dragging and following:
		follow_path(delta)
