extends Node
##Following tutorial: https://www.youtube.com/watch?v=eDdapSbPbtk
var mesh : MeshInstance3D
@export var size_depth := 20
@export var size_width := 20
@export var mesh_resolution:=2

var mat = preload("res://Materials/basic_floor.tres")

@export var noise: FastNoiseLite
@export var height_multiplier = 50

#TODO: Preload a single test prefab

# Called when the node enters the scene tree for the first time.
func _ready():
	generate()

func generate():
	#Creating "imaginary" mesh with desired dimensions
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(size_depth, size_width)
	plane_mesh.subdivide_depth = size_depth * mesh_resolution
	plane_mesh.subdivide_width = size_width * mesh_resolution
	plane_mesh.material = mat

	#Creates manager for mesh
	var st = SurfaceTool.new()
	st.create_from(plane_mesh,0)
	
	#Creating new Data Tool and feeding it surface data
	var data = MeshDataTool.new()
	var array_plane = st.commit()
	data.create_from_surface(array_plane, 0)
	
	#Iterating through every vertex in array
	for i in range(data.get_vertex_count()):
		var vertex = access_vertex(data.get_vertex(i)) 
		data.set_vertex(i, vertex)
	
	array_plane.clear_surfaces() #clear data from plane?
	
	#generate mesh and necessary values
	data.commit_to_surface(array_plane)
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.create_from(array_plane, 0)
	st.generate_normals()
	
	#Creates ACTUAL mesh from manager
	mesh = MeshInstance3D.new()
	mesh.mesh = st.commit()
	
	#Creates collision from mesh
	mesh.create_trimesh_collision()
	
	#Disallow shadow casting for this object (since it's geometry)
	mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	#Allowing mesh to be navagable by NavAgents
	mesh.add_to_group("NavSource")
	
	#instantiate
	add_child(mesh)
	
	## Primary Access point for verteces
	#Called from Generate
func access_vertex(vert: Vector3)->Vector3:
	#Generate Noise
	#vert.y = get_noise_y (vert.x, vert.z)
	
	return vert

func get_noise_y (x, z)->float:
	#gets data from our pre-loaded noise sample
	var nu_y = noise.get_noise_2d(x,z)
	#multiply to show effect
	nu_y *= height_multiplier
	#return new y coordinate
	return nu_y
	
