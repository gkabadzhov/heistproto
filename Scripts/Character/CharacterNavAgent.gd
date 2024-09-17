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
var current_target_index: int = 0

var is_paused = false

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():		
	call_deferred("setup_navAgent")
	
	
func setup_navAgent():
	await get_tree().physics_frame
	if target:
		navigation_agent.target_position = target.global_position
		
func add_to_path(target_node : Node2D):
	character_path.append(target_node)
	print(character_path)
		
func acquire_target_by_path_index(index):
	var new_target = character_path[index]
	target = new_target
	navigation_agent.target_position = target.global_position

func _physics_process(_delta):
	if is_paused:
		return
	
	if current_state == CharacterState.IDLE:
		pass
	
	if current_state == CharacterState.WALKING:
		var current_agent_position = global_position
		var next_path_position = navigation_agent.get_next_path_position()
		var new_velocity = current_agent_position.direction_to(next_path_position) * speed
		
		if navigation_agent.avoidance_enabled:
			navigation_agent.set_velocity(new_velocity)
		else:
			_on_navigation_agent_2d_velocity_computed(new_velocity)
		
		move_and_slide()
		
		if global_position.distance_to(navigation_agent.target_position) < 3.0:
			reached_target()

func start_walking():
	current_state = CharacterState.WALKING
	current_target_index = 0
	if character_path.size() > 0:
		acquire_target_by_path_index(0)
	else:
		print("Active character", self.name, " doesn't have a path")

func reached_target():
	#current_target_index += 1
	var gameManager = get_tree().root.get_node("Level1/GameManager")
	gameManager.start_confrontation(self)

func continue_to_next_target():
	current_target_index += 1
	if current_target_index < character_path.size():
		acquire_target_by_path_index(current_target_index)
	else:
		current_state = CharacterState.IDLE

	
func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	
func pause():
	is_paused = true
	navigation_agent.set_velocity(Vector2.ZERO)
	
func unpause():
	is_paused = false
	
	if current_target_index < character_path.size():
		current_state = CharacterState.WALKING
		navigation_agent.target_position = character_path[current_target_index].global_position
