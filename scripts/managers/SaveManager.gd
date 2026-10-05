extends Node

func save_game() -> void:
    GameManager.save_state()
    SettingsManager.save_settings()
    print("Game saved successfully")

func load_game() -> void:
    GameManager.load_state()
    SettingsManager.load_settings()
    print("Game loaded successfully")
