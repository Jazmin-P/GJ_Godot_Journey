extends CharacterBody3D

@onready var forward := $RayForward
@onready var back := $RayBack
@onready var left := $RayLeft
@onready var right := $RayRight

const speed = 10
const gravity = 9

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	move_and_slide()
	
var sensitivity = 250

func _input(event):  		
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / sensitivity
		
		$Camera3D.rotation.x -= event.relative.y / sensitivity
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, deg_to_rad(-45), deg_to_rad(90)) 
