extends KinematicBody2D

const MAX_SPEED := 64
const FRICTION := .25
const AIR_RESISTANCE := .02

export var move_speed : float
export var jump_height : float
export var jump_time_to_peak: float
export var jump_time_to_descent: float

# using a modified euler formula to calculate the jump and fall parabole distance
onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var motion := Vector2.ZERO

func _physics_process(delta):
	var direction = get_direction()
	
	configure_move_speed(direction, delta)
	
	motion = move_and_slide(motion, Vector2.UP) 

func get_direction() -> float:
	return Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

func configure_move_speed(direction : float, delta : float):
	if direction != 0:
		motion.x += direction * move_speed * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
