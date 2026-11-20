# Marble Racers: Around the House

Drive a turquoise marble around the **Kitchen Table Circuit — Breakfast Grand Prix**.
Press the accelerator to start the race with three computer-controlled rivals.
Drive clockwise, steer around blueberries and sugar cubes, and cross the marked
gates in order to complete three laps.

## Play on Windows 11

1. Go to [love2d.org](https://love2d.org/) and install **LÖVE 11.5 for 64-bit Windows**.
2. Save or extract this project to a regular folder. In File Explorer, open the
   folder that directly contains `main.lua` and `conf.lua`.
3. Open a second File Explorer window at `C:\Program Files\LOVE`. If you chose a
   different install location, open that folder instead.
4. Drag the **whole project folder** onto `love.exe`. The game opens in its own window.

You can also open PowerShell in the project folder. In File Explorer, type
`powershell` into the address bar and press Enter. Then run:

```powershell
& "C:\Program Files\LOVE\love.exe" .
```

If an error says that `main.lua` is missing, check that the folder you launched
contains it directly. LÖVE includes its own Lua runtime.

## Controls

| Key | Action |
| --- | --- |
| W or Up Arrow | Accelerate |
| S or Down Arrow | Brake |
| A or Left Arrow | Steer left |
| D or Right Arrow | Steer right |
| R | Return to the last valid checkpoint |
| Esc | Pause or resume |

The white arrow shows current travel direction and the dark dot shows where
the marble is aimed. While stopped, the arrow points where you are aimed.
The highlighted arrows mark the next checkpoint. Cross it in the arrow's
direction to update your recovery point. After the three checkpoints, cross
the checkered stripe to count a lap. Recovery preserves your progress. The lap
display shows your finishing position when you complete the third lap.
The speed display uses pixels per second.

## Project layout

| Path | Contents |
| --- | --- |
| `main.lua`, `conf.lua` | LÖVE entry point, input bindings, and window configuration |
| `src/game.lua` | Fixed-step simulation loop, pause, and recovery state |
| `src/marble.lua` | Steering, acceleration, braking, and momentum |
| `src/physics.lua` | Fixed-step movement and contact resolution for the marbles |
| `src/race_progress.lua` | Ordered gate crossings, lap count, and finish state |
| `src/ai_driver.lua` | Waypoint steering, pace control, and automatic stuck recovery |
| `src/track_collision.lua` | Track boundaries and obstacle bounce |
| `data/physics/arcade.lua` | Shared values for speed, handling, drag, and rebound |
| `data/racers/breakfast.lua` | Opponent pace and racing-line offsets |
| `src/renderer.lua` | Tabletop, original shape artwork, marble, and HUD |
| `tracks/breakfast.lua` | Circuit layout, grid, waypoints, checkpoints, and recovery points |
| `assets/` | Location for future artwork and audio assets |
| `tests/` | Automated Lua checks and scripted circuit drive |
| [Progress tracker](docs/PROGRESS_TRACKER.md) | Milestone status and verification |
| [Recovery checkpoint](docs/RECOVERY_CHECKPOINT.md) | Verified build and resume instructions |

If you have a standalone Lua interpreter, run `lua tests/run.lua`,
`lua tests/race_progress.lua`, `lua tests/practice_loop.lua`, and
`lua tests/ai_race.lua` from the project folder. The game only requires LÖVE.
