# Nuevo Proyecto de Juego (Godot 4.7)

Juego 2D: muévete con WASD o flechas, recoge corazones para sumar puntos y esquiva a los enemigos.

## Requisitos de la entrega
- **Tween:** el corazón flota arriba/abajo (`objeto_corazon.gd`, `flotar()`) y el jugador parpadea en rojo al recibir un golpe (`main.gd`, `parpadear_jugador()`).
- **Lógica del juego:** puntos (+10 por corazón), 3 vidas, cuenta regresiva de 60 s, pantalla de Game Over con botones **REINICIAR** y **MENÚ** (regresar al inicio).
- **Nivel 1 (fácil):** enemigos a velocidad 100, aparecen cada 2.5 s.
- **Nivel 2 (intermedio):** enemigos a velocidad 180, aparecen cada 1.5 s.

## Descargas
- **Modo ejecutable (macOS):** ver la sección *Releases* → `NuevoProyectoDeJuego.zip`.
- **Modo edición:** este repositorio (o `NuevoProyectoDeJuego_edicion.zip` en Releases). Abrir `project.godot` con Godot 4.7.
