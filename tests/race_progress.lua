-- Run from the project root with lua tests/race_progress.lua.
local RaceProgress = require("src.race_progress")
local Game = require("src.game")
local track = require("tracks.breakfast")
local gates = track.gates

local function cross(progress, index, reverse)
    local gate = gates[index]
    local x, y = (gate.ax + gate.bx) / 2, (gate.ay + gate.by) / 2
    local dx, dy = (gate.ay - gate.by) / 10, (gate.bx - gate.ax) / 10
    if reverse then
        dx, dy = -dx, -dy
    end
    return progress:advance(x - dx, y - dy, x + dx, y + dy)
end

local progress = RaceProgress.new(gates, 3)
assert(not cross(progress, 1), "Opening start/finish crossing counted as a lap")
assert(not cross(progress, 3), "Out-of-order gate was accepted")
assert(not cross(progress, 2, true), "Reverse gate was accepted")
assert(not progress:advance(1100, 390, 1100, 410), "Crossing beyond the gate span was accepted")
assert(not progress:advance(900, 390, 900, 400), "Touching a gate was counted as crossing")
assert(progress:advance(900, 400, 900, 410) == gates[2], "Departure from the gate line was missed")
assert(not cross(progress, 2), "Repeated gate advanced progress")
assert(not cross(progress, 1), "Start/finish counted before all required gates")
assert(cross(progress, 3) == gates[3])
assert(cross(progress, 4) == gates[4])
assert(not cross(progress, 1, true), "Reverse start/finish counted")
assert(cross(progress, 1) == gates[1])
assert(progress.completedLaps == 1 and not progress.finished)
print("PASS opening line, ordered finite gates, reverse rejection, and a valid lap")

local game = Game.new(track)
game.player.x, game.player.y = 900, 405
game:recover()
game:update(1 / 120, { accelerate = true, steer = 0 })
assert(game.progress.nextGateIndex == 2 and game.progress.completedLaps == 0)
assert(cross(game.progress, 2) == gates[2])
game.player.x, game.player.y = 220, 530
game:recover()
game:update(1 / 120, { accelerate = true, steer = 0 })
assert(game.progress.lastGate == gates[2] and game.progress.nextGateIndex == 3)
assert(game.progress.completedLaps == 0)
print("PASS recovery preserves gate and lap progress")

for lap = 2, 3 do
    for index = 2, #gates do
        assert(cross(progress, index) == gates[index])
    end
    assert(cross(progress, 1) == gates[1])
    assert(progress.completedLaps == lap)
    assert(progress.finished == (lap == 3))
end
assert(not cross(progress, 2) and progress.lastGate == gates[1])
assert(progress.completedLaps == 3)
print("PASS third lap finishes and locks race progress")
