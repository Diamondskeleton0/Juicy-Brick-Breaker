extends CharacterBody2D

var target = Vector2.ZERO
var speed = 10.0
var width = 0
var width_default = 0
var decay = 0.02

func _ready():
	width = $CollisionShape2D.get_shape().size.x
	width_default = width
	target = Vector2(Global.VP.x / 2, Global.VP.y - 80)
	$Highlight.modulate.a = 0

func _physics_process(_delta):
	target.x = clamp(target.x, width/2, Global.VP.x - width/2)
	position = target
	for c in $Powerups.get_children():
		c.payload()
	if $Highlight.modulate.a > 0:
		$Highlight.modulate.a -= decay

func _input(event):
	if event is InputEventMouseMotion:
		target.x += event.relative.x

func hit(_ball):
	var paddle_sound = get_node_or_null("/root/Game/Sound_Paddle")
	if paddle_sound != null:
		paddle_sound.play()
	$Highlight.modulate.a = 1.0
	$Boom.emitting = true

func powerup(payload):
	for c in $Powerups.get_children():
		if c.type == payload.type:
			c.queue_free()
	$Powerups.call_deferred("add_child", payload)
