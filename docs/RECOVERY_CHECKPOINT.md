# Recovery checkpoint

- **Project:** Marble Racers: Around the House
- **Captured:** 2026-11-20 08:01 EST
- **Branch:** `marble-racers-development`
- **Verified game commit:** `a465fecd183936b0bd3322ba857a0640aa77c4d3`
- **Last completed milestone:** Milestone 1 — Project foundation
- **Current incomplete milestone:** Milestone 2 — Arcade marble physics, queued

## Files and Git

- Foundation commit added `main.lua`, `conf.lua`, `README.md`, `MILESTONES.md`,
  `assets/README.md`, `src/game.lua`, `src/marble.lua`, `src/renderer.lua`,
  `src/track_collision.lua`, `tracks/breakfast.lua`, and `tests/run.lua`.
- This verification and documentation update adds `tests/practice_loop.lua`
  and the three files under `docs/`. It updates `README.md` and `MILESTONES.md`.
- The foundation commit was pushed to `origin/marble-racers-development` before
  this checkpoint was written. The working tree was clean after the foundation
  commit. At capture, the scripted test and documentation update were pending.
- To check the current tip and work in progress, use `git rev-parse HEAD`,
  `git status --short --branch`, and
  `git ls-remote origin refs/heads/marble-racers-development`.

## Test results and known gaps

Lua syntax checks, all nine automated Lua tests, the scripted full circuit,
and the LÖVE 11.5 Linux window smoke check passed. Manual gameplay, Windows 11
launch, and measured Windows frame rate remain open. The current build offers
a single-marble practice loop with two recovery areas. See the
[progress tracker](PROGRESS_TRACKER.md#milestone-1-verification) for test details.

## Resume

1. Open the project checkout and confirm the branch, current commit, and
   working tree. Compare the current state with the progress tracker.
2. Run `lua tests/run.lua` and `lua tests/practice_loop.lua` from the project
   folder. Launch with `love .` or follow the [Windows 11 launch steps](../README.md#play-on-windows-11).
3. For a manual check, drive clockwise through the far straight marker and
   press R after leaving it. Confirm that the marble returns to the marker
   facing left and stationary. Pause with Esc and verify that driving input
   has no effect until you resume.
4. Resume at the [exact Milestone 2 task](PROGRESS_TRACKER.md#exact-next-task).
