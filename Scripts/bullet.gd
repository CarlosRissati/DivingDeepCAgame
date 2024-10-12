extends Area2D

@export var speed = 700

var direcao = Vector2.ZERO

func _process(delta):
	position += direcao * speed * delta
	pass

func set_direcao(nova_direcao):
	direcao = nova_direcao

func _on_visible_on_screen_notifier_2d_screen_exited():
	print("Sai da tela")
	queue_free()


func _on_body_entered(body):
	if !body.name == "PlayerBody":
		queue_free()
	
