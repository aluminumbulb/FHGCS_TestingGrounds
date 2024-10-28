extends PathFollow3D

@export var initial_track: Path3D
@export var key_based_move_speed:=1
@export var max_speed:=500
@export var static_friction_force:=.5 ##The point where the cart simply stops
@export var deceleration:=.3 ##Amount of deceleration relative to mouse velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(initial_track, "3rdPrsnAviTrack did not initalize with a track")
	initial_track.reparent(get_parent())
	change_track(initial_track)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	directional_input()
	pass

##function defining how far this actor moves along the current path
func move_along_path(amt: float):
	amt = clamp(amt, -max_speed, max_speed)
	progress += amt
	
##Controls progress along track mimicking the effect of movement
func momentum_calc(pho_vel: float):
	#Decelerate over time scaled in proper direction
	if(pho_vel>static_friction_force):
		move_along_path(pho_vel)
		pho_vel-=deceleration
	
	elif(pho_vel<(-static_friction_force) ):	
		move_along_path(pho_vel)
		pho_vel+=deceleration

	#Stop the coffin if in stopping range
	else:
		move_along_path(0)
		pho_vel = 0

## Returns an input vector for 4 input directions, normalized 
func get_input_dir_by_user_input()->Vector3:
	var input_dir = Input.get_vector("uin-left", "uin-right", "uin-forward", "uin-back")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	return direction

##Actually takes user input and translates this object
func directional_input():
	var direction = get_input_dir_by_user_input()
	var vel = direction.z * key_based_move_speed
	momentum_calc(vel)
	
func change_track(nu_track):
	reparent(nu_track)
