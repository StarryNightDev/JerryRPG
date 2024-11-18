extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var animation_player: AnimationPlayer = $Jerry/Jelly_V1/Armature/AnimationPlayer
@onready var jerry: Node3D = $Jerry
@onready var camera_attach: Node3D = $CameraAttach

var isMoving = false

func _ready() -> void:
	GameManager.set_player(self)
	animation_player.set_blend_time('idle', 'walk', 0.2)
	animation_player.set_blend_time('walk', 'idle', 0.2)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		jerry.look_at(direction + position)
		
		if !isMoving:
			isMoving = true
			animation_player.play('walk')
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if isMoving:
			isMoving = false
			animation_player.play('idle')

	move_and_slide()
