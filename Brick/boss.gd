extends CharacterBody2D

var health = 200
var dying = false
var score = 5000
var tween

func _ready():
	$AnimatedSprite2D.play("default")

func _process(_delta):
	if health >= 80:
		$AnimatedSprite2D.modulate = Color8(255,255,255,255)
	elif health >= 70:
		$AnimatedSprite2D.modulate = Color8(255,16,240,255)
	elif health >= 60:
		$AnimatedSprite2D.modulate = Color8(188,19,254,255)
	elif health >= 50:
		$AnimatedSprite2D.modulate = Color8(31,81,255,255)
	elif health >= 40:
		$AnimatedSprite2D.modulate = Color8(57,255,20,255)
	elif health >= 30:
		$AnimatedSprite2D.modulate = Color8(255,234,0,255)
	elif health >= 20:
		$AnimatedSprite2D.modulate = Color8(255,95,31,255)
	elif health < 10:
		$AnimatedSprite2D.modulate = Color8(255,49,49,255)

func _physics_process(_delta):
	if dying && !$Kaboom.emitting && !tween:
		queue_free()

func hit(_ball):
	var brick_sound = get_node_or_null("/root/Game/Sound_Brick")
	if brick_sound != null:
		brick_sound.play()
	health -= 1
	if health <= 0:
		die()

func die():
	$Kaboom.emitting = true
	dying = true
	collision_layer = 0
	$AnimatedSprite2D.hide()
	Global.update_score(score)
	get_parent().check_level()

func _on_timer_timeout():
	tween = create_tween()
	if position.x == 300:
		tween.tween_property(self, "position", Vector2(850, position.y), 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	if position.x == 850:
		tween.tween_property(self, "position", Vector2(300, position.y), 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
