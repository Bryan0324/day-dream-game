extends Node2D

@export var start_grid: Vector2i = Vector2i(0,0)
var piece_owner = "chess"
var position_grid: Vector2i
var killing = false

var origin = "res://scenes/pieces/chess/Bishop.tscn"
@onready var sprite = $Sprite2D  # Bing.tscn 裡的 Sprite2D

@onready var board = get_node("../../")

func _ready():
	position_grid = start_grid
	global_position = get_parent().get_parent().grid_to_world(position_grid)

func cross_river():
	if position_grid.y >= 10:
		return true
	return false
func _get_valid_moves() -> Array:
	var moves = []
	var sign = [-1, 1]
	for s1 in sign:
		for s2 in sign:
			var s = position_grid + Vector2i(s1*2, s2*2)
			while board.check_legal(s):
				if board.check_board(s): break
				if board.check_board(s-Vector2i(s1, s2)): break
				moves.append(s)
				s += Vector2i(s1*2, s2*2)
			
	return [moves, []]
