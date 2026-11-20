# Progress tracker

- **Current milestone:** Milestone 2 verified and complete. Milestone 3 is queued.
- **In progress:** None.
- **Latest verified game commit:** `0d2db425c42685638036db44f446e9105d309618`.
- **Last successful test:** 2026-11-20, LÖVE 11.5 launch with synthetic driving input on Linux Xvfb.
- **Outstanding validation:** Manual playtesting, Windows 11 launch, and measured Windows frame rate.

## Milestone status

| Milestone | Status |
| --- | --- |
| 1. Project foundation | COMPLETE — VERIFIED |
| 2. Arcade marble physics | COMPLETE — VERIFIED |
| 3. Checkpoints and lap management | NOT STARTED |
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

## Exact next task

Start Milestone 3 by defining finite, ordered checkpoint gates in
`tracks/breakfast.lua` and adding a pure Lua race-progress module. Feed it the
player's positions before and after each fixed simulation step. Accept forward
crossings in order, count a lap at the start/finish line after all required
gates, and finish after three valid laps. Keep recovery teleports out of the
crossing checks. Add tests for a valid lap, reverse and out-of-order crossings,
recovery, and the three-lap finish.
