extends Node2D

@onready var board_sprite: Sprite2D = $BoardSprite
@onready var pieces_container: Node2D = $PiecesContainer
@onready var HighlightLayer: Node2D = $HighlightLayer
@onready var turn_label: Label = $TurnLabel
@onready var win_menu: CanvasLayer = $WinMenu
@onready var win_color_rect: ColorRect = $WinMenu/ColorRect
@onready var winner_label: Label = $WinMenu/ColorRect/Winner
@onready var again_button: Button = $WinMenu/ColorRect/Again
@onready var leave_button: Button = $WinMenu/ColorRect/Leve
const GRID_COLS := 16
const GRID_ROWS := 16
var selected_piece: Node2D
var tile_size: Vector2 = Vector2.ZERO
var board_state: Array = []   # 2D 陣列，用來儲存棋子
var now_trun_chess = true
func _ready():
	_resize_board()
	_calc_tile_size()
	_init_board_state()
	_spawn_all_pieces()
	_setup_win_menu()

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
		_spawn_piece("res://scenes/pieces/xiangqi/Che.tscn", Vector2i(i, 0))
		
	# 馬
	for i in range(2, 20, 12):
		_spawn_piece("res://scenes/pieces/xiangqi/Ma.tscn", Vector2i(i, 0))
		
	# 象
	for i in range(4, 20, 8):
		_spawn_piece("res://scenes/pieces/xiangqi/Xiang.tscn", Vector2i(i, 0))
		
	# 仕
	for i in range(6, 14, 4):
		_spawn_piece("res://scenes/pieces/xiangqi/Shih.tscn", Vector2i(i, 0))
		
	# 帥
	_spawn_piece("res://scenes/pieces/xiangqi/Shuai.tscn", Vector2i(8, 0))
	
	# 炮
	for i in range(2, 20, 12):
		_spawn_piece("res://scenes/pieces/xiangqi/Pao.tscn", Vector2i(i, 4))
	
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
		_spawn_piece("res://scenes/pieces/chess/Castle.tscn", Vector2i(i, 15))
		
	# 
	for i in range(3, 17, 10):
		_spawn_piece("res://scenes/pieces/chess/Knight.tscn", Vector2i(i, 15))
		
	# 
	for i in range(5, 17, 6):
		_spawn_piece("res://scenes/pieces/chess/Bishop.tscn", Vector2i(i, 15))
		
	# 
	_spawn_piece("res://scenes/pieces/chess/Queen.tscn", Vector2i(7, 15))
	
	# 
	_spawn_piece("res://scenes/pieces/chess/King.tscn", Vector2i(9, 15))

func _spawn_piece(scene_path: String, grid: Vector2i):
	var piece_scene = load(scene_path)
	var piece : Node2D = piece_scene.instantiate()
	pieces_container.add_child(piece)
	# 棋子座標與狀態同步
	piece.position_grid = grid
	piece.global_position = grid_to_world(grid)
	board_state[grid.x][grid.y] = piece

	# 自動縮放棋子 sprite
	if piece.has_node("Sprite2D"):
		var spr: Sprite2D = piece.get_node("Sprite2D")
		var tex_size = spr.texture.get_size()
		var scale_factor = min(tile_size.x / tex_size.x, tile_size.y / tex_size.y) * 1.5
		spr.scale = Vector2.ONE * scale_factor
		spr.z_index = 2
		if piece.piece_owner == "chess":
			spr.offset = Vector2(0, -tile_size.y*0.1)
	print(piece.name, " placed at ", grid)
	var area: Area2D = piece.get_node("Area2D")
	area.connect("input_event", Callable(self, "_on_piece_clicked").bind(piece))
	
func _on_piece_clicked(viewport, event, shape_idx, piece):
	if event is InputEventMouseButton and event.pressed:
		if((piece.piece_owner == "chess") != now_trun_chess): return
		print("Clicked piece: ", piece.name, " at grid ", piece.position_grid)
		if selected_piece == null:
			selected_piece = piece
			HighlightLayer._show_highlight(piece._get_valid_moves())
		else:
			selected_piece = null
			HighlightLayer._clear_highlight()
# ---------- 更新顯示 ----------
func _update_turn_label():
	if now_trun_chess:
		turn_label.text = "\"現在是西洋棋回合\""
	else:
		turn_label.text = "\"現在是中國象棋回合\""
