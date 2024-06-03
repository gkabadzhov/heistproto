extends Node2D

@export var line_width: float = 2.0
@export var line_color: Color = Color(1, 0, 0)
var is_drawing = false
var lines = []
var all_points = []
var wait_points = []

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_drawing(event.position)
			else:
				stop_drawing()
	
	if event is InputEventMouseMotion and is_drawing:
		continue_drawing(event.position)

	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			start_character_movement()
		

func start_drawing(current_position):
	is_drawing = true
	var new_line = Line2D.new()
	add_child(new_line)
	new_line.width = line_width
	new_line.default_color = line_color
	new_line.add_point(to_local(current_position))
	lines.append(new_line)
	all_points.append(to_local(current_position))
	
func stop_drawing():
	is_drawing = false
	if not all_points.is_empty():
		wait_points.append(all_points[-1])
	
func continue_drawing(current_position):
	if is_drawing:
		var local_position = to_local(current_position)
		lines[-1].add_point(local_position)
		all_points.append(local_position)
		
func start_character_movement():
	if all_points.size() > 0:
		#print("Starting character movement with points: ", all_points)
		$Character.path = all_points.duplicate()
		$Character.wait_points = wait_points.duplicate()
		$Character.path_index = 0
		$Character.start_following()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
