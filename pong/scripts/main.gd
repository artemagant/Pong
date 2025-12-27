extends Node2D

var up:bool
var down:bool
const SPEED = 300
var direction_x:int
var direction_y:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction_x = randi_range(-1, 1)
	direction_y = randi_range(-1, 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	while direction_x == 0:
		direction_x = randi_range(-1, 1)
		return
	while  direction_y == 0:
		direction_y = randi_range(-1, 1)
	
	if up and $Player.position.y > 5:
		$Player.position.y -= SPEED * delta
	elif $Player.position.y < 5:
		$Player.position.y = 5

	if down and $Player.position.y < 477:
		$Player.position.y += SPEED * delta
	elif $Player.position.y > 477:
		$Player.position.y = 477
	
	if $ball.position.x >= 1137:
		direction_x = -1
	elif $ball.position.x <= 5:
		direction_x = 1
	if $ball.position.y <= 5:
		direction_y = 1
	elif $ball.position.y >= 633:
		direction_y = -1
	$ball.position.x += SPEED * direction_x * delta
	$ball.position.y += SPEED * direction_y * delta


func _on_left_button_mean_up_pressed() -> void:
	up = true
func _on_left_button_mean_up_released() -> void:
	up = false
func _on_right_button_mean_down_pressed() -> void:
	down = true
func _on_right_button_mean_down_released() -> void:
	down = false
