# Progress tracker

- **Current milestone:** Milestone 4 verified and complete. Milestone 5 is queued.
- **In progress:** None.
- **Latest verified game commit:** `a0a3c0fa707212aa7b95862f22fa0fd48255901b`.
- **Last successful launch check:** 2026-11-20, four-racer LÖVE 11.5 launch on Linux Xvfb with synthetic driving input.
- **Outstanding validation:** Manual playtesting, Windows 11 launch, and measured Windows frame rate.

## Milestone status

| Milestone | Status |
| --- | --- |
| 1. Project foundation | COMPLETE — VERIFIED |
| 2. Arcade marble physics | COMPLETE — VERIFIED |
| 3. Checkpoints and lap management | COMPLETE — VERIFIED |
| 4. AI racing opponents | COMPLETE — VERIFIED |
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

## Milestone 4 verification

- The game opens on a four-marble grid and starts when the player accelerates.
  Three AI rivals follow different lines and target speeds through the same
  physics, gate rules, and recovery system as the player. Finishing order uses
  the time each racer crosses the line, including crossings in the same step.
- All four Lua suites passed on Lua 5.1 and 5.4. On each runtime, all four racers
  finished five seeded races and all three opponents finished with an idle
  player. There were no AI recoveries in those runs.
- A deliberately stalled opponent recovered to its last valid gate, retained
  progress, and completed the race on both Lua runtimes.
- Automated LÖVE 11.5 window checks verified four visible marbles, opponent
  movement, player input, pause, recovery, and resizing. Manual gameplay,
  Windows 11 launch, and Windows render performance remain untested.

## Exact next task

Start Milestone 5 by keeping the verified placeholder course available as a
fallback and creating a separate version of the Kitchen Table Circuit with
original household scenery. Define decorative objects separately from solid
obstacles and their collision shapes. Keep routes wide enough for four marbles,
save the art source files and asset status, and rerun full races at the existing
AI pace to check that all competitors can navigate the dressed course.
