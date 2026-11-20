-- Run from the project root with lua tests/ai_race.lua.
local Driver = require("src.ai_driver")
local Game = require("src.game")
local track = require((arg and arg[1]) or "tracks.kitchen_advanced")

local FRAME = 1 / 60
local STEP = 1 / 120
local neutral = { steer = 0 }
local throttle = { accelerate = true, steer = 0 }

local function startedRace()
    local game = Game.newRace(track)
    assert(#game.racers == 4 and game.racers[1].marble == game.player)
    game:update(FRAME, neutral)
    assert(game.waiting and game.elapsed == 0)
    for _, racer in ipairs(game.racers) do
        assert(racer.marble.x == racer.spawn.x and racer.marble.y == racer.spawn.y)
    end
    game:update(FRAME, throttle)
    assert(not game.waiting and game.elapsed > 0)
    return game
end

local function simulate(seed)
    local game = startedRace()
    local expectedFinishers = 3
    local driver
    if seed then
        math.randomseed(seed)
        driver = Driver.new(track.waypoints, {
            pace = 0.88 + math.random() * 0.28,
            laneOffset = math.random(-7, 7),
        })
        expectedFinishers = 4
    end

    for _ = 1, 60 * 45 do
        local input = neutral
        local lastGate = game.progress.lastGate
        if driver then
            input = driver:update(game.player, FRAME, game.progress.finished)
            assert(input, "Scripted player failed to navigate the course")
        end
        game:update(FRAME, input)
        if driver and game.progress.lastGate ~= lastGate then
            driver:onGate()
        end
        if #game.finishOrder == expectedFinishers then
            break
        end
    end

    local seen, previousTime, aiRecoveries = {}, 0, 0
    assert(#game.finishOrder == expectedFinishers, "Race did not finish within 45 seconds")
    for _, racer in ipairs(game.finishOrder) do
        assert(not seen[racer.id], "Racer recorded twice")
        seen[racer.id] = true
        assert(racer.progress.finished and racer.progress.completedLaps == track.totalLaps)
        assert(racer.finishTime >= previousTime and racer.finishTime <= game.elapsed)
        previousTime = racer.finishTime
        if racer.driver then
            aiRecoveries = aiRecoveries + racer.recoveries
        end
    end
    for index = 2, #game.racers do
        assert(seen[index], "An opponent missed the finish")
    end
    assert((seen[1] == true) == (seed ~= nil), "Player finish status differs from scenario")
    print(("PASS %s: %d finishers in %.2f s, %d AI recoveries")
        :format(seed and ("seed " .. seed) or "unattended player", expectedFinishers, previousTime, aiRecoveries))
end

simulate()
for _, seed in ipairs({ 3, 17, 42, 97, 211 }) do
    simulate(seed)
end

-- Stall a racer on purpose after its first accepted gate.
local game = startedRace()
local stalled = game.racers[2]
for _ = 1, 60 * 8 do
    if stalled.progress.lastGate == track.gates[2] then break end
    game:update(FRAME, neutral)
end
local gate = track.gates[2]
assert(stalled.progress.lastGate == gate)
local originalTuning = stalled.marble.tuning
local noThrottle = {}
for key, value in pairs(originalTuning) do
    noThrottle[key] = value
end
noThrottle.acceleration = 0
stalled.marble.tuning = noThrottle
stalled.marble.x, stalled.marble.y = 780, 240
stalled.marble.vx, stalled.marble.vy = 0, 0
local recoveries = stalled.recoveries
for _ = 1, 120 * 5 do
    game:update(STEP, neutral)
    if stalled.recoveries > recoveries then break end
end
assert(stalled.recoveries == recoveries + 1, "AI did not recover when stalled")
assert(stalled.marble.x == gate.respawn.x and stalled.marble.y == gate.respawn.y)
assert(stalled.driver.nextWaypoint == gate.nextWaypoint)
assert(stalled.progress.lastGate == gate and stalled.progress.nextGateIndex == 3)
assert(stalled.progress.completedLaps == 0)
stalled.marble.tuning = originalTuning
for _ = 1, 60 * 45 do
    game:update(FRAME, neutral)
    if #game.finishOrder == 3 then break end
end
assert(#game.finishOrder == 3 and stalled.progress.finished, "Recovered AI failed to finish")
print("PASS stalled AI recovers to its valid gate, resumes, and finishes")
