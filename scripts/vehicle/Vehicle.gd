extends CharacterBody3D

@export var engine_power: float = 3200.0
@export var brake_power: float = 2600.0
@export var top_speed_kmh: float = 260.0
@export var steer_strength: float = 1.2
@export var wheelbase: float = 2.7
@export var traction: float = 1.0

var gear_ratios: Array = [0.0, 2.7, 2.2, 1.7, 1.3, 1.0, 0.82]
var gear: int = 1
var gear_shift_timer: float = 0.0
var engine_rpm: float = 900.0
var max_rpm: float = 7800.0
var steering_input: float = 0.0
var throttle_input: float = 0.0
var brake_input: float = 0.0
var handbrake_input: float = 0.0
var speed_kmh: float = 0.0
var world_ref: Node3D

var car_mesh: MeshInstance3D
var chassis_material: StandardMaterial3D
var wheels: Array = []

func _ready() -> void:
    set_meta("is_vehicle", true)
    build_vehicle_body()
    world_ref = get_parent()

func build_vehicle_body() -> void:
    # Main chassis
    car_mesh = MeshInstance3D.new()
    var box = BoxMesh.new()
    box.size = Vector3(2.0, 0.7, 4.8)
    car_mesh.mesh = box
    car_mesh.name = "Chassis"

    chassis_material = StandardMaterial3D.new()
    chassis_material.albedo_color = Color(0.85, 0.0, 0.0)
    chassis_material.metallic = 0.8
    chassis_material.roughness = 0.35
    chassis_material.clearcoat_enabled = true
    chassis_material.clearcoat = 0.8
    car_mesh.mesh.surface_set_material(0, chassis_material)

    add_child(car_mesh)

    # Wheels (visual placeholders)
    var wheel_positions = [
        Vector3(-1.1, -0.5, 1.35),   # Front left
        Vector3(-1.1, -0.5, -1.35),  # Rear left
        Vector3(1.1, -0.5, 1.35),    # Front right
        Vector3(1.1, -0.5, -1.35)    # Rear right
    ]

    for i in range(4):
        var wheel = MeshInstance3D.new()
        var wheel_mesh = CylinderMesh.new()
        wheel_mesh.top_radius = 0.33
        wheel_mesh.bottom_radius = 0.33
        wheel_mesh.height = 0.28
        wheel.mesh = wheel_mesh
        wheel.rotation_degrees = Vector3(90, 0, 0)
        wheel.position = wheel_positions[i]
        wheel.name = "Wheel_" + str(i)

        var wheel_mat = StandardMaterial3D.new()
        wheel_mat.albedo_color = Color(0.08, 0.08, 0.08)
        wheel_mat.roughness = 0.95
        wheel.mesh.surface_set_material(0, wheel_mat)

        add_child(wheel)
        wheels.append(wheel)

func _physics_process(delta: float) -> void:
    update_inputs()

    var forward = -transform.basis.z
    var right = transform.basis.x

    var surface_grip = get_surface_grip()
    var drag = 2.6
    var rolling_drag = 0.8
    var steer_rate = 1.25 * (0.5 + min(speed_kmh / 160.0, 1.0))

    # Steering
    var steer_amount = steering_input * steer_strength * steer_rate * delta
    rotate_y(steer_amount)

    # Automatic transmission
    update_gear_from_speed()

    # Acceleration and braking
    var gear_ratio = gear_ratios[gear]
    var forward_speed = velocity.dot(forward)
    var current_speed_kmh = forward_speed * 3.6

    var desired_force = 0.0
    if throttle_input > 0.0:
        desired_force = throttle_input * engine_power * gear_ratio * (1.0 - clamp(abs(current_speed_kmh) / top_speed_kmh, 0.0, 0.95))
    
    if brake_input > 0.0:
        desired_force -= brake_input * brake_power * (1.0 - min(abs(current_speed_kmh) / 160.0, 0.75))

    if handbrake_input > 0.0:
        desired_force *= 0.55
        velocity -= right * (velocity.dot(right) * 0.15)

    # Forward drive
    velocity += forward * desired_force * delta * 0.08

    # Road grip and lateral damping
    var lateral_velocity = velocity.dot(right)
    velocity -= right * lateral_velocity * (1.0 - surface_grip) * delta * 3.5

    # Drag and rolling resistance
    velocity *= 1.0 - drag * delta * 0.02
    velocity -= forward * sign(forward_speed) * min(abs(forward_speed) * rolling_drag * delta, abs(forward_speed))

    # Speed clamp
    var speed_limit = top_speed_kmh * 0.95
    if abs(velocity.length()) > (speed_limit / 3.6):
        velocity = velocity.normalized() * (speed_limit / 3.6)

    # Body movement
    var body_bob = 0.05 + abs(forward_speed) * 0.002
    position.y = lerp(position.y, 1.0 + body_bob * sin(Time.get_ticks_msec() * 0.01), delta * 2.5)

    move_and_slide()

    # Update speed and RPM
    speed_kmh = abs(velocity.length() * 3.6)
    engine_rpm = clamp(950.0 + speed_kmh * 65.0 + throttle_input * 3500.0, 900.0, max_rpm)

    # Update wheel rotation
    for wheel in wheels:
        wheel.rotation.x += (speed_kmh * 0.03) * delta * 60.0

func update_inputs() -> void:
    throttle_input = Input.get_action_strength("accelerate")
    brake_input = Input.get_action_strength("brake")
    handbrake_input = Input.get_action_strength("handbrake")
    steering_input = Input.get_action_strength("steer_right") - Input.get_action_strength("steer_left")

func update_gear_from_speed() -> void:
    if speed_kmh < 15:
        gear = 1
    elif speed_kmh < 35:
        gear = 2
    elif speed_kmh < 60:
        gear = 3
    elif speed_kmh < 100:
        gear = 4
    elif speed_kmh < 150:
        gear = 5
    else:
        gear = 6

func get_surface_grip() -> float:
    if world_ref == null:
        return 1.0

    var surface = world_ref.get_surface_type(global_position)
    match surface:
        "asphalt":
            return 1.0
        "grass":
            return 0.7
        "dirt":
            return 0.78
        "mud":
            return 0.55
        _:
            return 0.82

func get_speed_kmh() -> float:
    return speed_kmh

func get_engine_rpm() -> float:
    return engine_rpm

func get_gear() -> int:
    return gear
