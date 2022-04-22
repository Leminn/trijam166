extends KinematicBody2D

signal cheese_eaten()
signal cheese_repair()

const UP_DIRECTION := Vector2.UP

export var speed := 600

export var jump_strength := 1500.0
export var maximum_jumps := 2
export var double_jump_strength := 1200.0
export var gravity := 4500.0

var _jumps_made := 0
var _velocity := Vector2.ZERO

var repairing := false

var dead := false 
func _physics_process(delta: float) -> void:
	if(!dead):
		var _horizontal_direction = Input.get_axis("move_left","move_right")
		
		if(!repairing):
			_velocity.x = _horizontal_direction * speed
		else:
			_velocity.x = 0
		_velocity.y += gravity * delta
		
		var is_falling := _velocity.y > 0.0 and not is_on_floor()
		var is_jumping := Input.is_action_just_pressed("jump") and is_on_floor()
		var is_repairing := Input.is_action_just_pressed("repair_cheese") and is_on_floor()
		var is_double_jumping := Input.is_action_just_pressed("jump") and is_falling
		var is_jump_cancelled := Input.is_action_just_released("jump") and _velocity.y < 0.0
		var is_idling := is_on_floor() and is_zero_approx(_velocity.x)
		var is_running := is_on_floor() and not is_zero_approx(_velocity.x)
		
		if is_jumping:
			_jumps_made += 1
			_velocity.y = -jump_strength
		elif is_double_jumping:
			_jumps_made += 1
			if _jumps_made <= maximum_jumps and Cheeseman.cheese_amount > 0:
				emit_signal("cheese_eaten")
				_velocity.y = -double_jump_strength
				$CPUParticles2D.restart()
		elif is_jump_cancelled:
			_velocity.y = 0.0
		elif is_idling or is_running:
			_jumps_made = 0
		if is_repairing and !repairing:
			repairing = true
			$ProgressBar.visible = true
			$ProgressBar.max_value = $Timer.wait_time
			$ProgressBar.min_value = 0
			$Timer.start()

		
		if repairing:

			$ProgressBar.value = $Timer.time_left 

		_velocity = move_and_slide(_velocity, UP_DIRECTION)


		if not is_zero_approx(_velocity.x):
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false	
	


func _on_Timer_timeout():
	repairing = false
	$Timer.wait_time = 0.2
	$ProgressBar.visible = false
	emit_signal("cheese_repair")


func _on_killzone_body_entered(body):
	if body.name == "Player":
		queue_free()
		dead = true
