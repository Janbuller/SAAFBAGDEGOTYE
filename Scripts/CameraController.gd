extends Camera2D

var Easings = preload("Easing.gd")
var MH = preload("MathHelper.gd")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) var player_1_path
export(NodePath) var player_2_path

var player_1
var player_2
# Called when the node enters the scene tree for the first time.
func _ready():
	player_1 = get_node(player_1_path)
	player_2 = get_node(player_2_path)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var player_1_pos = player_1.position
	var player_2_pos = player_2.position
	
	var newPos = (player_1_pos + player_2_pos) / 2
	var mappedNewPosX = MH.map(newPos.x, -580, 580, 0, 1)
	var easedNewPosX = MH.map(Easings.easeInOutCubic(mappedNewPosX), 0, 1, -580, 580)
	newPos.x = newPos.x * 0.8 + easedNewPosX * 0.2
		
	var distance = player_1.position.distance_to(player_2.position)
	#distance = abs(player_1_pos_x - player_2_pos_x)
	var newZoom = min(max(0.9, distance / 700), 1.5)
	var mappedZoomDist = MH.map(newZoom, 0.9, 1.5, 0, 1)
	var easedZoom = MH.map(Easings.easeInOutQuad(mappedZoomDist), 0, 1, 0.9, 1.5)
	
	zoom.x = easedZoom * 0.7 + newZoom * 0.3
	zoom.y = easedZoom * 0.7 + newZoom * 0.3
	
	position = newPos
	
	#print(player_1.position.x)
	pass
