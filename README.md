# Signals of Earth (Ludum Dare 59)

In the silence of orbit, every signal matters.

`Signals of Earth` is a sci-fi control-room game built for Ludum Dare 59. You operate the Vanguard Orbital Link Station under Protocol Yugen: keep satellite links synchronized, maintain steady data transmission, and secure the network by intercepting alien threats before they collapse the system.

The original concept was broader, but the shipped gameplay is intentionally focused and fast: monitor the signal console, tune link parameters, react to attacks, and prevent data loss.

## Game Links

- Ludum Dare page: [LD 59 entry](https://ldjam.com/events/ludum-dare/59/ld-59)
- itch.io page: [Signals of Earth](https://imtec.itch.io/ludum-dare-59)

## Gameplay and Controls

You interact with an in-world space-station console projected on the main cockpit screen.

- **Console controls (mouse):**
  - Use sliders to tune frequency and amplitude.
  - Use buttons to connect/purge and react to events.
- **Camera pan (mouse):**
  - Hold **Right Mouse Button** and move the mouse to pan the view.
- **Camera tilt (keyboard):**
  - Press **A** and **D** to tilt/rotate view left and right.

Goal loop:

1. Keep your station signal aligned with the active satellite.
2. Preserve synchronization long enough to transmit data.
3. Respond to attack states quickly to avoid cascading data loss.

## Code Architecture

The project follows a lightweight event-driven architecture with clear separation between game-domain logic and scene/controllers.

### High-level structure

- `src/game/`
  - Core domain logic (models, events, factory).
  - Pure gameplay rules and state transitions.
- `src/controller/`
  - Scene and UI controllers (3D world, UI widgets, camera, screen input bridge).
  - React to player input and update visuals/audio.
- `src/shared/utils/`
  - Random data/signal providers and shared contracts.
- `scenes/`
  - Godot scene composition (`main.tscn`, `ui.tscn`, 3D screen setup).
- `test/`
  - GUT unit/integration tests.

### Domain layer (`src/game`)

- **Models:** `Station`, `Satellite`, `SatSignal`
  - `Station` is the central state machine: sync state, data, attack handling.
- **Factory:** `SatFactory`
  - Creates new satellite references using provider abstractions.
- **Event bus classes:** `*Event.gd`
  - Decoupled communication between domain and controllers via static singleton signals (e.g., `SyncEvent`, `DataEvent`, `GameOverEvent`).

This keeps gameplay logic testable without requiring full scene runtime for most behavior checks.

### Runtime flow

1. `main.tscn` loads 3D world + SubViewport-based UI.
2. Controllers subscribe to domain events in `_ready()`.
3. Player input updates station tuning values.
4. `Station` computes sync/attack/data transitions and emits events.
5. Controllers react by updating display, labels, sound, and game state.

## Running the Project

### Option 1: Godot Editor

1. Open the folder in Godot 4.6+.
2. Run the default main scene (`scenes/main.tscn`).

### Option 2: Headless/CLI launch

From project root:

```bash
godot --path . 
```

## Running Tests

Tests use [GUT](https://github.com/bitwes/Gut) (already included in `addons/gut`).

### Run all tests once

```bash
godot --headless -s addons/gut/gut_cmdln.gd -glog=1 -gexit
```

### Optional auto-run on file changes (Linux)

```bash
./run_tests.sh
```

This watches `src/` and `test/` and executes the full test suite after each save.