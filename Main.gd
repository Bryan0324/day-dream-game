extends Node2D

@onready var play_button: Button = $Play
@onready var quit_button: Button = $Quit

func _ready():
	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/boards/Board.tscn")

func _on_quit_pressed():
	get_tree().quit()
