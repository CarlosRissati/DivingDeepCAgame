extends Area2D

@onready var _texture = $bullet_sprite
@export var speed = 700
@export var acelleration = 10
var who_created: Node2D

var direcao = Vector2.ZERO

func _process(delta):
	position += direcao * speed * delta


func set_direcao(nova_direcao):
	direcao = nova_direcao

func _on_visible_on_screen_notifier_2d_screen_exited():
	print("Sai da tela")
	queue_free()


func _on_body_entered(body):
	# if !body.name == "PlayerBody":
	if is_instance_valid(who_created) && !body.name == who_created.name:
		queue_free()
	


func _on_area_shape_entered(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int):
	if area.name == "HitboxInimigo" && is_instance_valid(who_created) && who_created.name != "EnemyBody":
	# if area.name == who_created:
		# print("balapapai")
		queue_free()
	pass # Replace with function body.
