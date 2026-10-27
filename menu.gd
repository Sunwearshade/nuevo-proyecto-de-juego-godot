extends Control

func _ready() -> void:
	$Button.pressed.connect(_on_nivel_pressed.bind(1))
	$Button2.pressed.connect(_on_nivel_pressed.bind(2))
	$Button.grab_focus()

func _on_nivel_pressed(nivel: int) -> void:
	Global.nivel = nivel
	get_tree().change_scene_to_file("res://Main.tscn")
