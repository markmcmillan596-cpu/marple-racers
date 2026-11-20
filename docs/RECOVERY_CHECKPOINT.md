# Recovery checkpoint

- **Project:** Marble Racers: Around the House
- **Captured:** 2026-11-20 10:53 EST
- **Branch:** `marble-racers-development`
- **Verified game commit:** `0d2db425c42685638036db44f446e9105d309618`
- **Last completed milestone:** Milestone 2 — Arcade marble physics
- **Current incomplete milestone:** Milestone 3 — Checkpoints and lap management, queued

## Files and Git

- Milestone 2 added `data/physics/arcade.lua` and `src/physics.lua`.
- It changed `src/game.lua`, `src/marble.lua`, `src/track_collision.lua`,
  `tests/run.lua`, and `README.md`.
- The physics commit was pushed and matched the remote branch at capture.
  This checkpoint and the progress tracker were the only pending files.
- To verify the current state, run `git rev-parse HEAD`,
  `git status --short --branch`, and
  `git ls-remote origin refs/heads/marble-racers-development`.

## Test results and known gaps

Lua syntax checks, all 16 Lua checks, the scripted full circuit, and the LÖVE
11.5 Linux window check passed. A 454-frame player trace matched Milestone 1.
Multi-marble contacts were tested in simulation. The game opens on the
single-marble practice circuit. Manual gameplay, Windows 11 launch, and measured
Windows frame rate remain open. See the [progress tracker](PROGRESS_TRACKER.md#milestone-2-verification).

## Resume

1. Open the project checkout and verify the branch, current commit, and
   working tree against the progress tracker.
2. Run `lua tests/run.lua` and `lua tests/practice_loop.lua` from the project
   folder. Launch with `love .` or follow the [Windows 11 launch steps](../README.md#play-on-windows-11).
3. For a manual check, drive through the far straight marker, press R after
   leaving it, and verify that the marble returns facing left and stationary.
   Press Esc and verify that driving input has no effect while paused.
4. Resume at the [exact Milestone 3 task](PROGRESS_TRACKER.md#exact-next-task).
