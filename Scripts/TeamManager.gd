extends Node2D

var characters = []
var active_team = []
var max_team_size = 3
var config_path = "res://configs/character_list.json"
@export var character_scene_path = "res://Scenes/Character.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_characters_from_config()
	print("Generated characters: ", characters)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func load_characters_from_config():
	var file = FileAccess.open(config_path, FileAccess.READ)
	if file: 
		var data = file.get_as_text()
		
		# Is below supposed to work? Kinda sus. TODO: check later
		var parsed = JSON.parse_string(data)
		characters = parsed
		
		file.close()
	else:
		print("Failed to load character list config")
	

func select_character(character_name):
	if character_name in characters and character_name not in active_team and active_team.size() < max_team_size:
		active_team.append(character_name)
		create_character_node(character_name)
		print("Selected character: ", character_name.name)
	else: 
		print("Cannot select character: ", character_name)
		
		
func create_character_node(character_data):
	var character_scene = load(character_scene_path)
	var character_instance = character_scene.instantiate()
	
	#Assign properties
	character_instance.characterName = character_data["name"] 
	character_instance.role = character_data["role"]
	character_instance.speed = character_data["speed"]
	character_instance.heart = character_data["heart"]
	character_instance.brains = character_data["brains"]
	character_instance.set_texture_from_path(character_data["texture_path"])
	
	add_child(character_instance)
	
func get_active_team():
	return active_team
	
func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_1:
				select_character(characters[0])
			elif event.keycode == KEY_2:
				select_character(characters[1])
			elif event.keycode == KEY_3:
				select_character(characters[2])
			elif event.keycode == KEY_4:
				select_character(characters[3])
			elif event.keycode == KEY_5:
				select_character(characters[4])
			elif event.keycode == KEY_6:
				select_character(characters[5])
			elif event.keycode == KEY_ENTER:
				print("Active Team: ", active_team)
