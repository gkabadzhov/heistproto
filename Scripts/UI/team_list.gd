extends Control

class_name TeamList

@onready var team_manager: TeamManager = $"../GameManager/TeamManager"
@onready var char_list: Array
@onready var character_container: HFlowContainer = $"PanelContainer/HFlowContainer"

var char_panel_scene = load("res://Scenes/UI/character_panel.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	print("My parent is " + team_manager.config_path)
	char_list = team_manager.characters
	appendItems()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func appendItems():
	for character in char_list:
		var char_panel: CharacterPanel = char_panel_scene.instantiate()
		char_panel.character_name = character.name
		char_panel.team_manager = team_manager
		character_container.add_child(char_panel)
		character_container.queue_redraw()
