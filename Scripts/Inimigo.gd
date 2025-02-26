extends CharacterBody2D

#Animação do inimigo
@onready var _animation_enemy = $AnimatedSprite2D
@onready var _Hitbox_enemy = $HitboxInimigo/CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	_animation_enemy.play("Idle") 
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _animation_enemy.animation == "Death":
		if _animation_enemy.frame == 7 && _animation_enemy.frame_progress >= 0.95:
			queue_free()
	pass


func _on_area_2d_body_entered(body:Node2D):
	print(body.name)


func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print("Area Rid: ",area_rid,"\nArea: " ,area,"\nArea Shape Index: ", area_shape_index,"\nLocal Shape Index: ", local_shape_index)
	if area.name=="Bullet" :
		print("Bala papai!")
		_animation_enemy.play("Death")
		_Hitbox_enemy.set_deferred("disabled", true)

