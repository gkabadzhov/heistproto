extends CharacterBody2D

@export var target: Node2D = null

var speed = 50
var acceleration = 5

var characterName = ""
var role = ""
var heart = 0
var brains = 0

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():		
	call_deferred("setup_navAgent")
	
	
func setup_navAgent():
	await get_tree().physics_frame
	if target:
		navigation_agent.target_position = target.global_position
		
func acquire_target():
	var food_container = get_tree().get_nodes_in_group("Targets")[0]
	var available_food = food_container.get_children()
	
	if !available_food.is_empty():
		var new_target = available_food[0]
		target = new_target

func _physics_process(delta):
	if is_instance_valid(target):
		pass
		#navigation_agent.target_position = target.global_position
	else:
		acquire_target()
	if navigation_agent.is_navigation_finished():
		return
		
	var current_agent_position = global_position
	var next_path_position = navigation_agent.get_next_path_position()
	var new_velocity = current_agent_position.direction_to(next_path_position) * speed
	
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)
	
	move_and_slide()


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
