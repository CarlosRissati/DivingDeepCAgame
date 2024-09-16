extends Area2D

@export var speed = 700

var target = null
var angle = null

func _ready():
	target = get_global_mouse_position()
	angle = get_angle_to(target)
	look_at(target)

func _process(delta):
	#if Input.is_action_pressed("mouse_left_click"):	
	#position += (Vector2.from_angle(get_angle_to(target))*speed) * delta
	position += (Vector2.from_angle(angle)*speed)*delta

func _physics_process(delta):
	set_physics_process(false)


func _on_visible_on_screen_notifier_2d_screen_exited():
	print("Sai da tela")
	queue_free()


func _on_body_entered(body):
	if !body.name == "PlayerBody":
		queue_free()
	
