extends Node2D

@onready var team_manager = $TeamManager
@onready var game_manager = $GameManager

@export var line_width: float = 2.0
@export var line_color: Color = Color(1, 0, 0)
var is_drawing = false
var lines = []
var all_points = []
var wait_points = []
var active_character = null

# Called when the node enters the scene tree for the first time.
func _ready():
	game_manager.update_game_state()

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
			#start_character_movement()
			move_all_characters()
			game_manager.start_execution()
		

func start_drawing(current_position):
	active_character = team_manager.get_active_character()
	is_drawing = true
	var new_line = Line2D.new()
	add_child(new_line)
	new_line.width = line_width
	new_line.default_color = line_color
	new_line.add_point(to_local(current_position))
	lines.append(new_line)
	active_character.path.append(to_local(current_position))
	
func stop_drawing():
	is_drawing = false
	if not all_points.is_empty():
		active_character.wait_points.append(all_points[-1])
	
func continue_drawing(current_position):
	if is_drawing:
		var local_position = to_local(current_position)
		lines[-1].add_point(local_position)
		active_character.path.append(local_position)
		
func start_character_movement():
	if all_points.size() > 0:
		#print("Starting character movement with points: ", all_points)
		active_character = team_manager.get_active_character()
		
		active_character.path = all_points.duplicate()
		active_character.wait_points = wait_points.duplicate()
		active_character.path_index = 0
		active_character.start_following()

func move_all_characters():
	var characters = team_manager.get_active_team()
	
	for character in characters:
		character.path_index = 0
		character.start_following()
