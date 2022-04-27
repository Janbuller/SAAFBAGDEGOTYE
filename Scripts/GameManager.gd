extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var player_1 : NodePath;
export var player_2 : NodePath;

var player_1_node;
var player_2_node;

export var canvas_layer : NodePath;

var canvas_layer_node;

var WinScreen = preload("res://Scenes/Win Screen.tscn")

var GameEnded : bool;

# Called when the node enters the scene tree for the first time.
func _ready():
	player_1_node = get_node(player_1)
	player_2_node = get_node(player_2)
	canvas_layer_node = get_node(canvas_layer)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(player_1_node.health <= 0 or player_2_node.health <= 0 and not GameEnded):
		var WinScreenInstance = WinScreen.instance();
		var Winner;
		if(player_1_node.health <= 0):
			Winner = player_2_node
		else:
			Winner = player_1_node
			
		WinScreenInstance.get_node("MarginContainer/MarginContainer/VBoxContainer/Label").text = "PLAYER " + str(Winner.playerIdx) + " WINS"
		canvas_layer_node.add_child(WinScreenInstance);
		GameEnded = true;
		pass
	pass
