extends CharacterBody2D


@export var initial_speed = 300.0
var current_speed = 300.0

# 切向系数，拍子速度 x 切向系数 = 最终加给球的速度
const vertical_y = 0.5

#func _ready() -> void:
	#start_new_round()
	#launch()

# 更新球的位置
func _physics_process(delta: float) -> void:
	if velocity != Vector2.ZERO:
		var collision = move_and_collide(velocity * delta)
		if collision:
			velocity = velocity.bounce(collision.get_normal())
			var collider = collision.get_collider()
			if collider is CharacterBody2D:
				velocity.y += collider.velocity.y * vertical_y

# 初始化球
func start_new_round():
	position = Vector2(578, 324)
	current_speed = initial_speed
	velocity = Vector2.ZERO

# 随机方向发射球
func launch():
	var direction_x = 1 if randf() > 0.5 else -1
	var direction_y = randf_range(-0.5, 0.5)
	velocity = Vector2(direction_x, direction_y).normalized() * current_speed
