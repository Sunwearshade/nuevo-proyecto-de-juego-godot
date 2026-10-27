extends Node2D

const ENEMIGO = preload("res://Enemigo.tscn")
const OBJETO = preload("res://ObjetoCorazon.tscn")

@export var duracion = 60 # segundos de partida
@export var vidas_iniciales = 3

var score = 0
var vidas = 0
var tiempo = 0
var terminado = false
var velocidad_enemigo = 100

@onready var jugador = $Jugador
@onready var label_score = $Node/MarginContainer/SCORE
@onready var label_vidas = $Node/MarginContainer/VIDAS
@onready var label_timer = $Node/MarginContainer/TIMER
@onready var panel_game_over = $Node/MarginContainer/PanelGameOver
@onready var label_game_over = $"Node/MarginContainer/PanelGameOver/GAME OVER"
@onready var boton_reiniciar = $Node/MarginContainer/PanelGameOver/REINICIAR
@onready var boton_menu = $Node/MarginContainer/PanelGameOver/MENU
@onready var game_timer_1 = $GameTimer1 # cuenta regresiva (cada 1 s)
@onready var game_timer_2 = $GameTimer2 # aparece enemigos y objetos

func _ready() -> void:
	randomize()
	tiempo = duracion
	vidas = vidas_iniciales
	# Nivel 1 = facil, Nivel 2 = intermedio (enemigos mas rapidos y frecuentes)
	if Global.nivel == 1:
		velocidad_enemigo = 100
		game_timer_2.wait_time = 2.5
	else:
		velocidad_enemigo = 180
		game_timer_2.wait_time = 1.5
	panel_game_over.hide()
	actualizar_hud()
	game_timer_1.timeout.connect(_on_game_timer_1_timeout)
	game_timer_2.timeout.connect(_on_game_timer_2_timeout)
	boton_reiniciar.pressed.connect(_on_reiniciar_pressed)
	boton_menu.pressed.connect(_on_menu_pressed)
	game_timer_1.start()
	game_timer_2.start()

func actualizar_hud() -> void:
	label_score.text = "PUNTOS: %d" % score
	label_vidas.text = "VIDAS: %d" % vidas
	label_timer.text = "NIVEL %d   TIEMPO: %d" % [Global.nivel, tiempo]

func _on_game_timer_1_timeout() -> void:
	tiempo -= 1
	actualizar_hud()
	if tiempo <= 0:
		game_over("¡SE ACABÓ EL TIEMPO!")

func _on_game_timer_2_timeout() -> void:
	aparecer_enemigo()
	aparecer_objeto()

func aparecer_enemigo() -> void:
	var tam = get_viewport_rect().size
	var enemigo = ENEMIGO.instantiate()
	# aparece en una orilla al azar de la pantalla
	match randi() % 4:
		0: enemigo.position = Vector2(randf() * tam.x, -50)
		1: enemigo.position = Vector2(randf() * tam.x, tam.y + 50)
		2: enemigo.position = Vector2(-50, randf() * tam.y)
		3: enemigo.position = Vector2(tam.x + 50, randf() * tam.y)
	enemigo.objetivo = jugador
	enemigo.velocidad = velocidad_enemigo
	enemigo.golpeo_jugador.connect(_on_enemigo_golpeo_jugador.bind(enemigo))
	add_child(enemigo)

func aparecer_objeto() -> void:
	var tam = get_viewport_rect().size
	var objeto = OBJETO.instantiate()
	objeto.position = Vector2(randf_range(80, tam.x - 80), randf_range(120, tam.y - 80))
	objeto.recogido.connect(_on_objeto_recogido)
	add_child(objeto)

func _on_objeto_recogido(puntos: int) -> void:
	if terminado:
		return
	$SonidoPunto.play()
	score += puntos
	actualizar_hud()

func _on_enemigo_golpeo_jugador(enemigo: Node) -> void:
	if terminado:
		return
	$SonidoGolpe.play()
	enemigo.queue_free() # el enemigo desaparece al quitar la vida
	vidas -= 1
	actualizar_hud()
	if vidas <= 0:
		game_over("GAME OVER")
	else:
		parpadear_jugador()

func parpadear_jugador() -> void:
	# el jugador se pone rojo un momento para avisar del golpe
	var tween = create_tween()
	tween.tween_property(jugador, "modulate", Color(1, 0.3, 0.3), 0.1)
	tween.tween_property(jugador, "modulate", Color.WHITE, 0.3)

func game_over(mensaje: String) -> void:
	if terminado:
		return
	terminado = true
	game_timer_1.stop()
	game_timer_2.stop()
	get_tree().call_group("enemigos", "set_physics_process", false)
	jugador.set_physics_process(false)
	jugador.get_node("AnimatedSprite2D").play("dead")
	label_game_over.text = "%s\nPUNTOS: %d" % [mensaje, score]
	$Musica.stop()
	$SonidoGameOver.play()
	panel_game_over.show()
	boton_reiniciar.grab_focus()

func _on_reiniciar_pressed() -> void:
	get_tree().reload_current_scene()

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu.tscn")
