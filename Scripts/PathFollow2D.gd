extends PathFollow2D

@export var speed: float = 1000.0
@export var wait_time: float = 2.0

var _is_moving: bool = true
var _target_progress: float = 0.0
var _timer: Timer

# Cache the Path2D node and its curve
var path: Path2D
var curve: Curve2D

func _ready():
	path = get_parent() as Path2D
	curve = path.curve

	_timer = Timer.new()
	_timer.wait_time = wait_time
	_timer.one_shot = true
	_timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	add_child(_timer)
	_move_to_next_point()

func _process(delta: float):
	
	if _is_moving:
		var distance_to_move = speed * delta
		var new_progress = _target_progress + distance_to_move / curve.get_baked_length()

		if new_progress >= 1.0:
			new_progress = 1.0
			_is_moving = false

		var current_position = curve.sample_baked(progress * curve.get_baked_length())
		var target_position = curve.sample_baked(new_progress * curve.get_baked_length())

		print("Current Position: ", current_position)
		print("Target Position: ", target_position)


		if current_position.distance_to(target_position) < distance_to_move:
			_is_moving = false
			_timer.start()
		else:
			_target_progress = new_progress
			progress = new_progress

func _on_Timer_timeout():
	_move_to_next_point()

func _move_to_next_point():
	if _is_moving:
		return
	print("Move to next point")
	_target_progress += 1.0 / (curve.get_baked_points().size() - 1)
	if _target_progress >= 1.0:
		_target_progress = 1.0
	_is_moving = true
