extends CanvasLayer

var speed_label: Label
var rpm_label: Label
var gear_label: Label
var state_label: Label
var speed_value: float = 0.0
var rpm_value: float = 0.0
var gear_value: int = 1

func _ready() -> void:
    build_hud()

func build_hud() -> void:
    # Main info panel
    var panel = Panel.new()
    panel.position = Vector2(20, 20)
    panel.size = Vector2(320, 160)
    panel.modulate = Color(0.1, 0.1, 0.1, 0.75)
    add_child(panel)

    # Speed display
    speed_label = Label.new()
    speed_label.position = Vector2(40, 32)
    speed_label.add_theme_font_size_override("font_size", 42)
    speed_label.text = "0"
    speed_label.add_theme_color_override("font_color", Color.WHITE)
    panel.add_child(speed_label)

    # Speed unit
    var speed_unit = Label.new()
    speed_unit.position = Vector2(140, 35)
    speed_unit.add_theme_font_size_override("font_size", 16)
    speed_unit.text = "KM/H"
    speed_unit.add_theme_color_override("font_color", Color.WHITE)
    panel.add_child(speed_unit)

    # RPM display
    rpm_label = Label.new()
    rpm_label.position = Vector2(40, 85)
    rpm_label.add_theme_font_size_override("font_size", 18)
    rpm_label.text = "RPM: 900"
    rpm_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
    panel.add_child(rpm_label)

    # Gear display
    gear_label = Label.new()
    gear_label.position = Vector2(40, 115)
    gear_label.add_theme_font_size_override("font_size", 18)
    gear_label.text = "GEAR: 1"
    gear_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
    panel.add_child(gear_label)

    # State label (top right)
    state_label = Label.new()
    state_label.position = Vector2(1400, 32)
    state_label.add_theme_font_size_override("font_size", 20)
    state_label.text = "FREE ROAM"
    state_label.add_theme_color_override("font_color", Color.WHITE)
    add_child(state_label)

func _process(_delta: float) -> void:
    var vehicle = get_parent().get_node_or_null("PlayerCar")
    if vehicle == null:
        return

    speed_value = vehicle.get_speed_kmh()
    rpm_value = vehicle.get_engine_rpm()
    gear_value = vehicle.get_gear()

    speed_label.text = str(int(speed_value))
    rpm_label.text = "RPM: " + str(int(rpm_value))
    gear_label.text = "GEAR: " + str(gear_value)
