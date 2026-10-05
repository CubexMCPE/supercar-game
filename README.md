# Open World Supercar Game - Godot 4

A premium mobile open-world supercar driving game built with Godot 4.

## Features

- Realistic vehicle physics and handling
- Large open-world environment
- Multiple camera modes
- Day/night cycle ready
- Weather system ready
- Save/settings system
- Performance optimization
- Mobile-friendly controls

## Quick Start

### Installation

1. **Clone or download this repository**
   ```bash
   git clone https://github.com/CubexMCPE/supercar-game.git
   cd supercar-game
   ```

2. **Open in Godot 4**
   - Launch Godot 4.2 or later
   - Click "Import" or "Open Project"
   - Select the `supercar-game` folder
   - Click "Open & Edit"

3. **Run the game**
   - Press `F5` or click the Play button
   - The game will load and display the main scene

## Controls

### Keyboard (Desktop Testing)
- **W** - Accelerate
- **S** - Brake
- **A** - Steer Left
- **D** - Steer Right
- **Space** - Handbrake
- **C** - Cycle Camera Modes
- **ESC** - Pause/Resume

### Mobile (Touchscreen)
- Virtual steering wheel (configurable)
- Touch buttons for acceleration, braking, handbrake
- Gyro steering (optional, can be enabled in settings)

## Project Structure

```
supercar-game/
├── project.godot              # Godot project configuration
├── README.md                  # This file
├── scripts/
│   ├── Main.gd               # Main scene controller
│   ├── managers/
│   │   ├── GameManager.gd    # Game state and progression
│   │   ├── SettingsManager.gd # Settings and preferences
│   │   └── SaveManager.gd    # Save/load functionality
│   ├── vehicle/
│   │   └── Vehicle.gd        # Hero car physics and control
│   ├── camera/
│   │   └── VehicleCamera.gd  # Camera system with multiple modes
│   ├── ui/
│   │   └── HUD.gd            # Head-up display
│   └── world/
│       └── WorldGenerator.gd # World generation and terrain
├── scenes/
│   └── Main.tscn             # Main game scene
└── assets/                    # Placeholder for art assets
    ├── vehicles/
    ├── textures/
    ├── audio/
    └── models/
```

## Systems Overview

### Vehicle Physics
The game implements realistic physics including:
- Torque-based acceleration
- Gear ratios and transmission
- RPM management
- Surface-dependent grip (asphalt, grass, dirt, mud)
- Steering response curves
- Handbrake for drifting

### World Generation
Procedurally generated world with:
- Multiple road networks
- Terrain variation
- Building placement
- Tree scenery
- Surface type detection

### Camera System
8 different camera modes:
1. Third Person Close
2. Third Person Medium
3. Third Person Far
4. Hood Camera
5. Bumper Camera
6. Cockpit Camera
7. Interior Camera
8. Cinematic Camera

## Customization

### Vehicle Settings
Edit `scripts/vehicle/Vehicle.gd` to adjust:
- Engine power
- Brake power
- Top speed
- Steering strength
- Traction

### Graphics Settings
Edit `SettingsManager.gd` to customize:
- Graphics quality presets
- Volume levels
- Camera sensitivity
- UI scaling

### World Generation
Modify `WorldGenerator.gd` to:
- Change world size
- Add more roads
- Adjust scenery density
- Create custom terrain

## Asset Integration

To add your own assets:

### Hero Vehicle
1. Create or download a 3D model (GLB, GLTF, or FBX)
2. Place in `res://assets/vehicles/`
3. Update `Vehicle.gd`:
   ```gdscript
   func build_vehicle_body() -> void:
       var mesh_res = preload("res://assets/vehicles/your_car.glb")
       var mesh_instance = mesh_res.instantiate()
       add_child(mesh_instance)
   ```

### Textures
1. Place textures in `res://assets/textures/`
2. Reference in material assignments
3. Use StandardMaterial3D for realistic rendering

### Audio
1. Place audio files in `res://assets/audio/`
2. Supported formats: OGG, MP3, WAV
3. Add AudioStreamPlayer nodes to scenes

## Performance Tips

- Use LOD (Level of Detail) for distant objects
- Enable occlusion culling for buildings
- Optimize mesh polycount
- Use texture compression
- Monitor FPS with Godot's built-in profiler
- Adjust graphics settings for target device

## Troubleshooting

### Game won't start
- Ensure Godot 4.2+ is installed
- Check that all scripts have correct paths
- Look for errors in the Output console

### Low FPS on mobile
- Reduce graphics preset
- Decrease draw distance
- Lower vegetation density
- Disable traffic/weather effects

### Physics feel wrong
- Adjust gear ratios in Vehicle.gd
- Modify steering sensitivity in SettingsManager
- Check surface grip values in get_surface_grip()

## Future Features

- [ ] Multiple vehicle skins
- [ ] Dynamic weather system
- [ ] Day/night cycle
- [ ] Traffic AI
- [ ] Racing challenges
- [ ] Leaderboards
- [ ] Photo mode
- [ ] Damage system
- [ ] Customization garage
- [ ] Sound design system
- [ ] Multiplayer (optional)

## Credits

Built with [Godot Engine 4](https://godotengine.org/)

## License

MIT License - Feel free to use this project for personal or commercial purposes.

## Support

For issues, suggestions, or improvements, please open an issue on GitHub.

---

**Ready to drive? Download the project and start playing!**
