extends CharacterBody2D

class_name AICharacter

var starting_point : Vector2
var current_target : Node2D = null
var is_moving = false
var speed = 10

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	starting_point = self.global_position
	
func move_to_interaction_point(interaction_point: Node2D):
	current_target = interaction_point
	navigation_agent.target_position = current_target.global_position
	is_moving = true
	
func _physics_process(delta):
	if is_moving and navigation_agent.get_next_path_position() != null:
		var next_position = navigation_agent.get_next_path_position()
		move_and_slide()

	if self.global_position.distance_to(current_target.global_position) < 3.0:
		interaction_complete()
		
func interaction_complete():
	is_moving = false
	print("Purchase at", current_target.name)
	await get_tree().create_timer(3).timeout
	print("Purchase completed")
	return_to_starting_point()
	
func return_to_starting_point():
	navigation_agent.target_position = starting_point
	is_moving = true
