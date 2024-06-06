extends Node2D

enum GameState {RECRUITING, PLANNING, EXECUTION, CONFRONTATION}
var current_state = GameState.RECRUITING

@export var max_team_size: int = 3
@onready var team_manager: Node2D = null
@onready var confrontation_overlay: Control = null

# Called when the node enters the scene tree for the first time.
func _ready():
	team_manager = $TeamManager
	confrontation_overlay = get_node("/root/WhiteRoom/ConfrontationOverlay")
	update_game_state()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func update_game_state():
	if team_manager.get_active_team().size() < max_team_size:
		current_state = GameState.RECRUITING
	else:
		current_state = GameState.PLANNING
	print ("Current State is: ", current_state)

func start_execution():
	current_state = GameState.EXECUTION
	print("Current Game State is: ", current_state)
	
func start_confrontation():
	current_state = GameState.CONFRONTATION
	team_manager.pause_all_characters()
	confrontation_overlay.show_overlay()
	#get_tree().paused = true
	print("Current Game State is: ", current_state)

func end_confrontation():
	current_state = GameState.EXECUTION
	confrontation_overlay.hide_overlay()
	team_manager.unpause_all_characters()
	#get_tree().paused = false
	print("current Game State is: ", current_state)
