extends CharacterBody2D

@export var speed = 100.0
var waypoints: Array[Vector2] = []
var current_waypoint_index: int = 0

enum State {
	WALKING,
	WAITING
}

var state: State = State.WALKING

@onready var timer = Timer.new()

func _ready():
	add_child(timer)
	waypoints = [Vector2(100, 200), Vector2(300, 400), Vector2(500, 200)]
	current_waypoint_index = 0
	state = State.WALKING
	set_process(true)
	
func _process(delta: float) -> void:
	match state:
		State.WALKING:
			walk_to_waypoint(delta)
		State.WAITING:
			wait_at_waypoint()	

func walk_to_waypoint():
	if waypoints.size() > 0:
		var target_position = waypoints[current_waypoint_index]
		var direction = (target_position - global_position).normalized()
		velo
