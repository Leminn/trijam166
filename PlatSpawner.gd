extends Node2D

var minX : float
var maxX : float
export(PackedScene) var platform_scene
var rng
var speed = 150


func _ready():
	rng = RandomNumberGenerator.new()	
	minX = $MinX.position.x
	maxX = $MaxX.position.x


func spawn_platform():
	var platform = platform_scene.instance()
	platform.position.x = rng.randf_range(minX,maxX)
	platform.position.y = 25
	platform.fall_speed = speed
	speed = clamp(speed + 2.5,150,400)
	$PlatParent.add_child(platform)
	pass


func _on_Timer_timeout():
	spawn_platform()


func _on_killzone_body_entered(body):
	if body.name == "Player":
		self.queue_free()
