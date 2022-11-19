extends KinematicBody2D

onready var graphics = $Graphics
onready var character_mover = $CharacterMover
onready var anim_player = $AnimationPlayer

var dead = false

var facing_right = true
var move_right = true
var grounded = true
var cur_anim = ""

var ready = false 
func _ready():
	character_mover.init(self)
	var err = character_mover.connect("movement_info", self, "adjust_for_movement")
	if err != 0:
		print("ERROR: unable to connect to movement_info: ", err)
	
	ready = true

func _process(_delta):
	if dead: 
		return
	
	var move_vec = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		move_vec += Vector2.LEFT
		move_right = false
		set_walk_anim()
	if Input.is_action_pressed("move_right"):
		move_vec += Vector2.RIGHT
		move_right = true
		set_walk_anim()
	
	if grounded and move_vec == Vector2.ZERO:
		play_anim("idle_loop", true)
		
	character_mover.set_move_vec(move_vec)
	
	if Input.is_action_just_pressed("jump"):
		character_mover.jump()
	
	var mouse_pos = get_global_mouse_position() 
	var screen_space = global_transform.origin
	if facing_right != (mouse_pos.x > screen_space.x):
		facing_right = mouse_pos.x > screen_space.x
		change_direction()

func change_direction():
	if facing_right:
		graphics.scale.x = abs(graphics.scale.x)
	else:
		graphics.scale.x = -abs(graphics.scale.x)

func adjust_for_movement(velocity, _grounded):
	if !_grounded: 
		if velocity.y < 0:
			play_anim("jump_up")
		elif velocity.y > 0:
			play_anim("jump_down")
	
	grounded = _grounded

func set_walk_anim():
	if !grounded: 
		return 
	if facing_right == move_right:
		play_anim("walk_loop", true)
	else:
		play_anim("walk_loop", true, true)

func play_anim(anim_name, repeat = false, backwards = false):
	if anim_name != anim_player.current_animation:
		print(anim_name, " : ", anim_player.current_animation)
	if !repeat and cur_anim == anim_name:
		return
	if backwards:
		pass
		#anim_player.play_backwards(anim_name)
	else:
		pass
		#anim_player.play(anim_name)
	cur_anim = anim_name

func kill():
	dead = true
	freeze()
	#anim_player.play("die")

func freeze():
	character_mover.freeze(true)

func unfreeze():
	character_mover.unfreeze()
