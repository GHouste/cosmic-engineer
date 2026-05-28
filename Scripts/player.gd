extends CharacterBody3D

@onready var neck = $neck
@onready var camera = $neck/Camera3D

const base_speed = 5.0
const run_speed = 10.0
const JUMP_VELOCITY = 4.5
const stamina_cap = 100

var is_running = false
var stamina = 100

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("esc"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60),deg_to_rad(60))
			
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_pressed("running"):
		is_running = true
	else:
		is_running = false
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if not is_running:
		if direction:
			velocity.x = direction.x * base_speed
			velocity.z = direction.z * base_speed
		else:
			velocity.x = move_toward(velocity.x, 0, base_speed)
			velocity.z = move_toward(velocity.z, 0, base_speed)
	
	if is_running and stamina > 0:
		if direction:
			velocity.x = direction.x * run_speed
			velocity.z = direction.z * run_speed
		else:
			velocity.x = move_toward(velocity.x, 0, run_speed)
			velocity.z = move_toward(velocity.z, 0, run_speed)	
	
	move_and_slide()
