extends Node2D

class_name CivilManager

@export var civil_interaction_points: Array[Node2D] = []
@export var civil_starting_points: Array[Node2D] = []
var civil_list: Array[AICharacter] = []

func _ready():
	for child in get_children():
		pass
		if child is AICharacter:
			civil_list.append(child)

func handle_civil_routines(): 
	var available_staff_points = get_parent().staff_manager.get_available_interaction_points()
	
	if available_staff_points.size() > 0:
		var target_point = available_staff_points[0]
		var random_civil = civil_list[randi() % civil_list.size()]
		
		random_civil.move_to_interaction_point(target_point)
