extends Node2D

enum GameState {RECRUITING, PLANNING, EXECUTION}
var current_state = GameState.RECRUITING

@export var max_team_size: int = 3
@onready var team_manager = $/root/WhiteRoom/TeamManager

# Called when the node enters the scene tree for the first time.
func _ready():

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
