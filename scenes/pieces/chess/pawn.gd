extends Node2D

@export var start_grid: Vector2i = Vector2i(0,0)
var piece_owner = "chess"
var position_grid: Vector2i

@onready var sprite = $Sprite2D  # Pawn.tscn 裡的 Sprite2D

func _ready():
	position_grid = start_grid
	global_position = get_parent().get_parent().grid_to_world(position_grid)

func get_moves() -> Array[Vector2i]:
	# 偶數格向上走一格
	return [position_grid + Vector2i(0, -1)]
