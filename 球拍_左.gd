extends CharacterBody2D


const SPEED = 300.0


func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_up_2", "ui_down_2")
	if direction:
		velocity.y = direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
