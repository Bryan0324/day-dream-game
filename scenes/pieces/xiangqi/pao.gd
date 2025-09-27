extends Node2D

@export var start_grid: Vector2i = Vector2i(0,0)
var piece_owner = "xiangqi"
var position_grid: Vector2i
var killing = false
var origin = "res://scenes/pieces/xiangqi/Pao.tscn"
@onready var board = get_node("../../")
@onready var sprite = $Sprite2D  # Bing.tscn 裡的 Sprite2D

func _ready():
	position_grid = start_grid
	global_position = get_parent().get_parent().grid_to_world(position_grid)

func cross_river():
	if position_grid.y >= 10:
		return true
	return false
func _get_valid_moves() -> Array:
	var moves = []
	var peace_moves = []
	var ptr
	# ---- right -------
	ptr = 0
	for i in range(position_grid.x+2, board.board_state.size(), 2):
		var now_pos = Vector2i(i, position_grid.y)
		if( board.check_board( now_pos ) ):
			if ptr == 1: break
			ptr+=1
			continue
		for d in range(-1, 2, 2):
			if(board.check_legal( now_pos + Vector2i(-1, d) )):
				if( board.check_board( now_pos + Vector2i(-1, d) ) ):
					ptr+=1
					break
		
		if ptr == 0:
			peace_moves.append(now_pos)
		elif ptr == 1:
			moves.append(now_pos)
		else: break
	# ------- left ----------
	ptr = 0
	for i in range(position_grid.x-2, -2, -2):
		var now_pos = Vector2i(i, position_grid.y)
		if( board.check_board( now_pos ) ):
			if ptr == 1: break
			ptr+=1
			continue
		for d in range(-1, 2, 2):
			print("scan ", now_pos + Vector2i(1, d))
			if(board.check_legal( now_pos + Vector2i(1, d) )):
				if( board.check_board( now_pos + Vector2i(1, d) ) ):
					ptr+=1
					break
		
		if ptr == 0:
			peace_moves.append(now_pos)
		elif ptr == 1:
			moves.append(now_pos)
		else: break
	# ------- up ----------
	ptr = 0
	for i in range(position_grid.y-2, -2, -2):
		var now_pos = Vector2i(position_grid.x, i)
		if( board.check_board( now_pos ) ):
			if ptr == 1: break
			ptr+=1
			continue
		for d in range(-1, 2, 2):
			if(board.check_legal( now_pos + Vector2i(d, 1) )):
				if( board.check_board( now_pos + Vector2i(d, 1) ) ):
					ptr+=1
					break
		
		if ptr == 0:
			peace_moves.append(now_pos)
		elif ptr == 1:
			moves.append(now_pos)
		else: break
	# ------- down ----------
	ptr = 0
	for i in range(position_grid.y+2, board.board_state[0].size(), 2):
		var now_pos = Vector2i(position_grid.x, i)
		if( board.check_board( now_pos ) ):
			if ptr == 1: break
			ptr+=1
			continue
		for d in range(-1, 2, 2):
			if(board.check_legal( now_pos + Vector2i(d, -1) )):
				if( board.check_board( now_pos + Vector2i(d, -1) ) ):
					ptr+=1
					break
		
		if ptr == 0:
			peace_moves.append(now_pos)
		elif ptr == 1:
			moves.append(now_pos)
		else: break
			
			
	return [moves, peace_moves]
