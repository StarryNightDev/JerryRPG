extends CharacterBody3D

const SPEED = 3.0
const SPRINT_SPEED = 6.0
const JUMP_VELOCITY = 4.5

const IDLE_ANIMATION = 'jelly idle'
const WALK_ANIMATION = 'jelly walk'
const JUMP_ANIMATION = 'jelly jump'
const RUN_ANIMATION = 'jelly run'

@onready var animation_player: AnimationPlayer = $Jerry/Jelly_V1/AnimationPlayer
@onready var jerry: Node3D = $Jerry
@onready var camera_attach: Node3D = $CameraAttach

var isMoving = false
var wasSprinting = false
var isSprinting = false

func _ready() -> void:
	GameManager.set_player(self)
	animation_player.play(IDLE_ANIMATION)
	animation_player.set_blend_time(IDLE_ANIMATION, WALK_ANIMATION, 0.2)
	animation_player.set_blend_time(WALK_ANIMATION, IDLE_ANIMATION, 0.2)
	animation_player.set_blend_time(RUN_ANIMATION, WALK_ANIMATION, 0.2)
	animation_player.set_blend_time(RUN_ANIMATION, IDLE_ANIMATION, 0.2)
	animation_player.set_blend_time(IDLE_ANIMATION, RUN_ANIMATION, 0.2)
	animation_player.set_blend_time(WALK_ANIMATION, RUN_ANIMATION, 0.2)
	
	animation_player.set_blend_time(JUMP_ANIMATION, IDLE_ANIMATION, 0.2)
	animation_player.set_blend_time(IDLE_ANIMATION, JUMP_ANIMATION, 0.2)
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		animation_player.play(JUMP_ANIMATION)
		isMoving = false
		
	isSprinting = Input.is_action_pressed('sprint')
	var useSpeed = SPRINT_SPEED if wasSprinting else SPEED

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# Get the camera attaches rotation around the character to apply the proper movement direction (in direction of the camera)
	var applyRotation = camera_attach.basis.get_euler().y
	
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).rotated(Vector3.UP, applyRotation).normalized()
	if direction:
		velocity.x = direction.x * useSpeed
		velocity.z = direction.z * useSpeed
		
		jerry.look_at(-direction + position)
		
		if !isMoving:
			isMoving = true
			if !isSprinting:
				animation_player.play(WALK_ANIMATION)
				wasSprinting = false
			else:
				animation_player.play(RUN_ANIMATION)
				wasSprinting = true
		else:
			if isSprinting and !wasSprinting:
				wasSprinting = true
				animation_player.play(RUN_ANIMATION)
			if !isSprinting and wasSprinting:
				wasSprinting = false
				animation_player.play(WALK_ANIMATION)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if isMoving:
			isMoving = false
			wasSprinting = false
			animation_player.play(IDLE_ANIMATION)

	move_and_slide()
