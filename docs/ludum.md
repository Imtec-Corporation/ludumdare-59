# Signals of Earth

**"In the vast silence of the cosmos, not every signal is meant for human ears."**

You are the operator of the Vanguard Orbital Link Station, the last relay between scattered satellites and Earth Command.  
Your official task is simple: keep links stable and data flowing.  
Your real mission is Protocol Yugen: intercept alien signal patterns, neutralize hostile interference, and keep the network secure without letting it collapse.

This is a focused, systems-heavy version of our original concept: short feedback loops, readable control surfaces, and pressure that comes from balancing synchronization, transmission, and security response.

## How to play

- Use the space-station console UI with your **mouse**.
- Tune **frequency** and **amplitude** with sliders to keep satellite links synchronized.
- Use console buttons to trigger actions and respond to incidents.
- Hold **Right Mouse Button** and drag to pan the camera.
- Use **A** and **D** to tilt the view.

Your objective is to keep the network alive:

1. Maintain sync with target satellites.
2. Transmit data consistently.
3. Respond to alien threats before they cascade into data loss.

## Development notes (for fellow devs)

We built the game around a lightweight event-driven architecture with DDD-inspired boundaries:

- Core domain behavior (station state, synchronization logic, attacks, data gain/loss) is modeled as independent gameplay logic.
- Controllers and scene-facing systems subscribe to domain events and translate state into UI, audio, and camera feedback.
- The result is a decoupled loop where gameplay rules remain testable and iteration on presentation remains fast.

The architecture is intentionally pragmatic: simple event bus patterns, clear separation of concerns, and minimal ceremony for jam-time development.

## Tech stack

- **Godot** - game design and development
- **Blender** - 3D modeling
- **Cursor / VSCode** - coding
- **Audacity** - audio editing
- **LMMS** - music composition
- **JFXR** - SFX generation: [jfxr.frozenfractal.com](https://jfxr.frozenfractal.com/)
- **ElevenLabs** - for voice generation: [elevenlabs.io](https://elevenlabs.io/)
