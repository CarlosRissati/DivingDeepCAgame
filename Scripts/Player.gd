extends CharacterBody2D

#variaveis relacionadas ao player
const SPEED = 300.0
@onready var _animation_player = $AnimatedSprite2D

#Variaveis relacionadas a arma
var RELOAD_TIME: int = 80
var SHOOT_ANIMATION_SPEED
var cooldown: int = RELOAD_TIME
@onready var _gun = $Gun
@onready var _gun_animation = $Gun/AnimatedSprite2D
var gun_distance = 30.0
var bullet = preload("res://Scenes/bullet.tscn")
var can_shoot: bool = true

func _ready():
	SHOOT_ANIMATION_SPEED = _gun_animation.speed_scale

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
	
	if x != [0,0]:
		position.y += vertical * SPEED * delta
		position.x += horizontal * SPEED * delta
	move_and_slide()
	
	#Animação que irá rodar quando o jogador começar a se mover
	if (Input.is_action_pressed("move_down") or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		_animation_player.play("Run")
	else:
		_animation_player.play("Idle")
	if Input.is_action_just_pressed("move_left"):
		_animation_player.flip_h = true
	if Input.is_action_just_pressed("move_right"):
		_animation_player.flip_h = false

	if Input.is_key_pressed(KEY_F):
		get_tree().reload_current_scene()
	
	# arma rodando em volta do personagem
	var mouse_pos = get_global_mouse_position()
	var gun_direction = (mouse_pos - global_position).normalized()
	_gun.global_position = global_position + gun_direction * gun_distance
	_gun.rotation = gun_direction.angle()
	if _gun.rotation > 1.5 || _gun.rotation < -1.5:
		_gun_animation.flip_v = true
	else:
		_gun_animation.flip_v = false

	#Animação do tiro e sistema de tiro
	if Input.is_action_just_pressed("shoot") && can_shoot:
		can_shoot = false
		_gun_animation.play("Fired", SHOOT_ANIMATION_SPEED)
		var bala = bullet.instantiate()
		get_parent().add_child(bala)
		bala.global_position = _gun.global_position
		var direcao = (mouse_pos - bala.global_position).normalized()
		bala.set_direcao(direcao)
		bala.rotation = direcao.angle()
	
	if _gun_animation.frame == 3:
		_gun_animation.stop()
		can_shoot = true

