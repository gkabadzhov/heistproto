extends Node2D

class_name CivilManager

@export var civil_interaction_points: Array[Node2D] = []
@export var civil_starting_points: Array[Node2D] = []
var civil_list: Array[AICharacter] = []
var existing_active_civil = false

func _ready():
	for child in get_children():
		if child is AICharacter:
			civil_list.append(child)
			child.connect("completed_action", Callable( self, "on_actor_completed_action"))

func handle_civil_routines():
	if existing_active_civil:
		return 
		
	var available_staff_point = get_parent().staff_manager.get_available_interaction_points()
	
	if available_staff_point != null:
		var target_point = available_staff_point
		var random_civil_index = randi() % civil_list.size()
		
		for civilian in civil_list:
			if civilian == civil_list[random_civil_index]:
				get_parent().staff_manager.disable_interaction_point(true)
				civilian.move_to_interaction_point(target_point)
				existing_active_civil = false

func on_actor_completed_action():
	handle_civil_routines()
