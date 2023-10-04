extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false

var powerup_prob = 0.1

func _ready():
	randomize()
	position = new_position
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
	if dying && !$Kaboom.emitting:
		queue_free()

func hit(_ball):
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
