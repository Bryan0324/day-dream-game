extends Node2D

# 棋盤格座標（Vector2i）
@export var start_grid: Vector2i = Vector2i(0,0)

# 棋子所屬方，避免與 Node2D 原生 owner 衝突
var piece_owner = "chess"

# 目前棋子所在格子
var position_grid: Vector2i

func _ready():
	# 因為 _ready() 時 Node 已經加到場景樹，所以 get_parent() 不為 null
	position_grid = start_grid
	# 使用 Board 提供的 grid_to_world 將格子座標轉世界座標
	global_position = get_parent().get_parent().grid_to_world(position_grid)

# 簡單示例走法：偶數格向上走一格
func get_moves() -> Array[Vector2i]:
	return [position_grid + Vector2i(0, -1)]
