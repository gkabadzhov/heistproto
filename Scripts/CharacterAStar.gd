extends Node2D

var speed = 40

var path = []
var current_path_index = 0
var tile_size
var pathfinding

# Called when the node enters the scene tree for the first time.
func _ready():
	pathfinding = get_parent()
	tile_size = pathfinding.TILE_SIZE
	
	#For some bullshit reason i can't bother to fix - we pass the Y first, the X second
	var start = Vector2(0,0)
	var goal = Vector2(2,9)
	
	path = pathfinding.find_path(start, goal)
	current_path_index = 0
	print("Path: ", path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_path_index < path.size():
		var target = (path[current_path_index] + Vector2(0.5,0.5)) * tile_size
		
		var direction = (target - global_position).normalized()
		
		global_position += direction * speed * delta
		
		print("Moving towards:", target, " at index: ", path[current_path_index])
		print("Current position:", position)
		print("Direction:", direction)
		
		if global_position.distance_to(target) < 1:
			global_position = target
			current_path_index += 1
