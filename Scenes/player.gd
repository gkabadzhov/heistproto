extends Node2D

@onready var path_follow : PathFollow2D = $Path2D/PathFollow2D
@onready var path2d : Path2D = $Path2D

@export var success_chance = 0.7
@export var speed = 100
@export var wait_time: float = 2.0

var _is_moving: bool = true
var _target_progress: float = 0.0
var _timer: Timer
var path_points : Array = []
var current_target = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	_timer = Timer.new()
	_timer.wait_time = wait_time
	_timer.one_shot = false
	_timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	add_child(_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _is_moving:
		path_follow.progress += speed * delta
		var distance = path_follow.global_transform.origin.distance_to(path2d.to_global(path2d.curve.get_point_position(current_target))) 

		if distance < 5.0:  # Adjust the threshold as needed
			print("in wait");
			_is_moving = false
			_timer.start()	
	
func _on_Timer_timeout():
	# Reset progress ratio and resume moving
	#path_follow.progress_ratio = 0.0
	print("on wait timeout");
	if randf() < success_chance:
		print("Success!")
		#TODO: add success logic
	else:
		print("Failure!")
		#TODO: add failure logic
	current_target = current_target + 1 
	_is_moving = true	
	
func _move_to_next_point():
	if _is_moving:
		return
	if _target_progress >= 1.0:
		_target_progress = 1.0
	_is_moving = true
