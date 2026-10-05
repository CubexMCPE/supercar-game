extends Camera3D

var target_car: Node3D
var camera_mode: int = 0
var target_position: Vector3 = Vector3.ZERO
var current_distance: float = 6.0
var current_height: float = 2.0

var modes = [
    Vector3(0.0, 2.4, 6.0),   # Third person close
    Vector3(0.0, 2.8, 8.5),   # Third person medium
    Vector3(0.0, 3.4, 12.0),  # Third person far
    Vector3(0.0, 0.8, 1.8),   # Hood
    Vector3(0.0, 0.6, 2.4),   # Bumper
    Vector3(0.0, 1.3, 0.1),   # Cockpit
    Vector3(0.0, 2.2, 0.2),   # Interior
    Vector3(0.0, 4.0, 9.0)    # Cinematic
]

var mode_names = [
    "Third Person Close",
    "Third Person Medium",
    "Third Person Far",
    "Hood",
    "Bumper",
    "Cockpit",
    "Interior",
    "Cinematic"
]

func _ready() -> void:
    current = true
    if target_car == null:
        target_car = get_parent().get_node_or_null("PlayerCar")

func _process(delta: float) -> void:
    if target_car == null:
        return

    var base_offset = modes[camera_mode]
    var speed_factor = clamp(target_car.velocity.length() / 35.0, 0.0, 1.4)

    var world_offset = target_car.global_transform.basis.x * base_offset.x
    world_offset += target_car.global_transform.basis.y * (base_offset.y + speed_factor * 0.5)
    world_offset += target_car.global_transform.basis.z * base_offset.z

    target_position = target_car.global_position + world_offset
    global_position = global_position.lerp(target_position, delta * 5.0)

    var look_target = target_car.global_position + Vector3(0, 1.2, 0)
    look_at(look_target, Vector3.UP, true)

func cycle_camera_mode() -> void:
    camera_mode = (camera_mode + 1) % modes.size()
    print("Camera mode: ", mode_names[camera_mode])
