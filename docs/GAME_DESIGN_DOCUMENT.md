# Marble Racers: Around the House

Development reference based on Game Design Document v1.0 and the Milestone 1 brief.

## Game and first circuit

An original top-down 2D arcade marble racer for Windows 11 using LÖVE2D and Lua.
The first circuit is the Kitchen Table Circuit — Breakfast Grand Prix. Race toward
a four-marble, three-lap format with computer-controlled opponents, household
obstacles, checkpoints, surface effects, race timing, and standings.

W or Up accelerates, S or Down brakes, A/D or Left/Right steers, R recovers at
the latest valid checkpoint, and Esc pauses. Keep momentum and bouncing light
enough for responsive arcade handling. Use original art, branding, and track
designs. Keep Marble Run Workshop in its own repository.

## Milestones 1–4

1. **Project foundation.** Create a runnable LÖVE project with a placeholder
   tabletop loop, one controllable marble, a direction indicator, stable
   simulation, beginner-friendly Windows launch instructions, and verification
   and recovery records.
2. **Arcade marble physics.** Develop and verify acceleration, braking, steering,
   momentum, friction, and predictable wall, obstacle, and marble contacts.
3. **Checkpoints and lap management.** Validate forward crossings of checkpoints
   in order. Count laps at the start/finish gate and finish after three valid
   laps. Recovery teleports must never count as gate crossings. Add tests for
   valid laps, reverse crossings, out-of-order crossings, recovery, and finish.
4. **AI racing opponents.** Add computer-controlled racers using compatible
   physics and valid racing rules, with waypoint navigation and recovery.

## Milestone 5 — Kitchen table environment

Build a recognizable, readable circuit that four marbles can race around.
Preserve the placeholder course as a fallback. Keep decorative objects separate
from solid objects with explicit collision shapes. Save original assets and
source files and record which are complete or still need improvement. Verify
the full circuit at typical racing speeds, with particular attention to AI
navigation, space for multiple marbles, and responsiveness.

## Milestone 6 — Advanced track mechanics

- Use configurable surfaces. Wood handles normally, fabric napkins increase
  drag, placemats change traction, and cereal adds small solid obstacles.
- Allow useful bank shots off solid barriers without making them universally
  faster than a conventional racing line.
- Add a visible, shorter route that takes skill. Both AI and player must be
  able to take it while satisfying every required checkpoint.
- Verify surface behavior, stable bouncing without repeated penetration, legal
  shortcut laps, AI circuit completion, and responsive handling.

## Milestone 7 — User interface and race presentation

- Main menu with Quick Race, Controls, Settings, and Exit. Identify any
  unfinished mode as upcoming or disabled.
- Race HUD with position, current and total laps, race timer, current lap
  time, best lap, and speed.
- Three-second countdown, GO, lap and final-lap notices, finishing position,
  and a results view with all four racers, finishing order, valid race times
  and best laps where available, restart, and return to menu.
- Optional readable effects for highlights, rolling, contact, particles,
  and checkpoint feedback. Use original or appropriately licensed sounds
  for countdown, start, contact, lap completion, finish, and menu selection.
- Verify the full menu-to-results flow, accurate statistics, pause and
  restart, unobstructed HUD, working settings, and stable transitions.

## Milestone 8 — Testing, balancing, and first playable release

Balance acceleration, speed, braking, steering, cornering, impacts, wall
bounce, AI difficulty, shortcuts, and recovery. Target smooth 60 FPS rendering
on Windows 11, stable fixed-step physics, and consistent behavior when resizing.
Report measured performance and gameplay feel only where actually verified.

Automate lap and checkpoint rules, start/finish, standings, collisions, recovery,
AI navigation, restart, and track loading where practical. Simulate races with
several fixed seeds and record race counts, completions, AI failures, stuck
racers, invalid laps, recovery frequency, and race times. Investigate recurring
failures. Publish a Windows 11 manual test checklist and identify untested items.

The first release requires a runnable LÖVE project, complete source and assets,
a four-marble race with AI, the Kitchen Table Circuit, menus and results,
Windows setup and packaging instructions, test results, known issues, and
current progress and recovery documents. A Windows executable is optional
if the cloud environment cannot build or verify one.

## Architecture and track data

Keep movement control, physics, marble state, AI, track loading, race rules,
viewport, rendering, UI, and configuration separate as those systems come online.
Use a capped fixed physics timestep, reproducible tests, configurable gameplay
values, meaningful errors, and minimal dependencies.

A reusable track definition should eventually include name, background,
dimensions, boundaries, household objects, collision shapes, starting positions,
waypoints, checkpoints, surfaces, shortcuts, direction, and camera settings.
Keep kitchen-specific data out of shared physics. A graphical track editor
can come later.

## Development and verification

Check the branch, working tree, design, and tracker before resuming. Preserve
completed milestones and the placeholder course. Test each changed workflow,
update [progress](PROGRESS_TRACKER.md) and [recovery](RECOVERY_CHECKPOINT.md),
and use descriptive commits on the development branch. Push when authorized
and verify the remote ref. Advance in sequence within the active task's scope.
