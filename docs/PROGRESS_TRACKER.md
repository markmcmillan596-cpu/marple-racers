# Progress tracker

- **Current milestone:** Milestone 1 verified and complete. Milestone 2 is queued.
- **In progress:** None.
- **Latest verified game commit:** `a465fecd183936b0bd3322ba857a0640aa77c4d3`.
- **Last successful test:** 2026-11-20, LÖVE 11.5 launch with synthetic driving input on Linux Xvfb.
- **Outstanding validation:** Manual playtesting, Windows 11 launch, and measured Windows frame rate.

## Milestone status

| Milestone | Status |
| --- | --- |
| 1. Project foundation | COMPLETE — VERIFIED |
| 2. Arcade marble physics | NOT STARTED |
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

## Exact next task

Start Milestone 2 by moving the existing acceleration, braking, top speed,
steering, drag, and bounce values into a shared Lua physics configuration.
Have `src/marble.lua` and `src/track_collision.lua` consume those defaults and
rerun the Milestone 1 tests and scripted loop to check that handling stays
consistent. Then validate contacts involving multiple marbles before
advancing to Milestone 3 race rules.
