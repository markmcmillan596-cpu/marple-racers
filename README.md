# Marble Racers: Around the House

Drive a turquoise marble around the **Kitchen Table Circuit — Breakfast Grand Prix**.
Follow the loop clockwise from the checkered stripe and steer around blueberries
and sugar cubes. The practice circuit has a recovery point on each straight.

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
| R | Return to the most recently visited recovery point |
| Esc | Pause or resume |

The white arrow shows current travel direction and the dark dot shows where
the marble is aimed. While stopped, the arrow points where you are aimed.
Enter the marked area near the middle of either straight to update your recovery point.
The speed display uses pixels per second.

## Project layout

| Path | Contents |
| --- | --- |
| `main.lua`, `conf.lua` | LÖVE entry point, input bindings, and window configuration |
| `src/game.lua` | Fixed-step simulation loop, pause, and recovery state |
| `src/marble.lua` | Steering, acceleration, braking, and momentum |
| `src/track_collision.lua` | Track boundaries and obstacle bounce |
| `src/renderer.lua` | Tabletop, original shape artwork, marble, and HUD |
| `tracks/breakfast.lua` | Kitchen Table Circuit layout and recovery points |
| `assets/` | Location for future artwork and audio assets |
| `tests/run.lua` | Automated Lua checks |
| [MILESTONES.md](MILESTONES.md) | Progress, verification, and recovery instructions |

If you have a standalone Lua interpreter, run `lua tests/run.lua` from the project
folder. The game itself only requires LÖVE.
