extends CharacterBody3D

const SPEED = 500.0
@export var ANG_SPEED = 1
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

enum moveTypes {EIGHT_DIR, TANK}
@export var currMoveType = moveTypes.EIGHT_DIR

@onready var camera = $SpringArm3D/Camera3D

func _ready():
	print(camera.basis)

func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta

	# Handle Jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	#matches to appropriate movement type
	match currMoveType:
		moveTypes.EIGHT_DIR:
			eight_dir_no_turn(delta)
		moveTypes.TANK:
			two_dir_tank_turn(delta)

	move_and_slide()

func get_input_dir_by_user_input(delta)->Vector3:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("uin-left", "uin-right", "uin-forward", "uin-back")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	return direction


func eight_dir_no_turn(delta):
	var inp_dir = get_input_dir_by_user_input(delta)

	if inp_dir:
		inp_dir = (basis * inp_dir)
		print(inp_dir)
		velocity.x = inp_dir.x
		velocity.z = inp_dir.z
		pass
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		velocity.z = move_toward(velocity.z, 0, SPEED * delta)

func two_dir_tank_turn(delta):
	var inp_dir = get_input_dir_by_user_input(delta)
	if inp_dir:
		velocity = basis.z * inp_dir.z
		#mostly using inp_dir.x as a signal more than a value
		rotation.y -= inp_dir.x * ANG_SPEED * delta
	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		velocity.z = move_toward(velocity.z, 0, SPEED * delta)
