extends Node

signal state_changed

var game_state: Dictionary = {
    "player_name": "Driver",
    "score": 0,
    "best_time": 0.0,
    "current_level": "free_roam",
    "weather": "clear",
    "time_of_day": 12.0,
    "distance_traveled": 0.0
}

func _ready() -> void:
    load_state()

func save_state() -> void:
    var save_data = JSON.stringify(game_state)
    var path = "user://save_state.json"
    var file = FileAccess.open(path, FileAccess.WRITE)
    if file:
        file.store_string(save_data)
        file.close()
        emit_signal("state_changed")
    else:
        push_warning("Could not save game state")

func load_state() -> void:
    var path = "user://save_state.json"
    if not FileAccess.file_exists(path):
        return
    var file = FileAccess.open(path, FileAccess.READ)
    if file:
        var text = file.get_as_text()
        file.close()
        var parsed = JSON.parse_string(text)
        if typeof(parsed) == TYPE_DICTIONARY:
            game_state = parsed
            emit_signal("state_changed")

func set_state_value(key: String, value) -> void:
    game_state[key] = value
    save_state()

func get_state_value(key: String, default = null):
    return game_state.get(key, default)
