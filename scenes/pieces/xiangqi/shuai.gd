extends Node2D

@export var start_grid: Vector2i = Vector2i(0,0)
var piece_owner = "xiangqi"
var position_grid: Vector2i
var killing = false

var origin = "res://scenes/pieces/xiangqi/Shuai.tscn"
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
	
	var unlimited_moves = []
	unlimited_moves.append(position_grid + Vector2i(0, 2))
	unlimited_moves.append(position_grid + Vector2i(0, -2))
	unlimited_moves.append(position_grid + Vector2i(2, 0))
	unlimited_moves.append(position_grid + Vector2i(-2, 0))
		
	var moves = []
	for i in unlimited_moves:
		if board.check_legal(i):
			if !board.check_board(i) && i.y <= 4 && 6 <= i.x && i.x <= 10:
				moves.append(i)
			
	return [moves, []]
