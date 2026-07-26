extends TileMapLayer

var Rng = RandomNumberGenerator.new()

@export var MapNoise = FastNoiseLite.new()
@export var HoleNoise = FastNoiseLite.new()
@export var elevation_shape: Curve
@export var ground_distribution: Curve
@export_range(-1, 1) var threshold: float
@export_range(-1, 1) var diff: float

var map_length = 10000 # tiles total upon x axis
var flat_ground_tile := Vector2i(3, 2) # Kill me.
var angled_ground_tile_up := Vector2i(2,2)
var angled_ground_tile_down := Vector2i(5,2)

func noise_norm(f: float): return int(clamp(f*10, -1, 1)) # 100% bullshit

func draw_angles(current_cell, previous_cell):
	if current_cell == Vector2i(0,0): return
	if current_cell.y > previous_cell.y:
		set_cell(
			Vector2i(previous_cell.x, previous_cell.y), 
			0, 
			angled_ground_tile_down
		)
	if current_cell.y < previous_cell.y:
		set_cell(
			Vector2i(current_cell.x, current_cell.y), 
			0, 
			angled_ground_tile_up
		)
		
	# tile = get tile information
	# if tile is downward facing:
	#	if tile before is not flat or tile before is not upward:
	#		make tile flat.

func draw_ground(tile: Vector2i, progress: float, island_length: int):
	var depth_range = [10, 20]
	
	if island_length >= 200:
		depth_range = [island_length*0.2, island_length*0.4]
	else:
		depth_range = [island_length*0.09, island_length*0.10]
	
	var depth = 60 * ground_distribution.sample(progress)
	# clamp(round(float(Rng.randi_range(
	#	depth_range[0], depth_range[1])
	#) * ground_distribution.sample(progress)), 0, 60)
	for i in range(depth):
		set_cell(Vector2i(tile.x, tile.y + 1 + i), 0, flat_ground_tile);

func draw_line_for_map(starting_cell, length) -> Vector2i: 
	var row = Rng.randf()
	var previous = 0
	var previous_cell: Vector2i
	var process: float = 0.00
	for i in range(length):
		process = float(i)/float(length) # TIL: Godot doesn't do auto-float division
		previous += noise_norm(MapNoise.get_noise_2d(i,row));
		set_cell(Vector2i(starting_cell.x+i, previous), 0, flat_ground_tile);
		draw_angles(Vector2i(starting_cell.x+i, previous), previous_cell)
		draw_ground(Vector2i(starting_cell.x+i, previous), process, length)
		previous_cell = Vector2i(starting_cell.x+i, previous) 
	return previous_cell # Returns last cell of the island

func _ready() -> void:
	var guiding_cell = Vector2i(0, 0);
	var island_length_range = [100, 2000] # min, max
	var gap_range = [15, 30] # min, max
	while guiding_cell.x <= map_length:
		guiding_cell = draw_line_for_map(
			guiding_cell, 
			Rng.randi_range(island_length_range[0], island_length_range[1]
			))
		guiding_cell += Vector2i(
			Rng.randi_range(gap_range[0], gap_range[1]), 
			Rng.randi_range(1, 60))
