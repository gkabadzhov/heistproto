extends PanelContainer

class_name CharacterPanel

var team_manager: TeamManager

var character_name: String = 'warrior'

var selected: bool = false
var selected_stylebox = preload("res://Themes/selected_style_box.tres")
signal on_selection_change(selected: Array)

var textLabel: RichTextLabel

func _ready():
	print("My name is " + character_name)
	toggle_border(team_manager.is_character_selected(character_name))
	team_manager.selection_changed.connect(handle_select)
	pass

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			team_manager.toggle_character(character_name)

func _process(_delta):
	pass

func handle_select(_arg):
	toggle_border(team_manager.is_character_selected(character_name))

func toggle_border(state: bool):
	if selected == state:
		return
	selected = state
	if state:
		add_theme_stylebox_override("panel", selected_stylebox)
	else:
		remove_theme_stylebox_override("panel")
