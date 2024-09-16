extends CharacterBody2D

const SPEED = 300.0
var RELOAD_TIME: int = 80
@onready var _animation_player = $AnimatedSprite2D
@onready var _marker = $Marker2D
var can_move: bool = true
var bullet = preload("res://Scenes/bullet.tscn")
var can_shoot: bool = true
var cooldown: int = RELOAD_TIME

func _ready():
	_marker.global_position.x = position.x+24
	_marker.global_position.y = position.y+24

func _process(delta):
	if(cooldown == 0):
		can_shoot = true
		cooldown = RELOAD_TIME
	if(can_shoot == false):
		cooldown -= 1
	var horizontal = Input.get_axis("move_left", "move_right")
	var vertical = Input.get_axis("move_up", "move_down")
	var x: Array[int] = [horizontal, vertical]
	
	if x != [0,0] && can_move:
		position.y += vertical * SPEED * delta
		position.x += horizontal * SPEED * delta
	elif can_move:
		position.x += horizontal * SPEED * delta
		position.y += vertical * SPEED * delta
	move_and_slide()
	
	if (Input.is_action_pressed("move_down") or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")) and can_move:
		_animation_player.play("Run")
	elif can_move:
		_animation_player.play("Idle")
	if Input.is_action_just_pressed("move_left"):
		_animation_player.flip_h = true
		if(_marker.global_position.x == 24 + position.x):
			_marker.global_position.x -= 48
	if Input.is_action_just_pressed("move_right"):
		_animation_player.flip_h = false
		if(_marker.global_position.x == position.x - 24):
			_marker.global_position.x += 48
	
	if Input.is_action_just_pressed("shoot") && can_shoot:
		can_shoot = false
		_animation_player.play("Shoot")
		can_move = false
		var bala = bullet.instantiate()
		bala.position = _marker.global_position
		get_parent().add_child(bala)
	
	if _animation_player.frame == 3 && can_move == false:
		can_move = true
#func _input(event):
#	if event.is_action_pressed("move_down") || event.is_action_pressed("move_up"):
#		print("kkkkkkk")
#		_animation_player.play("Run")
#	else:
#		_animation_player.play("Idle")
