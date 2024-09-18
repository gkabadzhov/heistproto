extends CharacterBody2D

class_name AICharacter

var starting_point : Vector2
@export var current_target : Node2D = null
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
	
#	if is_moving:
		var movement_delta = speed * delta
		var next_path_position = navigation_agent.get_next_path_position()
		var new_velocity = global_position.direction_to(next_path_position) * movement_delta
		
		if navigation_agent.avoidance_enabled:
			navigation_agent.set_velocity(new_velocity)
		else:
			_on_navigation_agent_2d_velocity_computed(new_velocity)
			
		print("my name is: ", self.name, ", with distance of: ", global_position.distance_to(navigation_agent.target_position))
		if global_position.distance_to(navigation_agent.target_position) < 5.0:
			interaction_complete()
		
func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()
	
func interaction_complete():
	is_moving = false
	print("Purchase at", current_target.name)
	await get_tree().create_timer(3).timeout
	print("Purchase completed")
	return_to_starting_point()
	
func return_to_starting_point():
	navigation_agent.target_position = starting_point
	is_moving = true
