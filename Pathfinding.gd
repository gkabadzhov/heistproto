extends Node2D

const GRID_SIZE = Vector2(5,5)
const TILE_SIZE = 16

var grid = []

#Directions for moving through the grid (diagonales included)
var directions = [
	Vector2(1,0), Vector2(-1,0),
	Vector2(0,1), Vector2(0,-1), 
	Vector2(1,1), Vector2(-1,-1), 
	Vector2(1,-1), Vector2(-1,1), 
]

# Called when the node enters the scene tree for the first time.
func _ready():
	grid = [
		[1,1,1,1,1],
		[1,0,0,0,1],
		[1,1,1,0,1],
		[1,0,0,0,1],
		[1,1,1,1,1],
	]
	
	var start = Vector2(0,0)
	var goal = Vector2(4,4)
	
	var path = find_path(start, goal)
	print("Path: ", path)
	
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
			return reconstruct_path(came_from, current)
			
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
	
	return [] #return empty if no path found
	
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
	if nodePosition.x >= 0 and nodePosition.x < GRID_SIZE.x and nodePosition.y >= 0 and nodePosition.y < GRID_SIZE.y:
		return grid[int(nodePosition.x)][int(nodePosition.y)] == 1
	return false
	
func reconstruct_path(came_from, current):
	var total_path = [current]
	while current in came_from:
		current = came_from[current]
		total_path.insert(0,current)
	return total_path
	






