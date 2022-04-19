extends Sprite

var Easings = preload("Easing.gd")
var MH = preload("MathHelper.gd")

export var playerIdx = 1

export var JumpMultiplier = 1;

export var tex_standing : Texture
export var tex_standing_punch : Texture
export var tex_standing_kick : Texture
export var tex_jump : Texture
export var tex_jump_punch : Texture
export var tex_jump_kick : Texture
export var tex_crouch : Texture
export var tex_crouch_punch : Texture
export var tex_crouch_kick : Texture

var health = 1.0;
export var health_bar : NodePath;
var health_bar_mat : Material;

export var invincibility_cooldown : float;
var invincibility_cooldown_timer = 0;

var col_hitbox
var col_standing_punch
var col_standing_kick
var col_jump_punch
var col_jump_kick
var col_crouch_hitbox
var col_crouch_punch
var col_crouch_kick

var inp_cont_num
var inp_horz_ax
var inp_vert_ax

var inp_left_key
var inp_right_key
var inp_up_key
var inp_down_key

var inp_punch1_key
var inp_punch2_key
var inp_kick1_key
var inp_kick2_key

var inp_up_btn

var inp_punch1_btn
var inp_punch2_btn
var inp_kick1_btn
var inp_kick2_btn

var xVel = 0;
var yVel = 0;
var inAir = false;

var crouching = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar_mat = get_node(health_bar).material;

	col_hitbox         = get_node(@"Hitbox")
	col_standing_punch = get_node(@"Stand_Punch")
	col_standing_kick  = get_node(@"Stand_Kick")
	col_jump_punch     = get_node(@"Jump_Punch")
	col_jump_kick      = get_node(@"Jump_Kick")
	col_crouch_hitbox  = get_node(@"Crouch_Hitbox")
	col_crouch_punch   = get_node(@"Crouch_Punch")
	col_crouch_kick    = get_node(@"Crouch_Kick")

	# col_standing_punch.set_deferred("monitorable", false);
	# col_standing_kick.set_deferred("monitorable", false);
	# col_jump_punch.set_deferred("monitorable", false);
	# col_jump_kick.set_deferred("monitorable", false);

	inp_up_btn = 2

	inp_punch1_btn = 4
	inp_punch2_btn = 6
	inp_kick1_btn = 5
	inp_kick2_btn = 7
	if playerIdx == 1:
		inp_cont_num = 0
		inp_horz_ax = 0
		inp_vert_ax = 1
		
		inp_left_key = KEY_A
		inp_right_key = KEY_D
		inp_up_key = KEY_W
		inp_down_key = KEY_S
		
		inp_punch1_key = KEY_R
		inp_punch2_key = KEY_T
		inp_kick1_key = KEY_F
		inp_kick2_key = KEY_G
		
	elif playerIdx == 2:
		inp_cont_num = 1
		inp_horz_ax = 0
		inp_vert_ax = 1
		
		inp_left_key = KEY_LEFT
		inp_right_key = KEY_RIGHT
		inp_up_key = KEY_UP
		inp_down_key = KEY_DOWN
		
		inp_punch1_key = KEY_I
		inp_punch2_key = KEY_O
		inp_kick1_key = KEY_K
		inp_kick2_key = KEY_L
		
	pass # Replace with function body.

var punching = false;
var kicking = false;
var punch_cooldown = 0.0;
var kick_cooldown = 0.0;
var can_attack = true;
var time_after_punch = 0.05;
var time_after_kick = 0.05;

var cur_attack_strength;

enum attack_type {PUNCH, KICK}
enum attack_str {SMALL = 1, LARGE = 2}

func attack(type : int, strength : int):
	if(!kicking && !punching):
		if(type == attack_type.PUNCH && can_attack):
			punching = true;
			punch_cooldown = float(strength) / 8
			cur_attack_strength = strength;
		elif(type == attack_type.KICK && can_attack):
			kicking = true;
			kick_cooldown = float(strength) / 8
			cur_attack_strength = strength;

func attackUpdate(delta):
	punch_cooldown = max(-time_after_punch, punch_cooldown - delta)
	kick_cooldown  = max(-time_after_kick, kick_cooldown - delta)
	
	if(punch_cooldown <= 0):
		punching = false;
	if(kick_cooldown <= 0):
		kicking = false;
	
	if(punch_cooldown <= -time_after_punch and kick_cooldown <= -time_after_kick):
		can_attack = true;
	else:
		can_attack = false;

var x = 0
var k_punch_1 = false;
var k_kick_1 = false;
var k_punch_2 = false;
var k_kick_2 = false;
var k_jump = false;
var k_crouch = false;

func processInput(delta):
	x = Input.get_joy_axis(inp_cont_num, inp_horz_ax)
	if(x < 0.1 and x > -0.1):
		x = 0;

	if(x >= 0):
		x = Easings.easeInOutQuad(x)
	else:
		x = -Easings.easeInOutQuad(abs(x))
	
	var x_Left = 1 if Input.is_key_pressed(inp_left_key) else 0
	var x_Right = 1 if Input.is_key_pressed(inp_right_key) else 0
	x += x_Right - x_Left;
	x = min(max(-1, x), 1)
	
	k_punch_1 = Input.is_joy_button_pressed(inp_cont_num, inp_punch1_btn) or Input.is_key_pressed(inp_punch1_key)
	k_kick_1  = Input.is_joy_button_pressed(inp_cont_num, inp_kick1_btn)  or Input.is_key_pressed(inp_kick1_key)
	k_punch_2 = Input.is_joy_button_pressed(inp_cont_num, inp_punch2_btn) or Input.is_key_pressed(inp_punch2_key)
	k_kick_2  = Input.is_joy_button_pressed(inp_cont_num, inp_kick2_btn)  or Input.is_key_pressed(inp_kick2_key)
	k_jump    = Input.is_joy_button_pressed(inp_cont_num, inp_up_btn)     or Input.is_key_pressed(inp_up_key)
	k_crouch  = Input.get_joy_axis(inp_cont_num, inp_vert_ax) > 0.8       or Input.is_key_pressed(inp_down_key)

