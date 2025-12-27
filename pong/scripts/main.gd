extends Node2D

var up:bool
var down:bool
var speed = 200
var current_speed = 200
var direction_x:int
var direction_y:int
var player_points := 0
var enemy_points := 0
var changing_speed = false
var settings = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction_x = randi_range(-1, 1)
	direction_y = randi_range(-1, 1)

func _input(event: InputEvent) -> void:
	if event. is_action_pressed("down"):
		down = true
	elif event. is_action_released("down"):
		down = false
	elif event. is_action_pressed("up"):
		up = true
	elif event. is_action_released("up"):
		up = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_enemy(speed, delta)
	change_speed()
	while direction_x == 0:
		direction_x = randi_range(-1, 1)
		return
	while  direction_y == 0:
		direction_y = randi_range(-1, 1)
		return
		
	if up and $Player.position.y > 5:
		$Player.position.y -= speed * delta
	elif $Player.position.y < 5:
		$Player.position.y = 5

	if down and $Player.position.y < 477:
		$Player.position.y += speed * delta
	elif $Player.position.y > 477:
		$Player.position.y = 477
	
	# Enemy looser
	if $ball.position.x >= 1137:
		speed = 200
		player_points += 1
		restart()
	# Player looser
	elif $ball.position.x <= 5:
		speed = 200
		enemy_points += 1
		restart()
			
	
	if $ball.position.y <= 5:
		direction_y = 1
		$ball_sound.play()
	elif $ball.position.y >= 633:
		direction_y = -1
		$ball_sound.play()
	$ball.position.x += speed * direction_x * delta
	$ball.position.y += speed * direction_y * delta
	# Player catch ball
	if direction_x == -1 and $ball.position.x < 37 and $ball.position.x > 20 and $ball.position.y > $Player.position.y and $ball.position.y < $Player.position.y + 166:
		direction_x = 1
		$ball_sound.play()
	# enemy catch ball
	if direction_x == 1 and $ball.position.x > 1097 and $ball.position.y >= $enemy.position.y-5 and $ball.position.y <= $enemy.position.y + 166:
		direction_x = -1
		$ball_sound.play()




func change_speed():
	if changing_speed == false:
		changing_speed = true
		await get_tree().create_timer(5.0).timeout
		if settings == false:
			speed += 100
		changing_speed = false
		
func restart():
	direction_x = 0
	direction_y = 0
	$Panel/CenterContainer2/score_enemy.text = str(enemy_points)
	$Panel/CenterContainer/score_player.text = str(player_points)
	$ball.position.x = 558
	$ball.position.y = 240
	while direction_x == 0:
		direction_x = randi_range(-1, 1)
		return 
	while  direction_y == 0:
		direction_y = randi_range(-1, 1)
		return
	changing_speed = false
	change_speed()

func move_enemy(sped, delta):
	
	if $enemy.position.y > 477:
		$enemy.position.y = 477
	if $enemy.position.y < 5:
		$enemy.position.y = 5
	
	if $enemy.position.y > $ball.position.y:
		$enemy.position.y -= sped * delta
	elif $enemy.position.y + 145 < $ball.position.y:
		$enemy.position.y += sped * delta


func _on_button_pressed() -> void:
	settings = true
	current_speed = speed
	speed = 0
	$settings.visible = true
	$music.volume_db -= 10
