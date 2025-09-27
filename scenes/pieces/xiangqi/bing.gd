extends Node2D

@export var start_grid: Vector2i = Vector2i(0,0)
var piece_owner = "xiangqi"
var position_grid: Vector2i
var crossed_river = false

@onready var sprite = $Sprite2D  # Bing.tscn 裡的 Sprite2D

func _ready():
	position_grid = start_grid
	global_position = get_parent().get_parent().grid_to_world(position_grid)
	check_cross_river()

func check_cross_river():
	if position_grid.y >= 5:
		crossed_river = true

func get_moves() -> Array[Vector2i]:
	var moves = []
	if not crossed_river:
		moves.append(position_grid + Vector2i(0, 1))
	else:
		moves.append(position_grid + Vector2i(0, 1))
		moves.append(position_grid + Vector2i(1, 0))
		moves.append(position_grid + Vector2i(-1, 0))
	return moves
