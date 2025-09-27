extends Node2D

# 將棋子統一放到 PiecesContainer
@onready var pieces_container = $PiecesContainer
# 顯示可走格或可吃格的高亮圖層
@onready var highlight_layer = $HighlightLayer

const TILE_SIZE = 64

# 預載棋子 Scene
const PAWN_SCENE = preload("res://scenes/pieces/chess/Pawn.tscn")
const BING_SCENE = preload("res://scenes/pieces/xiangqi/Bing.tscn")

var selected_piece = null

func _ready():
	# 自動生成棋子
	spawn_pieces()

# 將格子座標 Vector2i 轉世界座標 Vector2
func grid_to_world(pos: Vector2i) -> Vector2:
	return Vector2(pos) * TILE_SIZE + Vector2(TILE_SIZE/2, TILE_SIZE/2)

# 將世界座標轉格子座標
func world_to_grid(world_pos: Vector2) -> Vector2i:
	return (world_pos / TILE_SIZE).floor()

# 自動生成棋子，並設定起始格子與所屬方
func spawn_pieces():
	var pawn = PAWN_SCENE.instantiate()
	pawn.piece_owner = "chess"
	pawn.start_grid = Vector2i(0,0)  # 最左下角
	pieces_container.add_child(pawn)
	print("Pawn added at ", pawn.start_grid)

	var bing = BING_SCENE.instantiate()
	bing.piece_owner = "xiangqi"
	bing.start_grid = Vector2i(1,0)
	pieces_container.add_child(bing)
	print("Bing added at ", bing.start_grid)


# 處理滑鼠點擊選棋子與移動
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = event.position
		var clicked_piece = get_piece_at(mouse_pos)

		if clicked_piece:
			# 選中棋子
			selected_piece = clicked_piece
			highlight_moves(selected_piece)
		elif selected_piece:
			# 嘗試移動棋子
			var target_grid = world_to_grid(mouse_pos)
			if target_grid in selected_piece.get_moves():
				selected_piece.position_grid = target_grid
				selected_piece.global_position = grid_to_world(target_grid)
			highlight_layer.clear()
			selected_piece = null

# 回傳滑鼠點擊位置的棋子
func get_piece_at(world_pos: Vector2):
	for piece in pieces_container.get_children():
		if piece.global_position.distance_to(world_pos) < TILE_SIZE/2:
			return piece
	return null

# 高亮可走格
func highlight_moves(piece):
	highlight_layer.clear()
	var moves = piece.get_moves()
	for pos in moves:
		var highlight = ColorRect.new()
		highlight.color = Color(0,1,0,0.5)  # 綠色高亮
		highlight.rect_size = Vector2(TILE_SIZE, TILE_SIZE)
		highlight.position = grid_to_world(pos) - highlight.rect_size/2
		highlight_layer.add_child(highlight)
