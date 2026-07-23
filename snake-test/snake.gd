extends Node2D

var player_current := Vector2i(5, 5)
var player_score := 0
var player_tail: Array[Vector2i] = []
var apple_grid_location: Vector2i
var game_over := false
var rng = RandomNumberGenerator.new()
var current_direction = Vector2i.DOWN
var playboard_map: Array[Vector2i]

func draw_tail() -> void: 
	if len(player_tail) > 0 && !game_over:
		for i in player_tail.slice(0, player_score):
			$tail.set_cell(i, 0, Vector2i(4, 0))
	for x in $tail.get_used_cells():
		if !player_tail.slice(0, player_score).has(x) || game_over:
			$tail.set_cell(x, -1, Vector2i(0,0))

func set_apple_location() -> void:
	apple_grid_location = playboard_map.pick_random()
	while apple_grid_location == player_current || player_tail.slice(0, player_score).has(apple_grid_location):
		apple_grid_location = playboard_map.pick_random()
	$apple.global_position = $playboard.map_to_local(apple_grid_location)

func set_player_location(pos: Vector2i) -> void:
	player_tail.push_front(player_current)
	if !has_node("head"):
		return 
	if !playboard_map.has(pos) || player_tail.slice(1, player_score, -1).has(pos):
		game_over = true
		return
	$head.global_position = $playboard.map_to_local(pos)
	
func _ready() -> void:
	$game_over.visible = false
	playboard_map = $playboard.get_used_cells()
	set_player_location(player_current)
	set_apple_location()
	$Label.text = "Player Score: %d" % player_score

func _process(_delta: float) -> void:
	if Input.is_action_pressed("up"):
		current_direction = Vector2i.UP
	if Input.is_action_pressed("down"):
		current_direction = Vector2i.DOWN
	if Input.is_action_pressed("left"):
		current_direction = Vector2i.LEFT
	if Input.is_action_pressed("right"):
		current_direction = Vector2i.RIGHT
	if game_over:
		if has_node("head"):
			$head.queue_free()
		$game_over.visible = true
		if Input.is_anything_pressed():
			get_tree().reload_current_scene()

func _on_timer_timeout() -> void:
	player_current += current_direction
	draw_tail()
	set_player_location(player_current)
	if player_current == apple_grid_location:
		player_score += 1
		$Label.text = "Player Score: %d" % player_score
		set_apple_location()
