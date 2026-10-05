extends Node3D

var surface_types: Dictionary = {}
var road_nodes: Array = []
var decor_nodes: Array = []

func _ready() -> void:
    generate_world()

func generate_world() -> void:
    # Create base terrain
    var ground = MeshInstance3D.new()
    var plane = PlaneMesh.new()
    plane.size = Vector2(800, 800)
    ground.mesh = plane
    ground.name = "Terrain"
    add_child(ground)

    var ground_material = StandardMaterial3D.new()
    ground_material.albedo_color = Color(0.25, 0.36, 0.22)
    ground_material.roughness = 0.95
    ground_material.metallic = 0.0
    ground.mesh.surface_set_material(0, ground_material)

    # Create road network
    build_road(Vector3(0, 0.05, 0), Vector3(200, 0, 150), 26.0, "Main Loop")
    build_road(Vector3(-250, 0.05, 80), Vector3(300, 0, 60), 20.0, "West Route")
    build_road(Vector3(180, 0.05, 250), Vector3(200, 0, 80), 18.0, "North Route")
    build_road(Vector3(-100, 0.05, -200), Vector3(280, 0, 100), 22.0, "South Route")

    # Add scenery
    build_scenery()

func build_road(start: Vector3, size: Vector3, road_width: float, road_name: String) -> void:
    var road = MeshInstance3D.new()
    var box = BoxMesh.new()
    box.size = Vector3(size.x, 0.12, size.z)
    road.mesh = box
    road.name = road_name

    var road_mat = StandardMaterial3D.new()
    road_mat.albedo_color = Color(0.12, 0.12, 0.12)
    road_mat.roughness = 0.9
    road_mat.metallic = 0.05
    road.mesh.surface_set_material(0, road_mat)

    road.position = start
    add_child(road)

    # Add lane markings
    var line = MeshInstance3D.new()
    var line_mesh = BoxMesh.new()
    line_mesh.size = Vector3(0.15, 0.02, size.z * 0.8)
    line.mesh = line_mesh
    line.position = start + Vector3(0, 0.08, 0)
    line.name = road_name + "_lines"
    var line_mat = StandardMaterial3D.new()
    line_mat.albedo_color = Color(1.0, 0.9, 0.72)
    line.mesh.surface_set_material(0, line_mat)
    add_child(line)

    road_nodes.append(road)
    surface_types[road.name] = "asphalt"

func build_scenery() -> void:
    # Add trees
    for i in range(100):
        var tree = MeshInstance3D.new()
        var box = BoxMesh.new()
        box.size = Vector3(1.0, 4.0, 1.0)
        tree.mesh = box
        var random_pos = Vector3(randf_range(-350, 350), 2.0, randf_range(-350, 350))
        tree.position = random_pos
        tree.scale = Vector3(1, randf_range(0.8, 1.7), 1)
        tree.name = "Tree_" + str(i)
        
        var mat = StandardMaterial3D.new()
        mat.albedo_color = Color(0.16, 0.38, 0.14)
        mat.roughness = 0.95
        tree.mesh.surface_set_material(0, mat)
        add_child(tree)

    # Add buildings (simple cubes for now)
    for i in range(20):
        var building = MeshInstance3D.new()
        var box = BoxMesh.new()
        box.size = Vector3(randf_range(8, 16), randf_range(6, 12), randf_range(8, 16))
        building.mesh = box
        var random_pos = Vector3(randf_range(-300, 300), box.size.y / 2, randf_range(-300, 300))
        building.position = random_pos
        building.name = "Building_" + str(i)
        
        var mat = StandardMaterial3D.new()
        mat.albedo_color = Color(randf_range(0.4, 0.7), randf_range(0.4, 0.7), randf_range(0.4, 0.7))
        mat.roughness = 0.7
        building.mesh.surface_set_material(0, mat)
        add_child(building)
        decor_nodes.append(building)

func get_surface_type(pos: Vector3) -> String:
    # Simple terrain-road differentiation
    if pos.x > -120 and pos.x < 190 and pos.z > -90 and pos.z < 190:
        return "asphalt"
    if abs(pos.x) < 100 and pos.z > 160:
        return "asphalt"
    if abs(pos.z) < 90 and abs(pos.x) > 120:
        return "asphalt"
    if abs(pos.x) < 80 and abs(pos.z) < 80:
        return "grass"
    return "grass"
