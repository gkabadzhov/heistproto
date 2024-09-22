extends Node2D

class_name CivilManager

@export var civil_interaction_points: Array[Node2D] = []
@export var civil_starting_points: Array[Node2D] = []
var civil_list: Array[AICharacter] = []

func _ready():
	for child in get_children():
		if child is AICharacter:
			civil_list.append(child)

	self.connect("completed_action", Callable( self, "on_actor_completed_action"))

func handle_civil_routines(): 
	var available_staff_point = get_parent().staff_manager.get_available_interaction_points()
	
	if available_staff_point != null:
		var target_point = available_staff_point
		var random_civil = civil_list[randi() % civil_list.size()]
		
		get_parent().staff_manager.disable_interaction_point(true)
		
		random_civil.move_to_interaction_point(target_point)

func on_actor_completed_action():
	handle_civil_routines()
