extends Button


@onready var team_manager: TeamManager = $"../GameManager/TeamManager"
@onready var game_manager: GameManager = $"../GameManager"

# Called when the node enters the scene tree for the first time.
func _ready():
	team_manager.selection_changed.connect(toggle_disabled)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func toggle_disabled(arr: Array):
	disabled = !arr or arr.size() < 1

func _pressed():
	game_manager.start_execution()
	release_focus()
