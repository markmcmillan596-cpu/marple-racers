# Progress tracker

- **Current milestone:** Milestone 3 verified and complete. Milestone 4 is queued.
- **In progress:** None.
- **Latest verified game commit:** `6c1972beaf77877efff8724c23b5230d3e154fc6`.
- **Last successful test:** 2026-11-20, LÖVE 11.5 launch with synthetic driving input on Linux Xvfb.
- **Outstanding validation:** Manual playtesting, Windows 11 launch, and measured Windows frame rate.

## Milestone status

| Milestone | Status |
| --- | --- |
| 1. Project foundation | COMPLETE — VERIFIED |
| 2. Arcade marble physics | COMPLETE — VERIFIED |
| 3. Checkpoints and lap management | COMPLETE — VERIFIED |
| 4. AI racing opponents | NOT STARTED |
| 5. Kitchen table environment | NOT STARTED |
| 6. Advanced track mechanics | NOT STARTED |
| 7. User interface and race presentation | NOT STARTED |
| 8. Testing, balancing, and first playable release | NOT STARTED |

## Milestone 1 verification

- Confirmed the 11 foundation files are present, including both LÖVE entry
  files, the source modules, track data, assets and tests directories, and
  Windows 11 launch instructions.
- All Lua files passed syntax checks. All nine automated Lua tests passed,
  covering movement, timing, pause, collisions, and recovery.
- `lua tests/practice_loop.lua` drove the entire loop through the game
  update and activated both recovery points in sequence.
- LÖVE 11.5 rendered the tabletop in a Linux virtual display. Synthetic
  keyboard events and frame comparisons verified acceleration, braking,
  steering in both directions, pause, resume, recovery, and resizing.
- Manual gameplay and Windows 11 launch have not been tested.

## Milestone 2 verification

- Movement tuning and collision rebound now use `data/physics/arcade.lua`.
  The fixed-step simulation advances each marble before resolving contacts.
  Track contacts are rechecked after equal-mass marble contacts near a boundary.
- All 16 Lua checks passed. The seven added checks cover custom tuning,
  fixed-step pair contacts, full-speed head-on and glancing collisions,
  separating overlaps, coincident centers, and four marbles near a rail.
- The full practice loop still activates both recovery points. A comparison
  against Milestone 1 matched player position, velocity, heading, and checkpoint
  across 454 frames, with numeric values compared to eight decimal places.
- LÖVE 11.5 launched under Linux Xvfb. Synthetic keyboard input and frame captures
  verified driving, braking, steering, pause, recovery, and resizing.
- The playable build still has one marble. Multi-marble contacts were exercised
  in automated simulation. Manual gameplay and Windows 11 remain untested.

## Milestone 3 verification

- The circuit has three ordered directional checkpoints and a start/finish
  stripe. Three valid laps finish the race. Recovery returns to the last valid
  checkpoint and keeps lap progress.
- All 16 physics checks, three race-rule check groups, the scripted three-lap
  drive, and the LÖVE 11.5 Linux window smoke test passed.
- Manual gameplay and Windows 11 remain untested.

## Exact next task

Start Milestone 4 by defining a four-racer grid and clockwise waypoints in
the track data. Give three AI marbles a waypoint controller and stuck recovery.
Run them through the existing fixed-step physics and race rules, and verify
that all three opponents can finish a three-lap race.
