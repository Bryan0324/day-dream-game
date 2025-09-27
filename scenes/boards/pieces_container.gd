extends Node2D
class_name PiecesContainer

func clear_all():
	for piece in get_children():
		piece.queue_free()
