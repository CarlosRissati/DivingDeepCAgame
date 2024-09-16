extends CharacterBody2D

const SPEED = 300.0
var RELOAD_TIME: int = 80
@onready var _animation_player = $AnimatedSprite2D
var SHOOT_ANIMATION_SPEED
@onready var _marker = $Marker2D
var can_move: bool = true
var bullet = preload("res://Scenes/bullet.tscn")
var can_shoot: bool = true
var cooldown: int = RELOAD_TIME

func _ready():
	_marker.global_position.x = position.x+24
	_marker.global_position.y = position.y+24
	SHOOT_ANIMATION_SPEED = _animation_player.speed_scale

func _process(delta):
	#cooldown do tiro
	if(cooldown == 0):
		can_shoot = true
		cooldown = RELOAD_TIME
	if(can_shoot == false):
		cooldown -= 1

	#movimentação do jogador
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
	
	#Animação que irá rodar quando o jogador começar a se mover
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
	
	#Animação do tiro e sistema de tiro
	if Input.is_action_just_pressed("shoot") && can_shoot:
		can_shoot = false
		can_move = false
		_animation_player.play("Shoot", SHOOT_ANIMATION_SPEED)
		var bala = bullet.instantiate()
		bala.position = _marker.global_position
		get_parent().add_child(bala)
	
	if _animation_player.frame == 3 && can_move == false:
		can_move = true

