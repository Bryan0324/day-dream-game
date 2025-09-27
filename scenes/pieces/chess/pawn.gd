extends Node2D

@export var start_grid: Vector2i = Vector2i(0,0)
var piece_owner = "chess"
var position_grid: Vector2i
var killing = false
var origin = "res://scenes/pieces/chess/Pawn.tscn"

@onready var board_sprite: Sprite2D = $BoardSprite
@onready var board = get_node("../../")
@onready var sprite = $Sprite2D  # Pawn.tscn 裡的 Sprite2D

func _ready():
	position_grid = start_grid
	global_position = get_parent().get_parent().grid_to_world(position_grid)

func _get_valid_moves() -> Array:
	var peace = []
	var tmp = position_grid + Vector2i(0, -2)
	if(board.check_legal(tmp)):
		if(board.board_state[tmp.x][tmp.y] == null):
			peace.append(tmp)
	return [[], peace]
