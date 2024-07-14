extends Node2D

var characters = []
var active_team = []
var max_team_size = 3
var config_path = "res://configs/character_list.json"
@export var character_scene_path = "res://Scenes/LinePath/character_line_draw.tscn"

var active_character = null
@onready var game_manager = $/root/WhiteRoom/GameManager

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
		
		create_character_node(character_name)
		print("Selected character: ", character_name.name)
		game_manager.update_game_state()
	else: 
		print("Cannot select character: ", character_name)

func set_active_character_by_index(index):
	if index >= 0 and index < active_team.size():
		var character_data = active_team[index]
		for character_node in get_children():
			print(character_node.characterName, character_data.characterName)
			if character_node is Sprite2D and character_node.characterName == character_data.characterName:
				active_character = character_node
				print("Active character: ", active_character.characterName)
				#$ActivePlayerLabel.text = str(active_character.characterName)
				return
	print("Invalid character index: ", index)

func get_active_character():
	return active_character

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
	
	active_team.append(character_instance)
	add_child(character_instance)
	
func get_active_team():
	return active_team
	
func pause_all_characters():
	for character in active_team:
		character.pause()
		
func unpause_all_characters():
	for character in active_team:
		character.unpause()

func notify_active_character_to_continue():
	if active_character:
		active_character.following = true	

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
			elif event.keycode == KEY_Q:
				set_active_character_by_index(0)
			elif event.keycode == KEY_W:
				set_active_character_by_index(1)
			elif event.keycode == KEY_E:
				set_active_character_by_index(2)
			elif event.keycode == KEY_ENTER:
				game_manager.end_confrontation()

