extends CharacterBody2D

@export var speed = 100.0
@export var room_targets = {}
var current_room = ""
var current_target_position = Vector2.ZERO
var target_room = ""

enum State {
	WALKING,
	WAITING
}

var state: State = State.WALKING

@onready var timer = Timer.new()

func _ready():
	_initialize_room_targets()
	timer.wait_time = 5.0 #Time spent in each room
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
	_move_to_next_room()
	
func _process(delta: float) -> void:
	if current_target_position != Vector2.ZERO:
		var direction = (current_target_position - global_position).normalized()
		global_position += direction * speed * delta
		
		if global_position.distance_to(current_target_position) < 10:
			current_target_position = Vector2.ZERO
			timer.start()

func on_timeout() -> void:
	state = State.WALKING

func _on_room_entered(room_name):
	current_room = room_name
	print("Entered room %s" % room_name)
	
func _on_room_exited(room_name):
	if current_room == room_name:
		current_room = "Outside"
		print("Exited room: %s" % room_name)
	
func _move_to_next_room():
	var room_names = room_targets.keys()
	room_names.erase(current_room)
	
	if room_names.size() > 0:
		target_room = room_names[randi() % room_names.size()]
		var target_position = room_targets[target_room]
		current_target_position = _find_path(global_position, target_position)
		print("Moving to room: %s" % target_room)

func _find_path(from: Vector2, to: Vector2) -> Vector2:
	var navigation_map = get_world_2d().navigation_map
	if navigation_map:
		var path = NavigationServer2D.map_get_path(navigation_map, from, to, false)
		if path.size() > 0:
			return path[-1]
	return to
	
func _initialize_room_targets():
	room_targets = {
		"ClerkArea": get_node("../../ClerkAreaTarget").global_position,
		"ClientArea": get_node("../ClientAreaTarget").global_position,
	}
