extends Node2D

var meteor_scene: PackedScene = load("res://scenes/meteor.tscn")
var laser_scene: PackedScene = load("res://scenes/laser.tscn")


func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	var stars = $Stars.get_children()
	for star in stars:
		star.speed_scale = rng.randf_range(0.25,1.5)
		var random_scale = rng.randf_range(0.25,1)
		star.scale = Vector2(random_scale,random_scale)
		var width = get_viewport().get_visible_rect().size[0]
		var height = get_viewport().get_visible_rect().size[1]
		var random_x = rng.randf_range(0,width)
		var random_y = rng.randf_range(0,height)
		star.position = Vector2(random_x,random_y)
	get_tree().call_group("ui","_set_health",$Player.health)

func _on_meteor_timer_timeout() -> void:
	var meteor = meteor_scene.instantiate()
	$Meteors.add_child(meteor)
	meteor.connect("collision", _on_meteor_collision)

func _on_meteor_collision():
	$Player.health -= 1
	$Player/DamageSound.play()
	get_tree().call_group("ui","_set_health",$Player.health)
	if $Player.health <= 0:
		get_tree().change_scene_to_file.call_deferred("res://scenes/game_over.tscn")
		
func _on_player_laser(pos):
	var laser = laser_scene.instantiate()
	$Lasers.add_child(laser)
	laser.position = pos
