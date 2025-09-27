extends Node2D

@onready var board_sprite: Sprite2D = $BoardSprite
@onready var pieces_container: Node2D = $PiecesContainer
@onready var highlight_layer: Node2D = $HighlightLayer

const GRID_COLS := 16
const GRID_ROWS := 16

var tile_size: Vector2 = Vector2.ZERO
var board_state: Array = []   # 2D 陣列，用來儲存棋子

func _ready():
	_resize_board()
	_calc_tile_size()
	_init_board_state()
	_spawn_all_pieces()

# ---------- 棋盤大小與格子 ----------
func _resize_board():
	var margin = 30  # 留 30px 邊界
	var viewport_size = get_viewport_rect().size
	var tex_size = board_sprite.texture.get_size()
	var scale_factor = min(viewport_size.x / (tex_size.x+margin), viewport_size.y / (tex_size.y+margin*6))
	board_sprite.scale = Vector2.ONE * scale_factor

	var board_size = tex_size * scale_factor
	board_sprite.position = (viewport_size - board_size) * 0.5 + Vector2(margin, margin)

func _calc_tile_size():
	var board_size = board_sprite.texture.get_size() * board_sprite.scale
	tile_size = board_size / Vector2(GRID_COLS, GRID_ROWS)
	print("tile_size = ", tile_size)
# ---------- 棋盤狀態 ----------
func _init_board_state():
	board_state.clear()
	for r in range(GRID_ROWS+1):
		var row = []
		for c in range(GRID_COLS+1):
			row.append(null)   # 初始沒棋子
		board_state.append(row)

# ---------- 棋子生成 ----------
func _spawn_all_pieces():
	#------ 中國象棋 -----------------
	# 車
	for i in range(0, 20, 16):
		_spawn_piece("res://scenes/pieces/xiangqi/Bing.tscn", Vector2i(i, 0))
		
	# 馬
	for i in range(2, 20, 12):
		_spawn_piece("res://scenes/pieces/xiangqi/Bing.tscn", Vector2i(i, 0))
		
	# 象
	for i in range(4, 20, 8):
		_spawn_piece("res://scenes/pieces/xiangqi/Bing.tscn", Vector2i(i, 0))
		
	# 仕
	for i in range(6, 14, 4):
		_spawn_piece("res://scenes/pieces/xiangqi/Bing.tscn", Vector2i(i, 0))
		
	# 帥
	_spawn_piece("res://scenes/pieces/xiangqi/Bing.tscn", Vector2i(8, 0))
	
	# 炮
	for i in range(2, 20, 12):
		_spawn_piece("res://scenes/pieces/xiangqi/Bing.tscn", Vector2i(i, 4))
	
	# 兵
	for i in range(0, 20, 4):
		_spawn_piece("res://scenes/pieces/xiangqi/Bing.tscn", Vector2i(i, 6))
	
	# ------------------------------------
	
	# ------ 西洋棋 -----------------------
	# 兵
	for i in range(1, 17, 2):
		_spawn_piece("res://scenes/pieces/chess/Pawn.tscn", Vector2i(i, 13))
		
	# 
	for i in range(1, 17, 14):
		_spawn_piece("res://scenes/pieces/chess/Pawn.tscn", Vector2i(i, 15))
		
	# 
	for i in range(3, 17, 10):
		_spawn_piece("res://scenes/pieces/chess/Pawn.tscn", Vector2i(i, 15))
		
	# 
	for i in range(5, 17, 6):
		_spawn_piece("res://scenes/pieces/chess/Pawn.tscn", Vector2i(i, 15))
		
	# 
	_spawn_piece("res://scenes/pieces/chess/Pawn.tscn", Vector2i(7, 15))
	
	# 
	_spawn_piece("res://scenes/pieces/chess/Pawn.tscn", Vector2i(9, 15))

func _spawn_piece(scene_path: String, grid: Vector2i):
	var piece_scene = load(scene_path)
	var piece : Node2D = piece_scene.instantiate()
	pieces_container.add_child(piece)
	
	# 棋子座標與狀態同步
	piece.position_grid = grid
	piece.global_position = grid_to_world(grid)
	board_state[grid.y][grid.x] = piece

	# 自動縮放棋子 sprite
	if piece.has_node("Sprite2D"):
		var spr: Sprite2D = piece.get_node("Sprite2D")
		var tex_size = spr.texture.get_size()
		var scale_factor = min(tile_size.x / tex_size.x, tile_size.y / tex_size.y) * 1.5
		spr.scale = Vector2.ONE * scale_factor
		spr.z_index = 2

	print(piece.name, " placed at ", grid)






# ---------- 座標轉換 ----------
func grid_to_world(grid: Vector2i) -> Vector2:
	# 左上角為棋盤原點
	var local_pos = Vector2(grid) * tile_size
	# 棋子底部中心位置要加 tile_size.y
	return board_sprite.position + local_pos - Vector2(tile_size.x/2, tile_size.y)

func world_to_grid(world_pos: Vector2) -> Vector2i:
	var local = world_pos - board_sprite.position
	return Vector2i((local / tile_size).floor())
