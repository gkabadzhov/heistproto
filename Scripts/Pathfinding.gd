extends Node2D

const TILE_SIZE = 16

const GRID_WIDTH = 10
const GRID_HEIGHT = 10

var path = []

var grid = [
		[0,1,0,0,0,0,0,0,0,0],
		[0,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,0],
		[0,1,1,1,1,1,1,1,1,0],
		[0,1,0,0,0,0,0,0,0,0],
	]

#Directions for moving through the grid (diagonales included)
var directions = [
	Vector2(1,0), Vector2(-1,0),
	Vector2(0,1), Vector2(0,-1) 
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# A* implementation
func find_path(start, goal):
	var open_set = [start]
	var came_from = {}
	var g_score = {}
	var f_score = {}
	
	g_score[start] = 0
	f_score[start] = heurestic(start, goal)
	
	while open_set.size() > 0:
		var current = get_lowest_f_score(open_set, f_score)
		
		if current == goal:
			path = reconstruct_path(came_from, current)
			queue_redraw()
			return path
			
		open_set.erase(current)
		
		for direction in directions:
			var neighbour = current + direction
			if !is_walkable(neighbour):
				continue
				
			var tentative_g_score = g_score[current] + 1 #assuming uniform cost for each tile
			if !g_score.has(neighbour) or tentative_g_score < g_score[neighbour]:
				came_from[neighbour] = current
				g_score[neighbour] = tentative_g_score
				f_score[neighbour] = g_score[neighbour] + heurestic(neighbour, goal)
				if neighbour not in open_set:
					open_set.append(neighbour)
	
	path = [] #return empty if no path found\
	queue_redraw()
	return path
	
	
func heurestic(a,b):
	return abs(a.x - b.x) + abs(a.y - b.y)
	
	
func get_lowest_f_score(open_set, f_score):
	var lowest = open_set[0]
	for node in open_set:
		if f_score[node] < f_score[lowest]:
			lowest = node
	return lowest
	
func is_walkable(nodePosition):
	#TODO: ellaborate logic
	#Currently checks if tile is within grid bounds and not an obstacle
	if nodePosition.x >= 0 and nodePosition.x < GRID_WIDTH and nodePosition.y >= 0 and nodePosition.y < GRID_HEIGHT:
		return grid[int(nodePosition.x)][int(nodePosition.y)] == 1
	return false
	
func reconstruct_path(came_from, current):
	var total_path = [current]
	while current in came_from:
		current = came_from[current]
		total_path.insert(0,current)
	return total_path
	

func _draw():
	
	for y in range(GRID_HEIGHT):
		for x in range(GRID_WIDTH):
			var pos = Vector2(x,y) * TILE_SIZE
			var color = Color(1,1,1) if grid[y][x] == 1 else Color(0, 0, 0)  # White for walkable, Black for non-walkable

			draw_rect(Rect2(pos, Vector2(TILE_SIZE, TILE_SIZE)), color, true)
			draw_rect(Rect2(pos, Vector2(TILE_SIZE, TILE_SIZE)), Color(0,0,0), false)

			var coord_text = str(x, ",", y)

	if path.size() > 0:
		for point in path:
			var pos = point * TILE_SIZE
			draw_circle (pos + Vector2(TILE_SIZE / 2,TILE_SIZE / 2), 5, Color(0,1,0))
