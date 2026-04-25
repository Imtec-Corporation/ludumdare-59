# Test Coverage Map

This document maps core game-domain scripts in `src/game` to their tests.

## Game Domain Coverage (`src/game`)

### Events

- `src/game/event/attack_event.gd`
  - `test/unit/game/event/test_game_core_events.gd`
- `src/game/event/data_event.gd`
  - `test/unit/game/event/test_game_events.gd`
- `src/game/event/data_loss_event.gd`
  - `test/unit/game/event/test_game_events.gd`
- `src/game/event/game_over_event.gd`
  - `test/unit/game/event/test_game_core_events.gd`
- `src/game/event/game_start_event.gd`
  - `test/unit/game/event/test_game_events.gd`
- `src/game/event/message_event.gd`
  - `test/unit/game/event/test_game_core_events.gd`
- `src/game/event/reset_event.gd`
  - `test/unit/game/event/test_game_core_events.gd`
- `src/game/event/sync_event.gd`
  - `test/unit/game/event/test_game_events.gd`

### Models

- `src/game/model/sat_signal.gd`
  - `test/unit/game/model/test_sat_signal.gd`
- `src/game/model/satellite.gd`
  - `test/unit/game/model/test_satellite.gd`
- `src/game/model/station.gd`
  - `test/unit/game/model/test_station.gd`

### Factory

- `src/game/factory/sat_factory.gd`
  - `test/unit/game/factory/test_sat_factory.gd`

## Integration Coverage

- Main scene wiring and game start flow:
  - `test/integration/test_main_scene_integration.gd`

## Run tests

- Full suite:
  - `godot --headless -s addons/gut/gut_cmdln.gd -glog=1 -gexit`
