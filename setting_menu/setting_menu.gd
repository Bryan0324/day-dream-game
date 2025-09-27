extends Node2D

@onready var container = $Container
@onready var back_button = $Container/Panel/VBoxContainer/BackButton
@onready var volume_slider = $Container/Panel/VBoxContainer/VolumeSlider

func _ready():
	back_button.pressed.connect(_on_back_pressed)
	volume_slider.value_changed.connect(_on_volume_changed)

	# 設置初始縮放為0，準備動畫
	container.scale = Vector2.ZERO

	# 播放進入動畫
	play_enter_animation()

func play_enter_animation():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(container, "scale", Vector2.ONE, 0.5)

func play_exit_animation():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(container, "scale", Vector2.ZERO, 0.3)
	await tween.finished
	get_tree().change_scene_to_file("res://start_menu/start_menu.tscn")

func _on_back_pressed():
	print("返回主選單")
	play_exit_animation()

func _on_volume_changed(value: float):
	print("音量設置為: ", value)
	# 這裡可以設置實際的音量
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value / 100.0))