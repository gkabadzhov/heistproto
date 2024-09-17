extends Node2D

class_name TeamManager

var characters: Array[Character] = []
var selected_characters: Array[Character] = []
var active_team = []
var max_team_size = 3
var config_path = "res://configs/character_list.json"

@export var character_scene_path = "res://Scenes/Objects/character.tscn"

var active_character = null
@onready var game_manager = $".."
@onready var targets = $"../../Targets"

signal selection_changed(selected: Array[Character])

# Called when the node enters the scene tree for the first time.
func _ready():
	load_characters_from_config()
	print("Generated characters: ", characters)
	
	#TODO: logic should not be in team manager script? 
	#       Need to figure out a better way to get the ref
	var available_targets = targets.get_children()
	for target in available_targets:
		target.connect("target_clicked", Callable(self, "_on_target_clicked"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func parse_entries(data_array: Array) -> Array[Character]:
	var entries: Array[Character] = []
	for data in data_array:
		var entry = Character.new()
		entry.name = data.get("name", "None")
		entry.role = data.get("role", "None")
		entry.brains = data.get("name", 0)
		entry.heart = data.get("heart", 0)
		entry.speed = data.get("speed", 0)
		entry.texture_path = data.get("texture_path", null)
		entries.append(entry)
	return entries

func load_characters_from_config():
	var file = FileAccess.open(config_path, FileAccess.READ)
	if file:
		var json = JSON.new()
		var content: String = file.get_as_text()
		var result = json.parse(content)
		if result != OK:
			print("Failed to load character list config")
			pass
		characters = parse_entries(json.data)
		json = null
		print('Parsed characters! ', characters)
	else:
		print("Failed to load character list config")

	file.close()

#TODO: Characters should probably have an ID and we should use that for operations
func toggle_character(character_name: String):
	var character: Character = null
	for curr_char in characters:
		if curr_char.name == character_name:
			character = curr_char
			break
	if character == null:
		print('Character not found! Aborting')
		return
	if character not in selected_characters:
		if selected_characters.size() >= max_team_size:
			print('Team size reached! Aborting')
			return
		selected_characters.append(character)
	elif character in selected_characters:
		selected_characters.erase(character)
	selection_changed.emit(selected_characters)


func select_character(character: Character):
	if character in characters and character not in active_team and active_team.size() < max_team_size:
		var char_instance = create_character_node(character)
		print("Selected character: ", character.name)
		game_manager.update_game_state()
		selection_changed.emit(active_team)
	else:
		print("Cannot select character: ", character)

func is_character_selected(character_name: String):
	for item in selected_characters:
		if item.name == character_name:
			return true
	return false

func rush_b():
	for character in active_team:
		character.start_walking()

func set_active_character_by_index(index):
	if index >= 0 and index <= active_team.size():
		var character_data = active_team[index]
		for character_node in get_children():
			print(character_node.characterName, character_data.characterName)
			if character_node.characterName == character_data.characterName:
				active_character = character_node
				print("Active character: ", active_character.characterName)
				#$ActivePlayerLabel.text = str(active_character.characterName)
				return
	else: 
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
	#character_instance.set_texture_from_path(character_data["texture_path"])

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



func _on_target_clicked(target):
	print("Target clicked: ", target)
	var active_char = get_active_character()
	print("Active char is: ", active_char)
	print("Active target is: ", target)
	active_char.add_to_path(target)
