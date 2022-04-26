extends Control
var MH = preload("MathHelper.gd")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var fullscreen_checkbox : NodePath;
export var sfx_bar : NodePath;

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(fullscreen_checkbox).pressed = OS.window_fullscreen;
	get_node(sfx_bar).value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"));
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureButton_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	pass # Replace with function body.


func _on_CheckBox_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
	pass # Replace with function body.


func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value);
	pass # Replace with function body.
