# Recovery checkpoint

- **Project:** Marble Racers: Around the House
- **Captured:** 2026-11-20 11:17 EST
- **Branch:** `marble-racers-development`
- **Verified game commit:** `ee5410083988bb4cde01afe4816136d44b2509b9`
- **Last completed milestone:** Milestone 6 — Advanced track mechanics
- **Current incomplete milestone:** Milestone 7 — User interface and race presentation, queued

## Files and Git

- Milestone 5 added `tracks/kitchen.lua` and `assets/kitchen/art.lua`. It
  updated the renderer, launch behavior, race test, README, and asset register.
- Milestone 6 added `tracks/kitchen_advanced.lua`, `data/physics/surfaces.lua`,
  `src/surfaces.lua`, and `tests/track_mechanics.lua`. It updated the game
  and physics integration, collision shapes, AI profiles and route selection,
  renderer, artwork, race test, and usage docs.
- Both game commits were pushed. The remote branch matched the Milestone 6
  game commit at capture. This checkpoint and the progress tracker were pending.
- Verify the branch and current tip with `git status --short --branch`,
  `git rev-parse HEAD`, and `git ls-remote origin refs/heads/marble-racers-development`.

## Tests and known gaps

All five Lua suites passed on Lua 5.1 and 5.4. The dressed and classic layouts
passed the four-racer AI suite. Automated LÖVE 11.5 launch checks passed for
the advanced and classic courses on Linux. Manual gameplay, Windows 11 launch,
and measured Windows render performance remain open. See the
[progress tracker](PROGRESS_TRACKER.md#milestone-6-verification) for race results.

## Resume

1. Verify the branch, commit, and working tree against the progress tracker.
2. From the project folder, run the five commands in the [README](../README.md).
   Launch with `love .`, or `love . --classic` for the placeholder course.
3. For a manual run, accelerate to start, drive clockwise through the
   highlighted gates, and try both lines after the right checkpoint. Confirm
   that each line requires the far checkpoint and that R retains lap progress.
4. Resume at the [exact Milestone 7 task](PROGRESS_TRACKER.md#exact-next-task).
