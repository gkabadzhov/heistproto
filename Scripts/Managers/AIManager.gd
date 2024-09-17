extends Node2D

@export var disturbance : int = 0

@onready var staff_manager : Node2D =  $StaffManager
@onready var civil_manager : Node2D =  $CivilianManager
@onready var guard_manager : Node2D =  $GuardManager


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if disturbance <= 20:
		print("Low disturbance, routine behaviour")
		civil_manager.handle_civil_routines()
