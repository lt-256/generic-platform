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

onready var sprite := $Sprite
onready var animPlayer := $AnimationPlayer

var motion := Vector2.ZERO

func _physics_process(delta):
	var direction = get_direction()
	
	configure_move_speed(direction, delta)
	configure_sprite_direction(direction)
	configure_animation(direction)
	
	motion.y += get_gravity() * delta
	
	jump(direction)
	
	motion = move_and_slide(motion, Vector2.UP) 

func get_direction() -> float:
	return Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

func configure_move_speed(direction : float, delta : float):
	if direction != 0:
		motion.x += direction * move_speed * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)

func configure_sprite_direction(direction : float):
	if direction != 0:
		sprite.flip_h = direction < 0

func configure_animation(direction : float):
	if direction != 0:
		animPlayer.play("run")
	else:
		animPlayer.play("idle")
	
	if !is_on_floor():
		animPlayer.play("jump")

func get_gravity() -> float:
	return jump_gravity if motion.y < 0.0 else fall_gravity

func jump(direction : float):
	if is_on_floor():
		if direction == 0:
			motion.x = lerp(motion.x, 0, FRICTION)
		
		if Input.is_action_pressed("ui_up"):
			motion.y = jump_velocity
	else:
		if Input.is_action_just_released("ui_up") and motion.y < jump_velocity/2.0:
			motion.y = jump_velocity/2.0
		
		if direction == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE)
