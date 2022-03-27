extends Sprite


export var playerIdx = 1

var tex_standing
var tex_standing_punch
var tex_standing_kick

var inp_cont_num
var inp_horz_ax
var inp_vert_ax

var inp_left_key
var inp_right_key
var inp_up_key
var inp_down_key

var xVel = 0;
var yVel = 0;
var inAir = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	if playerIdx == 1:
		inp_cont_num = 0
		inp_horz_ax = 0
		inp_vert_ax = 1
		inp_left_key = KEY_A
		inp_right_key = KEY_D
		inp_up_key = KEY_W
		inp_down_key = KEY_S
		
		
		tex_standing = preload("res://penguin.png")
		tex_standing_punch = preload("res://penguin_standing_slap.png")
		tex_standing_kick = preload("res://penguin_standing_kick.png")
	elif playerIdx == 2:
		inp_cont_num = 1
		inp_horz_ax = 0
		inp_vert_ax = 1
		inp_left_key = KEY_LEFT
		inp_right_key = KEY_RIGHT
		inp_up_key = KEY_UP
		inp_down_key = KEY_DOWN
		
		tex_standing = preload("res://figure2.png")
		tex_standing_punch = preload("res://penguin_standing_slap.png")
		tex_standing_kick = preload("res://penguin_standing_kick.png")
	pass # Replace with function body.

var x = 0
var k_punch_1 = false;
var k_kick_1 = false;
var k_jump = false;
var k_fall = false;

func processInput(delta):
	x = Input.get_joy_axis(inp_cont_num, inp_horz_ax)
	if(x < 0.1 and x > -0.1):
		x = 0;
	
	var x_Left = 1 if Input.is_key_pressed(inp_left_key) else 0
	var x_Right = 1 if Input.is_key_pressed(inp_right_key) else 0
	x += x_Right - x_Left;
	x = min(max(-1, x), 1)
	
	k_punch_1 = Input.is_joy_button_pressed(inp_cont_num, 1) or Input.is_key_pressed(KEY_U)
	k_kick_1  = Input.is_joy_button_pressed(inp_cont_num, 3) or Input.is_key_pressed(KEY_J)
	
	k_jump = Input.is_joy_button_pressed(inp_cont_num, 2) or Input.is_key_pressed(inp_up_key)
	
	k_fall = Input.get_joy_axis(inp_cont_num, inp_vert_ax) < -0.4 or Input.is_key_pressed(inp_down_key)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	processInput(delta)
	
	if(xVel < -0.1):
		flip_h = true;
	elif (xVel > 0.1):
		flip_h = false;
	
	if(inAir):
		x *= 0.01;
		xVel *= 0.995;
	else:
		xVel *= 0.7;
	
	xVel += x;
	xVel = min(max(-1, xVel), 1)
	
	position.x += xVel * delta * 360
	position.x = min(max(-580, position.x), 580)
	
	if(k_punch_1):
		set_texture(tex_standing_punch)
	elif(k_kick_1):
		set_texture(tex_standing_kick)
	else:
		set_texture(tex_standing)
	
	if(position.y > 85):
		inAir = false;
	else:
		inAir = true;
		
	if(k_jump):
		if(!inAir):
			yVel = -500;
		yVel += 500 * delta;
	else:
		yVel += 900 * delta;
	
	if(k_fall):
		yVel = max(yVel, 200)
		yVel += 800 * delta
	position.y += yVel * delta;
	
	if(position.y > 90):
		position.y = 90;
		yVel = 0;
	pass
