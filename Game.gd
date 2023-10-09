extends Node2D



func _ready():
	if Global.level < 0 or Global.level >= len(Levels.levels):
		Global.end_game(true)
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		var Music = get_node_or_null("/root/Game/Music")
		var level = Levels.levels[Global.level]
		var margin = level["layout_start"]
		var index = level["layout_spacing"]
		var layout = level["layout"]
		var isBoss = level["boss"]
		var Brick_Container = get_node_or_null("/root/Game/Brick_Container")
		Global.time = level["timer"]
		if Music != null:
			Music.stream = load(level["music"])
			Music.play()
		if Brick_Container != null:
			if isBoss == "boss1":
				var Boss = load("res://Brick/boss.tscn")
				var boss = Boss.instantiate()
				boss.position = Vector2(300, 250)
				Brick_Container.add_child(boss)
			var Brick = load("res://Brick/Brick.tscn")
			var Brick2 = load("res://Brick/brick2.tscn")
			for rows in range(len(layout)):
				for cols in range(len(layout[rows])):
					if layout[rows][cols] > 0:
						var brick = Brick.instantiate()
						var brick2 = Brick2.instantiate()
						brick.new_position = Vector2(margin.x + index.x*cols, margin.y + index.y*rows)
						brick.position = Vector2(brick.new_position.x,-100)
						brick.score = layout[rows][cols]
						brick2.new_position = Vector2(margin.x + index.x*cols, margin.y + index.y*rows)
						brick2.position = Vector2(brick.new_position.x,-100)
						brick2.score = layout[rows][cols]
						if brick.score != 150:
							Brick_Container.add_child(brick)
						if brick2.score == 150:
							Brick_Container.add_child(brick2)
		var Instructions = get_node_or_null("/root/Game/UI/Instructions")
		if Instructions != null:
			Instructions.set_instructions(level["name"],level["instructions"])
