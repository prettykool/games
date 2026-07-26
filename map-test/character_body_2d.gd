extends CharacterBody2D

class_name PlayerCharacter

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

enum player_movement_states {
	RUNNING,
	IDLE
}

enum player_action_states {
	IDLE,
	SHOOTING,
}

enum attack_types {
	BASIC,
	MAGIC,
	SPECIAL
}

var max_health = 3
var player_movement_state: player_movement_states
var sp_score: float = 0.00
var sp_special: float = 100
var level = 1
var double_jump_enabled = true
var max_jumps: int = 1
var jumps: int = 0
var dash_velocity: float = SPEED * 4.0
var can_dash = true
var dash_time: float = 1.0
var dash_cooldown: float = 1.5

signal just_dashed()

func do_basic() -> void:
	pass

func do_elemental() -> void:
	pass
	
func do_special() -> void:
	if sp_score != sp_special:
		return;

func _ready() -> void: 
	# $dash_timer.wait_time = dash_time
	# $dash_cooldown_timer.wait_time = dash_cooldown
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") && jumps < max_jumps:
		velocity.y = JUMP_VELOCITY
		jumps += 1

	player_movement_state = player_movement_states.IDLE

	if is_on_floor():
		jumps = 0

	var direction := Input.get_axis("left", "right")
	if Input.is_action_just_pressed("shift") && direction:
		$dash_timer.start()
	
	if Input.is_action_pressed("shift") && direction && can_dash:
		velocity.x = dash_velocity * direction
	elif direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if is_on_floor() && direction:
		player_movement_state = player_movement_states.RUNNING
		
	if player_movement_state == player_movement_states.RUNNING || !is_on_floor():
		$Sprite2D.rotate(0.3)

	move_and_slide()
	
# HERE BE HIDEOUS GARBAGE
func _on_dash_timer_timeout() -> void:
	can_dash = false
	$dash_cooldown_timer.start()
	
func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true
