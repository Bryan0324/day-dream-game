extends Node2D

@onready var board: Node2D = get_node("..")
var highlight_squares: Array = [] # 2D 陣列, 用來儲存可走點

# ---------------- 高亮可走格 ----------------
func _show_highlight(moves: Array):
	_clear_highlight()

	for g in moves[0]:
		var square = load("res://scenes/pieces/Light.tscn").instantiate() as Node2D
		add_child(square)
		square.position_grid = g
		square.position = board.grid_to_world(g)
		highlight_squares.append(square)
		square.get_node("Polygon2D").get_node("Area2D").connect("input_event", Callable(self, "_on_highlight_clicked").bind(square))
	for g in moves[1]:
		var square = load("res://scenes/pieces/Light.tscn").instantiate() as Node2D
		add_child(square)
		square.position_grid = g
		square.killing = false
		square.position = board.grid_to_world(g)
		highlight_squares.append(square)
		square.get_node("Polygon2D").get_node("Area2D").connect("input_event", Callable(self, "_on_highlight_clicked").bind(square))

func _clear_highlight():
	for sq in highlight_squares:
		sq.queue_free()
	highlight_squares.clear()

# ---------------- 點擊高亮格 ----------------
func _on_highlight_clicked(viewport, event, shape_idx, grid):
	if event is InputEventMouseButton and event.pressed:
		print("on_highlight_clicked ", grid.position_grid)
		board._move_piece(grid)
		_clear_highlight()
