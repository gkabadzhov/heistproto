extends Control

@export var panel1_image: Texture
@export var panel2_image: Texture
@export var panel3_image: Texture

@onready var panel1: Panel = $Panel1
@onready var panel2: Panel = $Panel2
@onready var panel3: Panel = $Panel3
@onready var display_timer: Timer = $Timer

signal button_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_all_panels()
	display_timer.wait_time = 1.0
	display_timer.connect("timeout", Callable(self, "_on_DisplayTimer_timeout"))
	$Panel3/Option1.connect("pressed", Callable(self, "_on_Button_Pressed"))
	$Panel3/Option2.connect("pressed", Callable(self, "_on_Button_Pressed"))
	$Panel3/Option3.connect("pressed", Callable(self, "_on_Button_Pressed"))

func show_overlay():
	visible = true
	panel1.visible = false
	panel2.visible = false
	panel3.visible = false
	display_timer.start()
	
func hide_overlay():
	visible = false
	
func hide_all_panels():
	panel1.visible = false
	panel2.visible = false
	panel3.visible = false
	
func _on_DisplayTimer_timeout():
	if not panel1.visible:
		panel1.visible = true
		panel1.get_node("TextureRect").texture = panel1_image
	elif not panel2.visible:
		panel2.visible = true
		panel2.get_node("TextureRect").texture = panel2_image
	elif not panel3.visible:
		panel3.visible = true
		panel3.get_node("TextureRect").texture = panel3_image
		display_timer.stop()
	else:
		display_timer.stop()
		
func _on_Button_Pressed():
	print("Button pressed in UIOverlay")
	emit_signal("button_pressed")
