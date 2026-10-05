extends Node

var settings: Dictionary = {
    "graphics": "high",
    "master_volume": 0.8,
    "music_volume": 0.7,
    "sfx_volume": 0.75,
    "camera_sensitivity": 1.0,
    "steering_sensitivity": 1.0,
    "vibration": true,
    "gyro_enabled": false,
    "hud_size": 1.0,
    "touch_opacity": 0.8,
    "physics_quality": "realistic",
    "traffic_density": "medium",
    "weather_effects": true
}

func _ready() -> void:
    load_settings()

func save_settings() -> void:
    var data = JSON.stringify(settings)
    var file = FileAccess.open("user://settings.json", FileAccess.WRITE)
    if file:
        file.store_string(data)
        file.close()
    else:
        push_warning("Could not save settings")

func load_settings() -> void:
    var path = "user://settings.json"
    if not FileAccess.file_exists(path):
        return
    var file = FileAccess.open(path, FileAccess.READ)
    if file:
        var text = file.get_as_text()
        file.close()
        var parsed = JSON.parse_string(text)
        if typeof(parsed) == TYPE_DICTIONARY:
            settings.merge(parsed, true)

func get_setting(key: String, default = null):
    return settings.get(key, default)

func set_setting(key: String, value) -> void:
    settings[key] = value
    save_settings()
