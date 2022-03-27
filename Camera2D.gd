extends Camera2D


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

func easeInOutSine(x):
	return -(cos(PI * x) - 1) / 2;

func easeInOutCubic(x):
	return 4 * x * x * x if x < 0.5 else 1 - pow(-2 * x + 2, 3) / 2
	
func easeOutBounce(x):
	var n1 = 7.5625;
	var d1 = 2.75;

	if (x < 1 / d1):
		return n1 * x * x;
	elif (x < 2 / d1):
		x -= 1.5 / d1
		return n1 * (x) * x + 0.75;
	elif (x < 2.5 / d1):
		x -= 2.25 / d1
		return n1 * (x) * x + 0.9375;
	else:
		x -= 2.625 / d1
		return n1 * (x) * x + 0.984375;

func easeInOutBounce(x):
	return (1 - easeOutBounce(1 - 2 * x)) / 2 if x < 0.5 else (1 + easeOutBounce(2 * x - 1)) / 2;

func easeInOutBack(x):
	var c1 = 1.70158;
	var c2 = c1 * 1.525;

	return (pow(2 * x, 2) * ((c2 + 1) * 2 * x - c2)) / 2 if x < 0.5 else (pow(2 * x - 2, 2) * ((c2 + 1) * (x * 2 - 2) + c2) + 2) / 2;

func easeInOutQuad(x):
	return 2 * x * x if x < 0.5 else 1 - pow(-2 * x + 2, 2) / 2;

func map(toMap, rangeStartLow, rangeStartHigh, rangeMapLow, rangeMapHigh):
	return (toMap-rangeStartLow)/(rangeStartHigh-rangeStartLow) * (rangeMapHigh-rangeMapLow) + rangeMapLow

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_1_pos = player_1.position
	var player_2_pos = player_2.position
	
	var newPos = (player_1_pos + player_2_pos) / 2
	var mappedNewPosX = map(newPos.x, -580, 580, 0, 1)
	var easedNewPosX = map(easeInOutCubic(mappedNewPosX), 0, 1, -580, 580)
	newPos.x = newPos.x * 0.8 + easedNewPosX * 0.2
		
	var distance = player_1.position.distance_to(player_2.position)
	#distance = abs(player_1_pos_x - player_2_pos_x)
	var newZoom = min(max(0.9, distance / 700), 1.5)
	var mappedZoomDist = map(newZoom, 0.9, 1.5, 0, 1)
	var easedZoom = map(easeInOutQuad(mappedZoomDist), 0, 1, 0.9, 1.5)
	
	zoom.x = easedZoom * 0.7 + newZoom * 0.3
	zoom.y = easedZoom * 0.7 + newZoom * 0.3
	
	position = newPos
	
	#print(player_1.position.x)
	pass
