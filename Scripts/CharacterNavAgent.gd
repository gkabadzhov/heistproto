extends CharacterBody2D

@export var target: Node2D = null

var speed = 50
var acceleration = 5

var characterName = ""
var role = ""
var heart = 0
var brains = 0

var character_path = []

enum CharacterState {IDLE, WALKING}
var current_state = CharacterState.IDLE

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():		
	call_deferred("setup_navAgent")
	
	
func setup_navAgent():
	await get_tree().physics_frame
	if target:
		navigation_agent.target_position = target.global_position
		
func add_to_path(target_node : Node2D):
	character_path.append(target_node)
	
	
func acquire_target_by_path_index(index):
	var new_target = character_path[index]
	target = new_target
	navigation_agent.target_position = target.global_position

func _physics_process(_delta):
	if current_state == CharacterState.IDLE:
		pass
	
	if current_state == CharacterState.WALKING:
		print("target position is:", navigation_agent.target_position)
		var current_agent_position = global_position
		var next_path_position = navigation_agent.get_next_path_position()
		var new_velocity = current_agent_position.direction_to(next_path_position) * speed
		
		if navigation_agent.avoidance_enabled:
			navigation_agent.set_velocity(new_velocity)
		else:
			_on_navigation_agent_2d_velocity_computed(new_velocity)
		
		move_and_slide()

func start_walking():
	current_state = CharacterState.WALKING
	acquire_target_by_path_index(0)



func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity

