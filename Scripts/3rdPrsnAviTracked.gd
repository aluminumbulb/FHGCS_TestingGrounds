extends PathFollow3D

@export var initial_track: Path3D

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(initial_track, "3rdPrsnAviTrack did not initalize with a track")
	reparent(initial_track)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
