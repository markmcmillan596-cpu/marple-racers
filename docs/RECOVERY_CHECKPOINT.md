# Recovery checkpoint

- **Project:** Marble Racers: Around the House
- **Captured:** 2026-11-20 11:01 EST
- **Branch:** `marble-racers-development`
- **Verified game commit:** `6c1972beaf77877efff8724c23b5230d3e154fc6`
- **Last completed milestone:** Milestone 3 — Checkpoints and lap management
- **Current incomplete milestone:** Milestone 4 — AI racing opponents

## Files and Git

- Added `src/race_progress.lua` and `tests/race_progress.lua`.
- Updated track gates, game integration, renderer, README, and the existing tests.
- At capture, the code commit was local. The tracker and this checkpoint were pending.
  Use `git status --short --branch` and
  `git ls-remote origin refs/heads/marble-racers-development` to verify current state.

## Tests and resume

Run `lua tests/run.lua`, `lua tests/race_progress.lua`, and
`lua tests/practice_loop.lua`. All passed, along with Lua parsing and a Linux
LÖVE 11.5 smoke check. Manual playtesting and Windows 11 remain untested.

Launch with `love .` or the [Windows instructions](../README.md#play-on-windows-11).
Continue at the [exact Milestone 4 task](PROGRESS_TRACKER.md#exact-next-task).
