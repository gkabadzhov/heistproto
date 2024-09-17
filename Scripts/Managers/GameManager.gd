extends Node2D

class_name GameManager

enum GameState {RECRUITING, PLANNING, EXECUTION, CONFRONTATION}
var current_state = GameState.RECRUITING

@export var max_team_size: int = 3

@onready var go_button: Button = $"../Button"
@onready var team_manager: TeamManager = $TeamManager

# Called when the node enters the scene tree for the first time.
func _ready():
	#ui_overlay = get_node("/root/WhiteRoom/UIOverlay")
	#ui_overlay.connect("button_pressed", Callable(self, "_on_button_pressed"))
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
	team_manager.rush_b()
	print("Current Game State is: ", current_state)

func start_confrontation():
	current_state = GameState.CONFRONTATION
	team_manager.pause_all_characters()
	#ui_overlay.show_overlay()
	#get_tree().paused = true
	print("Current Game State is: ", current_state)

func end_confrontation():
	current_state = GameState.EXECUTION
	#ui_overlay.hide_overlay()
	team_manager.unpause_all_characters()
	#get_tree().paused = false
	print("current Game State is: ", current_state)

func _on_button_pressed():
	print("Button pressed in GameManager")
	update_game_state()
	team_manager.notify_active_character_to_continue()
	#team_manager.notify_active_character_to_continue()
