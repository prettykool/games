extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Sprite2D.texture.width = get_window().size.x
	$Sprite2D.texture.height = get_window().size.y
	$Sprite2D.texture.noise.seed += 1
	pass
