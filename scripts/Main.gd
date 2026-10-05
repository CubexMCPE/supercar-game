extends Node3D

var world: Node3D
var vehicle: CharacterBody3D
var camera_rig: Camera3D
var hud: CanvasLayer

func _ready() -> void:
    # Load game data
    SaveManager.load_game()

    # Build world
    world = preload("res://scripts/world/WorldGenerator.gd").new()
    world.name = "World"
    add_child(world)

    # Build vehicle
    vehicle = preload("res://scripts/vehicle/Vehicle.gd").new()
    vehicle.name = "PlayerCar"
    add_child(vehicle)
    vehicle.global_position = Vector3(0.0, 2.5, 30.0)
    vehicle.rotation.y = PI

    # Create HUD
    hud = preload("res://scripts/ui/HUD.gd").new()
    hud.name = "HUD"
    add_child(hud)

    # Create camera
    camera_rig = preload("res://scripts/camera/VehicleCamera.gd").new()
    camera_rig.target_car = vehicle
    camera_rig.name = "VehicleCamera"
    add_child(camera_rig)

    # Setup environment
    setup_environment()

    print("Game loaded successfully!")

func setup_environment() -> void:
    # World environment
    var env = WorldEnvironment.new()
    var environment = Environment.new()
    environment.background_mode = Environment.BG_COLOR
    environment.background_color = Color(0.6, 0.75, 0.9)
    environment.ambient_light_color = Color(1.0, 1.0, 1.0)
    environment.ambient_light_energy = 1.0
    env.environment = environment
    add_child(env)

    # Sunlight
    var sunlight = DirectionalLight3D.new()
    sunlight.rotation_degrees = Vector3(-40, 30, 0)
    sunlight.light_energy = 1.5
    sunlight.shadow_enabled = true
    sunlight.shadow_blur = 1
    sunlight.directional_shadow_split_1 = 0.1
    add_child(sunlight)

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("pause"):
        get_tree().paused = !get_tree().paused
        print("Game paused: ", get_tree().paused)

    if Input.is_action_just_pressed("camera_toggle"):
        camera_rig.cycle_camera_mode()
