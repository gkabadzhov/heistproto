extends CharacterBody2D

@export var target: Node2D = null

var speed = 50
var acceleration = 5

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	call_deferred("setup_navAgent")
	
	
func setup_navAgent():
	await get_tree().physics_frame
	if target:
		navigation_agent.target_position = target.global_position

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return
		
	var current_agent_position = global_position
	var next_path_position = navigation_agent.get_next_path_position()
	velocity = current_agent_position.direction_to(next_path_position) * speed
	
	print(velocity)
	move_and_slide()
