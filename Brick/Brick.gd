extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false
var tween
var time_appear = 0.5
var time_fall = 0.8
var time_rotate = 1.0
var time_a = 0.8
var time_s = 1.2
var time_v = 1.5

var powerup_prob = 0.1

func _ready():
	randomize()
	process_mode = Node.PROCESS_MODE_ALWAYS
	position.x = new_position.x
	position.y = -100
	var tween = create_tween()
	tween.tween_property(self, "position", new_position, 0.5 + randf()*2).set_trans(Tween.TRANS_BOUNCE)
	if score >= 100:
		$Sprite2D.modulate = Color8(255,49,49,255)
	elif score >= 90:
		$Sprite2D.modulate = Color8(255,95,31,255)
	elif score >= 80:
		$Sprite2D.modulate = Color8(255,234,0,255)
	elif score >= 70:
		$Sprite2D.modulate = Color8(57,255,20,255)
	elif score >= 60:
		$Sprite2D.modulate = Color8(31,81,255,255)
	elif score >= 50:
		$Sprite2D.modulate = Color8(188,19,254,255)
	elif score >= 40:
		$Sprite2D.modulate = Color8(255,16,240,255)
	elif score < 40:
		$Sprite2D.modulate = Color8(255,255,255,255)

func _physics_process(_delta):
	if dying && !$Kaboom.emitting and !tween:
		queue_free()

func hit(_ball):
	var brick_sound = get_node_or_null("/root/Game/Sound_Brick")
	if brick_sound != null:
		brick_sound.play()
	die()

func die():
	$Kaboom.emitting = true
	dying = true
	collision_layer = 0
	$Sprite2D.hide()
	Global.update_score(score)
	if not Global.feverish:
		Global.update_fever(score)
	get_parent().check_level()
	if randf() < powerup_prob:
		var Powerup_Container = get_node_or_null("/root/Game/Powerup_Container")
		if Powerup_Container != null:
			var Powerup = load("res://Powerups/Powerup.tscn")
			var powerup = Powerup.instantiate()
			powerup.position = position
			Powerup_Container.call_deferred("add_child", powerup)
	if tween:
		tween.kill()
	tween = create_tween().set_parallel(true)
	tween.tween_property(self, "position", Vector2(position.x, 1000), time_fall).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "rotation", -PI + randf()*2*PI, time_rotate).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