func doCollision():
	var hitbox
	if(!crouching):
		hitbox = col_hitbox
	else:
		hitbox = col_crouch_hitbox
	var colliders = hitbox.get_overlapping_areas();
	for col in colliders:
		if (col.name == "Hitbox" ||
			col.name == "Crouch_Hitbox"):
			continue;
		if (col == col_standing_punch ||
			col == col_standing_kick  ||
			col == col_jump_punch     ||
			col == col_jump_kick      ||
			col == col_crouch_punch   ||
			col == col_crouch_kick):
			continue;

		var colAtk;
		var colMov;

		if(col.name == "Stand_Punch"):
			colAtk = attack_type.PUNCH;
			colMov = movement_type.GROUND;
		if(col.name == "Stand_Kick"):
			colAtk = attack_type.KICK;
			colMov = movement_type.GROUND;
		if(col.name == "Jump_Punch"):
			colAtk = attack_type.PUNCH;
			colMov = movement_type.AIR;
		if(col.name == "Jump_Kick"):
			colAtk = attack_type.KICK;
			colMov = movement_type.AIR;
		if(col.name == "Crouch_Punch"):
			colAtk = attack_type.PUNCH;
			colMov = movement_type.CROUCH;
		if(col.name == "Crouch_Kick"):
			colAtk = attack_type.KICK;
			colMov = movement_type.CROUCH;

		if(!col.get_parent().isAttacking(colAtk, colMov)):
			continue;
		if(invincibility_cooldown_timer > 0):
			continue;

		health -= col.get_parent().getAttackStrength() / 10.0;
		invincibility_cooldown_timer = invincibility_cooldown;

		var dirFromAttack = col.get_parent().position.direction_to(position);
		
		yVel = -200 + (-50 * abs(dirFromAttack.y));
		xVel = dirFromAttack.x * 500;


enum movement_type {GROUND, AIR, CROUCH}

func isAttacking(atk : int, mov : int):
	if(mov == movement_type.CROUCH && !inAir && crouching):
		if(atk == attack_type.PUNCH && punching):
			return true;
		elif(atk == attack_type.KICK && kicking):
			return true;
	elif(mov == movement_type.GROUND && !inAir && !crouching):
		if(atk == attack_type.PUNCH && punching):
			return true;
		elif(atk == attack_type.KICK && kicking):
			return true;
	elif(mov == movement_type.AIR && inAir):
		if(atk == attack_type.PUNCH && punching):
			return true;
		elif(atk == attack_type.KICK && kicking):
			return true;
	return false;

func getAttackStrength():
	return cur_attack_strength;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	processInput(delta)

	invincibility_cooldown_timer -= delta;
	invincibility_cooldown_timer = max(0, invincibility_cooldown_timer);
	doCollision();

	health_bar_mat.set_shader_param("health", health);
	
	# Using the flip parameters doesn't flip the hitboxes
	if(!inAir):
		if(x < -0.01):
			# flip_h = true;
			scale.x = -5
		elif (x > 0.01):
			# flip_h = false;
			scale.x = 5
	
	if(inAir):
		x *= 0.01;
		xVel *= 0.995;
	else:
		xVel *= 0.7;
	
	if(not crouching):
		xVel += x;
	
	xVel = min(max(-1, xVel), 1)
	
	position.x += xVel * delta * 360

	position.x = min(max(-580, position.x), 580)
	
	attackUpdate(delta)
	
	if(k_punch_1):
		attack(attack_type.PUNCH, attack_str.SMALL)
	if(k_punch_2):
		attack(attack_type.PUNCH, attack_str.LARGE)
	if(k_kick_1):
		attack(attack_type.KICK, attack_str.SMALL)
	if(k_kick_2):
		attack(attack_type.KICK, attack_str.LARGE)
	
	if(crouching):
		if(punching):
			set_texture(tex_crouch_punch);
		elif(kicking):
			set_texture(tex_crouch_kick);
		else:
			set_texture(tex_crouch);
	elif(!inAir):
		if(punching):
			set_texture(tex_standing_punch)
		elif(kicking):
			set_texture(tex_standing_kick)
		else:
			set_texture(tex_standing)
	elif(inAir):
		if(punching):
			set_texture(tex_jump_punch);
		elif(kicking):
			set_texture(tex_jump_kick);
		else:
			set_texture(tex_jump);
		
	
	if(position.y >= 80):
		inAir = false;
	else:
		inAir = true;
		
	if(k_jump):
		if(!inAir and not crouching):
			yVel = -500;
			xVel *= 1.1;
		yVel += 500 * delta;
	else:
		yVel += 900 * delta;
	
	if(k_crouch and not inAir):
		crouching = true;
	else:
		crouching = false;
		
	position.y += yVel * delta;
	
	if(position.y > 90):
		position.y = 90;
		yVel = 0;
	pass
