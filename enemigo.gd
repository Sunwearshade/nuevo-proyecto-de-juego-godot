extends Area2D

signal golpeo_jugador

@export var velocidad = 100

var objetivo: Node2D # el jugador al que persigue (lo asigna Main)

func _ready() -> void:
	add_to_group("enemigos")
	body_entered.connect(_on_body_entered)
	$AnimatedSprite2D.play("caminar")

func _physics_process(delta: float) -> void:
	if objetivo == null:
		return
	var direccion = (objetivo.global_position - global_position).normalized()
	position += direccion * velocidad * delta
	$AnimatedSprite2D.flip_h = direccion.x < 0 # voltear segun hacia donde camina

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		golpeo_jugador.emit()
