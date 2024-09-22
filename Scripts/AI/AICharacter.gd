extends CharacterBody2D

class_name AICharacter

var starting_point : Vector2
@export var current_target : Node2D = null
var is_moving = false
var is_active = false
var speed = 100

signal completed_action

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	call_deferred("setup_navAgent")
	navigation_agent.connect("velocity_computed", Callable( self, "on_navigation_agent_2d_velocity_computed"))
	
	starting_point = self.global_position

func setup_navAgent():
	await get_tree().physics_frame
	if current_target:
		navigation_agent.target_position = current_target.global_position
	
func move_to_interaction_point(interaction_point: Node2D):
	current_target = interaction_point
	navigation_agent.target_position = current_target.global_position
	is_moving = true
	is_active = true

	
#	print("my name is: ", self.name, 
#			"with position: ", self.global_position,
#			"/ next path pos is: ", navigation_agent.get_next_path_position(),
#			"/ in func move_to_interaction_point() ", 
#			"/ target position is: ",navigation_agent.target_position )
		
func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	if is_moving:
#		print("my name is: ", self.name, 
#					"with position: ", self.global_position,
#					"/ in func _on_navigation_agent_2d_velocity_computed() ",
#					"/ velocity is: ", safe_velocity, 
#					"/ target position is: ",navigation_agent.target_position )
		velocity = global_position.direction_to(navigation_agent.target_position) * speed
		move_and_slide()
	
	
	if is_active:
		if global_position.distance_to(navigation_agent.target_position) < 5.0:
			interaction_complete()
	else:
		if global_position.distance_to(navigation_agent.target_position) < 5.0:
			reset()


	
func interaction_complete():
	is_moving = false
	print("Purchase at", current_target.name)
	await get_tree().create_timer(3).timeout
	print("Purchase completed")
	is_active = false
	return_to_starting_point()
	
func return_to_starting_point():
	navigation_agent.target_position = starting_point
	is_moving = true

func reset():
	is_moving = false
	current_target = null
	completed_action.emit()

func _on_navigation_agent_2d_target_reached():
	#interaction_complete()
	pass
