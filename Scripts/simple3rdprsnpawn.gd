extends CharacterBody3D

const SPEED = 500.0
@export var ANG_SPEED = 1
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#Defining Movement Types
enum moveTypes {EIGHT_DIR, TANK}
@export var currMoveType = moveTypes.EIGHT_DIR

#Defining Rotation Types
enum rotTypes {KEYS, MOUSE}
@export var currRotationType = rotTypes.KEYS

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta

	# Handle Jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	#Translation Methods
	#matches to appropriate movement type
	match currMoveType:
		moveTypes.EIGHT_DIR:
			eight_dir(delta)
		moveTypes.TANK:
			two_dir_tank(delta)
	
	#Rotation Methods
	match currRotationType:
		rotTypes.KEYS:
			key_based_rotation(delta)
		rotTypes.MOUSE:
			mouse_based_rotation(delta)
	
	#End of Velocity Changes
	move_and_slide()
	
## Returns an input vector for 4 input directions, normalized 
func get_input_dir_by_user_input()->Vector3:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("uin-left", "uin-right", "uin-forward", "uin-back")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	return direction

##Defines Translation
func eight_dir(delta):
	var inp_dir = get_input_dir_by_user_input()

	if inp_dir:
		inp_dir = (basis * inp_dir)
		print(inp_dir)
		velocity.x = inp_dir.x
		velocity.z = inp_dir.z
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		velocity.z = move_toward(velocity.z, 0, SPEED * delta)

##Defines translation changes in two directions
func two_dir_tank(delta):
	var inp_dir = get_input_dir_by_user_input()
	
	if inp_dir:
		velocity = basis.z * inp_dir.z
	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		velocity.z = move_toward(velocity.z, 0, SPEED * delta)

##Defines mouse based rotation
func mouse_based_rotation(delta):
	var mouse_vel = Input.get_last_mouse_velocity() #causes lagging
	if mouse_vel.x>0:
		rotation.y -= ANG_SPEED * delta
	elif mouse_vel.x<0:
		rotation.y += ANG_SPEED * delta

##Defines 2-direction based rotation
func key_based_rotation(delta):
	var inp_dir = get_input_dir_by_user_input()
	rotation.y -= inp_dir.x * ANG_SPEED * delta
