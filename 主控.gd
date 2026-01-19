extends Node2D

@onready var ball: CharacterBody2D = $"../游戏区域/ball"
@onready var left_score_label: Label = $"../GUI/BoxContainer/左边得分"
@onready var right_score_label: Label = $"../GUI/BoxContainer/右边得分"

@onready var start_screen: Control = $"../CanvasLayer/开始界面"
@onready var over_screen: Control = $"../CanvasLayer/结束界面"
@onready var win_label: Label = $"../CanvasLayer/结束界面/HBoxContainer/VBoxContainer/Label"
@onready var countdown_label: Label = $"../CanvasLayer/Label"

# 游戏状态
var is_game_active := false

@export var win_score := 10

var left_score := 0
var right_score := 0

func _ready() -> void:
	reset_game_data()
	show_start_menu()

# 重置游戏数据
func reset_game_data():
	left_score = 0
	right_score = 0
	update_score_display()

# 重置球
func reset_ball():
	ball.start_new_round()
	await get_tree().create_timer(1.0).timeout
	if is_game_active:
		ball.launch()

func _on_左侧得分区域_body_entered(body: Node2D) -> void:
	if body.name == "ball":
		right_score += 1
		update_score_display()
		check_win()
		reset_ball()


func _on_右侧得分区域_body_entered(body: Node2D) -> void:
	if body.name == "ball":
		left_score += 1
		update_score_display()
		check_win()
		reset_ball()

# 检查是否有赢家
func check_win():
	if left_score >= win_score:
		game_over("Left Player")
	if right_score >= win_score:
		game_over("Right Player")

# 更新分数显示
func update_score_display():
	left_score_label.text = str(left_score)
	right_score_label.text = str(right_score)

# 显示开始界面
func show_start_menu():
	start_screen.visible = true
	over_screen.visible = false
	countdown_label.visible = false
	is_game_active = false
	ball.start_new_round()

func start_countdown():
	start_screen.visible = false
	over_screen.visible = false
	countdown_label.visible = true
	
	for i in range(3, 0, -1):
		countdown_label.text = str(i)
		countdown_label.scale = Vector2.ZERO
		var tween = create_tween()
		tween.tween_property(countdown_label, "scale", Vector2.ONE, 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		await get_tree().create_timer(1.0).timeout
	countdown_label.text = "Start !"
	await get_tree().create_timer(0.5).timeout
	countdown_label.visible = false
	start_game()

# 开始游戏
func start_game():
	start_screen.visible = false
	over_screen.visible = false
	is_game_active = true
	ball.launch()
	
# 游戏结束
func game_over(winner: String):
	is_game_active = false
	over_screen.visible = true
	win_label.text = winner + " WIN !!!"	

func _on_开始游戏_pressed() -> void:
	reset_game_data()
	start_countdown()

func _on_重开游戏_pressed() -> void:
	reset_game_data()
	start_countdown()
