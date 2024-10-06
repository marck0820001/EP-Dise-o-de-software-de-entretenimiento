extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimatedSprite2D")
@onready var area = get_node("Area2D")  # Nodo Area2D para detectar colisiones

func _ready() -> void:
	if area:
		# Conectar la señal 'body_entered' del Area2D para detectar colisiones
		area.connect("body_entered", Callable(self, "_on_body_entered"))
		print("Conexión exitosa para el Area2D del personaje: " + self.name)
	else:
		print("Error: No se encontró el nodo Area2D para " + self.name)

func _physics_process(delta: float) -> void:
	# Añadir gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Manejar salto con la tecla I
	if Input.is_action_just_pressed("jump_p2") and is_on_floor():  # Salto con I
		velocity.y = JUMP_VELOCITY

	# Manejar movimiento con las teclas J y L
	var direction = 0
	if Input.is_action_pressed("move_left_p2"):  # Moverse a la izquierda con J
		direction = -1
	elif Input.is_action_pressed("move_right_p2"):  # Moverse a la derecha con L
		direction = 1

	# Aplicar el movimiento
	if direction == -1:
		anim.flip_h = true  # Voltear el sprite cuando se mueve a la izquierda
	elif direction == 1:
		anim.flip_h = false  # No voltear el sprite cuando se mueve a la derecha

	if direction != 0:
		velocity.x = direction * SPEED
		anim.play("Run")
	else:
		anim.play("Idel")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# Función para detectar colisiones con otros personajes
func _on_body_entered(body):
	#print(self.name + " colisionó con " + body.name)
	if body.is_in_group("Players2"):  # Verificar que el cuerpo colisionado esté en el grupo "Player"
		print(self.name + " chocó con " + body.name)
