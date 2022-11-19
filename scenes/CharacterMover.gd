extends Node2D

var body_to_move: KinematicBody2D = null

export var move_accel = 40
export var max_speed = 250
export var sprint_multiplier = 2.0
var drag = 0.0
export var jump_force = 500
export var gravity = 1000

var pressed_jump = false
var pressed_sprint = false
var move_vec : Vector2
var velocity : Vector2
var snap_vec : Vector2

export (int, 0, 200) var inertia = 100

signal movement_info

var frozen = false
var apply_forces = true

func _ready():
	drag = float(move_accel) / max_speed
	
func init(_body_to_move: KinematicBody2D):
	body_to_move = _body_to_move
	
func jump():
	pressed_jump = true
	
func sprint(_pressed_sprint: bool):
	pressed_sprint = _pressed_sprint
	
func set_move_vec(_move_vec: Vector2):
	move_vec = _move_vec.normalized()
	
func _physics_process(delta):
	if !is_visible_in_tree():
		return
	if !apply_forces:
		return
	var cur_move_vec = move_vec
	if frozen:
		cur_move_vec = Vector2.ZERO
	var multiplier = 1.0
	if pressed_sprint:
		multiplier *= sprint_multiplier
	velocity += multiplier * move_accel * cur_move_vec - velocity * Vector2(drag, 0) + gravity * Vector2.DOWN * delta
	velocity = body_to_move.move_and_slide_with_snap(velocity, snap_vec, Vector2.UP, true, 4, 0.785398, false)
	
	var grounded = body_to_move.is_on_floor()
	
	if grounded:
		velocity.y = -0.01;
	if grounded and pressed_jump:
		velocity.y = -jump_force
		snap_vec = Vector2.ZERO
	else:
		snap_vec = Vector2.DOWN
	pressed_jump = false;
	
	for index in body_to_move.get_slide_count():
		var collision = body_to_move.get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * inertia)
	emit_signal("movement_info", velocity, grounded)

func knockback( dir: Vector2, knockback_inertia: int):
	velocity = dir.normalized() * knockback_inertia
	
func freeze(_apply_forces = false):
	frozen = true
	apply_forces = _apply_forces

func unfreeze():
	frozen = false
