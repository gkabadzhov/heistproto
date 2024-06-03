extends Sprite2D

var path = []
var wait_points = []
var path_index = 0
var dragging = false
var following = false
var wait_time = 2.0 #seconds to wait at a section, TODO: make it an action variable

var characterName = ""
var role = ""
var speed = 0 #pixels per second
var heart = 0
var brains = 0

func _ready():
	var timer = Timer.new()
	timer.name = "PathTimer"
	timer.wait_time = wait_time
	timer.one_shot = true
	timer.connect( "timeout", Callable(self, "_on_Timer_timeout"))
	add_child(timer)
	
	print("Character ready: %s, Role: %s, Speed: %d, Heart: %d, Brains: %d" % [characterName, role, speed, heart, brains])

func set_texture_from_path(texture_path: String): 
	var loadTexture = load(texture_path)
	if loadTexture:
		self.texture = loadTexture

#TODO: currently broken function for dragging the character icon. Add "_" at the start of func name to activate
func input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and is_inside_tree() and get_rect().has_point(to_local(event.position)):
				dragging = true
			else:
				dragging = false
				
	if event is InputEventMouseMotion and dragging:
		global_position = event.position

func follow_path(delta):
	if path.is_empty() or not following:
		return
		
	var target = path[path_index]
	var direction = (target - position).normalized()
	var distance = speed * delta
	
	if position.distance_to(target) <= distance:
		position = target
		path_index += 1
		if path_index >= path.size():
			path.clear()
			following = false
		elif position in wait_points:
			following = false
			get_node("PathTimer").start()
			#TODO: implement logic to execute an action 
			#      and react base on success rather than waiting for a timer
			 
	else:
		position += direction * distance

func start_following():
	following = true
	#print("Character started following the path: ", path)
	
func _on_Timer_timeout():
	following = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not dragging and following:
		follow_path(delta)
