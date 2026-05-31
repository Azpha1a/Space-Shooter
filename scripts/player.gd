extends CharacterBody2D

@export var speedModifier: int = 400
@export var health: int = 3
signal laser(pos)
var can_shoot: bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
	var width = 1280
	var height = 720
	position = Vector2(width/2.0,height/4.0*3.0)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var direction = Input.get_vector("left","right","forward","backward")
	velocity = direction * speedModifier
	move_and_slide()

	if Input.is_action_just_pressed("shoot") and can_shoot:
		laser.emit($LaserStartPos.global_position)
		can_shoot = false
		$ShootCooldown.start()
		$LaserSound.play()


func _on_shoot_cooldown_timeout() -> void:
	can_shoot = true