func _move_piece(light_grid : Node2D):
	var pos = selected_piece.position_grid
	var grid = light_grid.position_grid
	print("form", pos, " moving to ", grid)

	# 檢查目標位置是否有棋子需要被吃掉
	if board_state[grid.x][grid.y] != null:
		print("吃掉棋子: ", board_state[grid.x][grid.y].origin)
		board_state[grid.x][grid.y].queue_free()
		board_state[grid.x][grid.y] = null

	# 處理特殊殺戮模式（周圍棋子）
	if(light_grid.killing):
		var x_over = grid.x+1 == board_state.size()
		var y_over = grid.y+1 == board_state[0].size()
		var x_neg = grid.x == 0
		var y_neg = grid.y == 0
		var dx = []
		var dy = []
		if(!x_over): dx.append(grid.x+1)
		if(!y_over): dy.append(grid.y+1)
		if(!x_neg): dx.append(grid.x-1)
		if(!y_neg): dy.append(grid.y-1)
		for x in dx:
			for y in dy:
				if(board_state[x][y] != null):
					print("特殊殺戮吃掉: ", board_state[x][y].origin)
					board_state[x][y].queue_free()
					board_state[x][y] = null

	# 移除原位置的棋子
	board_state[pos.x][pos.y].queue_free()
	board_state[pos.x][pos.y] = null

	# 在新位置生成棋子
	_spawn_piece(selected_piece.origin, grid)
	selected_piece = null

	# 檢查勝利條件
	_check_win_condition()

	# 換回合
	now_trun_chess = !now_trun_chess  # 換回合
	_update_turn_label()              # 更新顯示
	





# ---------- 座標轉換 ----------
func grid_to_world(grid: Vector2i) -> Vector2:
	# 左上角為棋盤原點
	var local_pos = Vector2(grid.x*tile_size.x, grid.y*tile_size.y)
	# 棋子底部中心位置要加 tile_size.y
	return board_sprite.position + local_pos

func world_to_grid(world_pos: Vector2) -> Vector2i:
	var local = world_pos - board_sprite.position
	return Vector2i((local / tile_size).floor())

func check_legal(pos : Vector2i):
	return  0 <= pos.x and pos.x < board_state.size() and 0 <= pos.y and pos.y < board_state[0].size()
	
func check_board(pos : Vector2i):
	return  board_state[pos.x][pos.y] != null

# ---------- 勝利選單功能 ----------
func _setup_win_menu():
	win_color_rect.hide()
	again_button.text = "再來一局"
	leave_button.text = "回到主選單"
	again_button.pressed.connect(_on_again_pressed)
	leave_button.pressed.connect(_on_leave_pressed)

func _on_again_pressed():
	_reset_board()

func _on_leave_pressed():
	get_tree().change_scene_to_file("res://Main.tscn")

func _reset_board():
	win_color_rect.hide()
	selected_piece = null
	now_trun_chess = true
	HighlightLayer._clear_highlight()
	_clear_all_pieces()
	_init_board_state()
	_spawn_all_pieces()
	_update_turn_label()

func _clear_all_pieces():
	for child in pieces_container.get_children():
		child.queue_free()

func _check_win_condition():
	var chess_king_alive = false
	var xiangqi_shuai_alive = false

	print("檢查勝利條件...")

	for x in range(board_state.size()):
		for y in range(board_state[0].size()):
			var piece = board_state[x][y]
			if piece != null:
				print("發現棋子: ", piece.origin, " 擁有者: ", piece.piece_owner)
				if piece.piece_owner == "chess" and ("King.tscn" in piece.origin):
					chess_king_alive = true
					print("西洋棋王還活著")
				elif piece.piece_owner == "xiangqi" and ("Shuai.tscn" in piece.origin):
					xiangqi_shuai_alive = true
					print("中國象棋帥還活著")

	print("西洋棋王: ", chess_king_alive, " 中國象棋帥: ", xiangqi_shuai_alive)

	if not chess_king_alive:
		print("西洋棋王被吃掉了!")
		_show_winner("中國象棋獲勝!")
		return true
	elif not xiangqi_shuai_alive:
		print("中國象棋帥被吃掉了!")
		_show_winner("西洋棋獲勝!")
		return true

	return false

func _show_winner(winner_text: String):
	winner_label.text = winner_text
	winner_label.add_theme_font_size_override("font_size", 48)
	win_color_rect.show()
