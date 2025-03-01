extends Node2D

func _on_area_2d_body_entered(body):
	if body.name == "PlayerBody":
		body.RELOAD_TIME = body.RELOAD_TIME/2
		body.SHOOT_ANIMATION_SPEED = body.SHOOT_ANIMATION_SPEED*2
		queue_free()
