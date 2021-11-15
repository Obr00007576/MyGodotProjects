extends Node2D
enum STATES { IDLE, ATTACK, WALK, JUMP}
var ANIMATIONS = {STATES.IDLE: "Idle",STATES.ATTACK: "Attack",STATES.WALK: "Walk", STATES.JUMP:"Jump"}
var status = null
var speed=Vector2(0,0)
var g=20
func _ready():
	status=STATES.IDLE
func _physics_process(delta):
	speed.x=0
	speed.y+=g*delta
	match status:
		STATES.IDLE:
			$Collision/Warrior_sprites.show()
			$Collision/Sprite.hide()
			pass
		STATES.WALK:
			if scale.x<0:
				speed.x=-2
			else:
				speed.x=-2
			$Collision/Warrior_sprites.show()
			$Collision/Sprite.hide()
		STATES.ATTACK:
			$Collision/Warrior_sprites.show()
			$Collision/Sprite.hide()
		STATES.JUMP:
			$Collision/Warrior_sprites.hide()
			$Collision/Sprite.show()
	$Collision/AnimationPlayer.play(ANIMATIONS[status])
	speed=$Collision.move_and_slide(speed, Vector2(0, -1))
	$Collision.position+=speed
func _input(event):
	if Input.is_key_pressed(KEY_A):
		status=STATES.ATTACK
	elif Input.is_key_pressed(KEY_UP):
		pass
	elif Input.is_key_pressed(KEY_DOWN):
		pass
	elif Input.is_key_pressed(KEY_J):
		status=STATES.JUMP
	elif Input.is_key_pressed(KEY_LEFT):
		status=STATES.WALK
		scale.x=-2
	elif Input.is_key_pressed(KEY_RIGHT):
		status=STATES.WALK
		scale.x=2
	else:
		status=STATES.IDLE
func aasd():
	position.x+=2