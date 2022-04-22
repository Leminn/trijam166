extends KinematicBody2D

export var fall_speed := 30
var _velocity  := Vector2.ZERO

func _process(delta):

	_velocity.y = fall_speed * delta
	position += _velocity 
