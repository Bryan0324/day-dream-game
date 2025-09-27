extends Node2D

@onready var setting_menu = $SettingMenu
@onready var setting_panel = $SettingMenu/ColorRect
@onready var back_button = $SettingMenu/back

func _ready():
	$start.pressed.connect(_on_start_pressed)
	$quit.pressed.connect(_on_quit_pressed)
	$settings.pressed.connect(_on_settings_pressed)
	back_button.pressed.connect(_on_back_pressed)

func _on_start_pressed():
	print("開始遊戲")
	# 這裡可以切換到遊戲主場景
	# get_tree().change_scene_to_file("res://main_game.tscn")

func _on_quit_pressed():
	print("退出遊戲")
	get_tree().quit()

func _on_settings_pressed():
	print("打開設置")
	show_setting_menu()

func show_setting_menu():
	setting_menu.visible = true

	# 設置初始縮放為0
	setting_panel.scale = Vector2.ZERO

	# 播放縮放動畫
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(setting_panel, "scale", Vector2.ONE, 0.5)

func hide_setting_menu():
	# 播放退出動畫
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(setting_panel, "scale", Vector2.ZERO, 0.3)
	await tween.finished
	setting_menu.visible = false

func _on_back_pressed():
	print("返回主選單")
	hide_setting_menu()
