extends CharacterBody2D

#Animação do inimigo
@onready var _animation_enemy = $AnimatedSprite2D
@onready var _Hitbox_enemy = $HitboxInimigo/CollisionShape2D
@onready var _nav_agent = $NavigationAgent2D
@onready var _timer = $Timer

const speed = 150

@export var player: Node2D

func _ready():
	_animation_enemy.play("Idle")

func _physics_process(_delta: float) -> void:
	var dir = to_local(_nav_agent.get_next_path_position()).normalized()
	velocity = dir * speed
	if _nav_agent.is_target_reached() : 
		velocity = Vector2(0,0)
		_nav_agent.target_position = global_position
		
	# print(velocity)
	move_and_slide()

func makepath() -> void:
	_nav_agent.target_position = player.global_position
	# print(_nav_agent.target_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if _animation_enemy.animation == "Death":
		if _animation_enemy.frame == 7 && _animation_enemy.frame_progress >= 0.95:
			queue_free()
	pass

func _on_area_2d_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	# print("Area Rid: ",area_rid,"\nArea: " ,area,"\nArea Shape Index: ", area_shape_index,"\nLocal Shape Index: ", local_shape_index)
	if area.name=="Bullet" :
		print("Bala papai!")
		_animation_enemy.play("Death")
		_Hitbox_enemy.set_deferred("disabled", true)



func _on_timer_timeout():
	makepath()


func _on_visao_body_entered(body):
	if body.name == "PlayerBody":
		player = body
		if _timer.is_stopped() == true:
			print("estartei timer")
			_timer.start()
		else:
			_timer.paused = false
	# makepath()


func _on_visao_body_exited(body):
	if body.name == "PlayerBody" :
		_timer.paused = true


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
