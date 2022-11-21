extends KinematicBody2D

signal hurt
signal dead

onready var graphics = $Graphics
onready var character_mover = $CharacterMover
onready var anim_player = $Graphics/DinoBody/AnimationPlayer
onready var effect_player = $EffectPlayer

var death_screen = preload("res://scenes/DeathScreen.tscn")

var dead = false

var facing_right = true
var move_right = true
var grounded = true
var cur_anim = ""
var max_health = 3
var cur_health = 3

var ready = false 
func _ready():
	character_mover.init(self)
	var err = character_mover.connect("movement_info", self, "adjust_for_movement")
	if err != 0:
		print("ERROR: unable to connect to movement_info: ", err)
	
	cur_health = max_health
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
	
#	var mouse_pos = get_global_mouse_position() 
#	var screen_space = global_transform.origin
#	if facing_right != (mouse_pos.x > screen_space.x):
#		facing_right = mouse_pos.x > screen_space.x
#		change_direction()
	if facing_right != move_right:
		facing_right = move_right
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
		anim_player.play_backwards(anim_name)
	else:
		anim_player.play(anim_name)
	cur_anim = anim_name

func hurt(damage):
	if dead:
		return
	cur_health -= damage
	effect_player.play("hurt")
	emit_signal("hurt")
	if cur_health <= 0:
		kill()
	else:
		play_hurt()
	
func kill():
	print("kill")
	dead = true
	freeze()
	emit_signal("dead")
	effect_player.play("dead")
	Globals.save_high_score()
	spawn_death_screen()
	play_dead()
	anim_player.play("die")

func spawn_death_screen():
	var death_screen_inst = death_screen.instance()
	get_tree().get_root().add_child(death_screen_inst)
	

func freeze():
	character_mover.freeze(true)

func unfreeze():
	character_mover.unfreeze()

func play_jump():
	$Jump.play()

func play_hurt():
	$Hurt.play()
	
func play_dead():
	$Dead.play()
