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

var max_health = 3
var player_movement_state: player_movement_states
var sp_score: float = 0.00
var sp_special: float = 100
var level = 1
var double_jump_enabled = true

func basic() -> void:
	pass

func elemental() -> void:
	pass
	
func special() -> void:
	if sp_score != sp_special:
		return;
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	player_movement_state = player_movement_states.IDLE

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if is_on_floor() && direction:
		player_movement_state = player_movement_states.RUNNING
		
	if player_movement_state == player_movement_states.RUNNING || !is_on_floor():
		$Sprite2D.rotate(0.3)

	move_and_slide()
