# Recovery checkpoint

- **Project:** Marble Racers: Around the House
- **Captured:** 2026-11-20 11:11 EST
- **Branch:** `marble-racers-development`
- **Verified game commit:** `f022baf6bca0239c2ff87ac5b12cc3f1a455b557`
- **Last completed milestone:** Milestone 5 — Kitchen table environment
- **Current incomplete milestone:** Milestone 6 — Advanced track mechanics

Added `tracks/kitchen.lua` and `assets/kitchen/art.lua`. Updated the renderer,
launch options, AI suite, README, and asset status. The game commit was local
at capture, with the progress tracker and checkpoint pending.

Physics, gate rules, a scripted solo drive, and four-racer simulations passed.
The dressed and classic courses launched with LÖVE 11.5 under Linux Xvfb.
Manual gameplay, Windows launch, and render performance remain unverified.

Resume from the [exact Milestone 6 task](PROGRESS_TRACKER.md#exact-next-task).
Run the suites listed in the [README](../README.md), then launch `love .`
or `love . --classic`.
