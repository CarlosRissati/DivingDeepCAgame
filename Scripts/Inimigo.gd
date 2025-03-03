extends CharacterBody2D

#Animação do inimigo
@onready var _animation_enemy = $AnimatedSprite2D
@onready var _Hitbox_enemy = $HitboxInimigo/CollisionShape2D
@onready var _nav_agent = $NavigationAgent2D
@onready var _timer = $Timer
@onready var _arma_direita = $ArmaDireita
@onready var _arma_esquerda = $ArmaEsquerda
var bullet = preload("res://Scenes/bullet.tscn")
var enemy_bullet: Texture2D = preload("res://Assets/enemybullet.png")
var dir
var attack_mode: bool
var wich_side: bool = true
var attack_cooldown: int = 20
var allow_attack: bool = true

const speed = 150

@export var player: Node2D

func _ready():
	_animation_enemy.play("Idle")

func _physics_process(_delta: float) -> void:
	if _nav_agent.is_target_reached() == true || _nav_agent.is_target_reachable() == false || _animation_enemy.animation == "Death":
		return
	# if is_instance_valid(target):
	dir = to_local(_nav_agent.get_next_path_position()).normalized()
	# _animation_enemy.play("Run")
	# else:
	# 	dir = 0
	velocity = dir * speed
	# if _nav_agent.is_target_reached() : 
	# 	velocity = Vector2(0,0)
	# 	print("parei")
	# 	_nav_agent.target_position = global_position
	# if _nav_agent.is_target_reachable() == false:
	# 	velocity = Vector2(0,0)
	# 	_nav_agent.target_position = global_position
		
	# print(velocity)
	move_and_slide()
	if (velocity.x > 0):
		_animation_enemy.flip_h = false
		if(_arma_direita.position.x < 0):
			_arma_direita.position.x *= -1

	if (velocity.x < 0):
		_animation_enemy.flip_h = true
		if (_arma_direita.position.x > 0):
			_arma_direita.position.x *= -1
	
	
	
	# print("direita: ", _arma_direita.global_position)
	# print("esquera: ", _arma_esquerda.global_position)

func attack() -> void:
	var bala = bullet.instantiate()
	get_parent().add_child(bala)
	bala.who_created = get_node(".")
	# bala.get_node("bullet_sprite").texture = enemy_bullet
	bala._texture.texture = enemy_bullet
	bala.global_position = wich_arm_is_using(wich_side)
	var direcao = (player.global_position - bala.global_position).normalized()
	bala.set_direcao(direcao)
	bala.rotation = direcao.angle()

func wich_arm_is_using(side: bool) -> Vector2:
	if side == true:
		wich_side = false
		return _arma_direita.global_position
	else:
		wich_side = true
		return _arma_esquerda.global_position

func makepath() -> void:
	_nav_agent.target_position = player.global_position
	# print(_nav_agent.target_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if _animation_enemy.animation == "Death":
		if _animation_enemy.frame == 7 && _animation_enemy.frame_progress >= 0.95:
			queue_free()
	
	if attack_cooldown == 0:
		allow_attack = true
		attack_cooldown = 40
	else:
		attack_cooldown -= 1
		allow_attack = false

	if attack_mode == true && allow_attack == true:
		attack()

func _on_area_2d_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	# print("Area Rid: ",area_rid,"\nArea: " ,area,"\nArea Shape Index: ", area_shape_index,"\nLocal Shape Index: ", local_shape_index)
	if area.name=="Bullet" && area.who_created.name != get_node(".").name:
		attack_mode = false
		# print("Bala papai!")
		_animation_enemy.play("Death")
		# _Hitbox_enemy.set_deferred("disabled", true)
		# _Hitbox_enemy.set_deferred("disabled", true)
		# await get_tree().process_frame



func _on_timer_timeout():
	makepath()


func _on_visao_body_entered(body):
	if body.name == "PlayerBody" && !_animation_enemy.animation == "Death":
		# _animation_enemy.stop()
		_animation_enemy.play("Shoot")
		print("entrou no ataque")
		_nav_agent.target_position = global_position
		_timer.paused = true
		attack_mode = true
		# player = body
	# 	if _timer.is_stopped() == true:
	# 		print("estartei timer")
	# 		_timer.start()
	# 	else:
	# 		_timer.paused = false
	# makepath()


func _on_visao_body_exited(body):
	if body.name == "PlayerBody" && !_animation_enemy.animation == "Death":
		_animation_enemy.play("Run")
		print("saiu do ataque")
		attack_mode = false
		_on_visao_moimento_body_entered(player)

	# if body.name == "PlayerBody" :
	# 	_timer.paused = true


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity


func _on_visao_moimento_body_entered(body:Node2D):
	if body.name == "PlayerBody" && !_animation_enemy.animation == "Death":
		player = body
		if _timer.is_stopped() == true:
			print("estartei timer")
			_timer.start()
		else:
			_timer.paused = false


func _on_visao_moimento_body_exited(body:Node2D):
	if body.name == "PlayerBody" :
		_timer.paused = true
