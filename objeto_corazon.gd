extends Area2D

signal recogido

@export var puntos = 10

func _ready() -> void:
	add_to_group("objetos")
	body_entered.connect(_on_body_entered)
	$AnimatedSprite2D.play("latido")
	flotar()

# Tween: el corazon sube y baja sin parar
func flotar() -> void:
	var tween = create_tween().set_loops()
	tween.tween_property($AnimatedSprite2D, "position:y", -15.0, 0.6)
	tween.tween_property($AnimatedSprite2D, "position:y", 0.0, 0.6)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		recogido.emit(puntos)
		queue_free()
