extends CharacterBody2D

@export var speed = 400

func get_input():
	var input_direccion=Input.get_vector("left","right","up","down")
	velocity =input_direccion*speed

func process_animation():
	if velocity.length()!=0:
		$AnimatedSprite2D.play("corriendo") # es como el estado del objeto
		if velocity.x<0:
			$AnimatedSprite2D.flip_h=true # mover de forma horizontal
		else:
			$AnimatedSprite2D.flip_h=false
	else:
		$AnimatedSprite2D.play("parado")


func _physics_process(delta: float) -> void:
	get_input()
	position.x=clamp(position.x,0,1200)
	position.y=clamp(position.y,0,800)
	process_animation()
	move_and_slide()
