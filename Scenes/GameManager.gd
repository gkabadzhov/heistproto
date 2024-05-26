extends Node

# Assuming you have references to all your NPCs and room areas
@onready var npcs  # Or however you have your NPCs organized
@onready var room_areas # Or however you have your rooms organized

func _ready():
	npcs = get_tree().get_nodes_in_group("NPC")
	room_areas = get_tree().get_nodes_in_group("RoomAreas")
	for npc in npcs:
		for room_area in room_areas:
			room_area.connect("npc_entered", Callable(npc, "_on_room_entered").bind(room_area.name))
			room_area.connect("npc_exited", Callable(npc, "_on_room_exited").bind(room_area.name))

# You may need to dynamically add NPCs or room areas
# Example function to add an NPC and connect signals
func add_npc(npc):
	npcs.append(npc)
	for room_area in room_areas:
		room_area.connect("npc_entered", Callable(npc, "_on_room_entered").bind(room_area.name))
		room_area.connect("npc_exited", Callable(npc, "_on_room_exited").bind(room_area.name))

# Example function to add a room area and connect signals to existing NPCs
func add_room_area(room_area):
	room_areas.append(room_area)
	for npc in npcs:
		room_area.connect("npc_entered", Callable(npc, "_on_room_entered").bind(room_area.name))
		room_area.connect("npc_exited", Callable(npc, "_on_room_exited").bind(room_area.name))
