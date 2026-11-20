# Recovery checkpoint

- **Project:** Marble Racers: Around the House
- **Captured:** 2026-11-20 11:06 EST
- **Branch:** `marble-racers-development`
- **Verified game commit:** `a0a3c0fa707212aa7b95862f22fa0fd48255901b`
- **Last completed milestone:** Milestone 4 — AI racing opponents
- **Current incomplete milestone:** Milestone 5 — Kitchen table environment, queued

## Files and Git

- Milestone 3 added `src/race_progress.lua` and `tests/race_progress.lua`.
  It modified `src/game.lua`, `src/renderer.lua`, `tracks/breakfast.lua`,
  `tests/run.lua`, `tests/practice_loop.lua`, and `README.md`.
- Milestone 4 added `src/ai_driver.lua`, `data/racers/breakfast.lua`, and
  `tests/ai_race.lua`. It modified `main.lua`, `src/game.lua`,
  `src/race_progress.lua`, `src/renderer.lua`, `tracks/breakfast.lua`, and `README.md`.
- Both game commits were pushed. The remote matched the Milestone 4 game commit
  at capture, when only this checkpoint and the progress tracker were pending.
- Verify the current branch and tip with `git status --short --branch`,
  `git rev-parse HEAD`, and `git ls-remote origin refs/heads/marble-racers-development`.

## Tests and known gaps

All 16 physics checks, gate and finish tests, the solo three-lap drive, and
the AI race suite passed on Lua 5.1 and 5.4. Six races per runtime produced
all expected finishers. The forced-stall check verified AI recovery and
a valid finish. Automated LÖVE 11.5 smoke checks passed for the solo Milestone 3
build and the four-marble Milestone 4 build. Manual gameplay, Windows 11 launch,
and measured Windows render performance remain open.

## Resume

1. Verify the branch, current commit, and working tree against the
   [progress tracker](PROGRESS_TRACKER.md).
2. From the project folder, run `lua tests/run.lua`, `lua tests/race_progress.lua`,
   `lua tests/practice_loop.lua`, and `lua tests/ai_race.lua`.
3. Launch with `love .` or follow the [Windows instructions](../README.md#play-on-windows-11).
   Accelerate to start. Cross the highlighted gates clockwise, verify that R
   preserves your lap progress, and check your finishing position after lap three.
4. Resume at the [exact Milestone 5 task](PROGRESS_TRACKER.md#exact-next-task).
