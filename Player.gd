extends Area2D

signal hit
export var  speed = 400
var screen_size

onready var hurt_sound = $hurt
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	#hide()
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		
		velocity = velocity.normalized() * speed
		
		position += velocity * delta
		position.x = clamp(position.x, 0, screen_size.x)
		position.y = clamp(position.y, 0, screen_size.y)
		
		if velocity.x !=0:
			$AnimatedSprite.animation = "walk"
			$AnimatedSprite.flip_v = false
			
			$AnimatedSprite.flip_h = velocity.x < 0
		elif velocity.y != 0:
			$AnimatedSprite.animation = "up"
			$AnimatedSprite.flip_v = velocity.y > 0
		
		$AnimatedSprite.play()
		$Trail.emitting = true
	else:
		$AnimatedSprite.stop()
		$Trail.emitting = false
	if velocity.x < 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false


func _on_Player_body_entered(_body):
	Global.hp -= 1
	hurt_sound.play()
	var tween = create_tween()
	modulate = Color(1, 0, 0)
	var knockback_distance = Vector2(-20, 0)
		
	tween.tween_property(self, "position", position + knockback_distance, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	yield(tween, "finished")
	modulate = Color(1, 1, 1) 
	if Global.hp <= 0:
		hide()
		emit_signal("hit")
		
		$CollisionShape2D.set_deferred("disabled", true)
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
