# Milestone tracker and recovery checkpoint

This file is the single source of truth for milestone progress.

## Milestone 1 — Project foundation complete

- A single player can drive the clockwise Kitchen Table Circuit practice loop.
  The table, rail, plate, blueberries, and sugar cubes use original shapes.
- The marble accelerates, brakes, and steers with the keyboard. Momentum fades
  gradually, and rails and obstacles reflect part of the impact speed.
- The white arrow indicates travel direction and the dark dot indicates steering
  heading. The HUD shows speed, the active recovery point, and keyboard controls.
- R resets the marble to the latest recovery point. Escape pauses or resumes.
  Losing window focus pauses the simulation.
- Simulation runs at a fixed 120 Hz, with a capped catch-up window. The 1100 × 720
  reference view scales proportionally when the window is resized.
- Movement, collisions, game state, rendering, and track layout live in separate
  modules. [README.md](README.md) covers launch on Windows 11.

### Verification

| Method | Outcome |
| --- | --- |
| Lua 5.1 syntax check | All Lua files parsed |
| `lua tests/run.lua` | 9 checks passed for movement, braking, steering, fixed-step timing, pause, collisions, and recovery |
| Scripted practice circuit | Completed one clockwise loop and activated both recovery points in sequence. The script fed controls to the normal simulation update. |
| LÖVE 11.5 launch under Linux Xvfb | The game rendered. Synthetic keyboard events verified acceleration, braking, left and right steering, pause and resume, and recovery. Frame captures verified position and proportional resizing. |
| Manual gameplay and Windows 11 launch | Pending |

## Recovery instructions

1. Open the Marble Racers project folder containing `main.lua` and `conf.lua`.
   In this cloud workspace it is `/workspace/marple-racers`.
2. Run `lua tests/run.lua` from the project folder with a standalone Lua
   interpreter. Use `love .` with LÖVE 11.5 on your PATH, or follow the Windows
   launch steps in [README.md](README.md).
3. To manually verify the practice build, drive clockwise, pass through the far
   straight's recovery marker, then press R after leaving it. Verify the marble
   reappears at that marker, facing left and stationary. Pause with Esc and verify
   driving input has no effect until you resume.
4. Resume at the Milestone 2 task below when work on that milestone begins.

## Milestone 2 — Exact next task

Implement directional checkpoint gates and three-lap counting for the single
player. Define the ordered gates in `tracks/breakfast.lua`. In a separate pure Lua
race-progress module, accept a gate only when the marble crosses it forward and
in order. Increment the lap at the forward start/finish crossing after all
required gates, and mark the race finished after the third valid lap. A recovery
teleport must never count as a crossing. Add automated checks for a valid lap,
out-of-order crossings, reverse crossings, recovery, and the three-lap finish.
