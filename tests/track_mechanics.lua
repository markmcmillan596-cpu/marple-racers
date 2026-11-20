-- Run from the project root with lua tests/track_mechanics.lua.
local Driver = require("src.ai_driver")
local Game = require("src.game")
local Marble = require("src.marble")
local Physics = require("src.physics")
local Surfaces = require("src.surfaces")
local profiles = require("data.physics.surfaces")
local track = require("tracks.kitchen_advanced")
local classic = require("tracks.breakfast")
local kitchen = require("tracks.kitchen")

local STEP, FRAME = 1 / 120, 1 / 60
local neutral = { steer = 0 }
local throttle = { accelerate = true, steer = 0 }

local function marbleAt(x, y, angle, vx, vy)
    local marble = Marble.new({ x = x, y = y, angle = angle })
    marble.vx, marble.vy = vx, vy
    return marble
end

local function near(actual, expected)
    assert(math.abs(actual - expected) < 1e-7, ("%g differs from %g"):format(actual, expected))
end

assert(#classic.obstacles == 4 and #kitchen.obstacles == 4)
assert(classic.surfaceRegions == nil and kitchen.shortcut == nil)
assert(#kitchen.decorations > 0 and #track.obstacles > #kitchen.obstacles)
assert(Surfaces.at(track, 480, 224) == profiles.wood)
assert(Surfaces.at(track, 560, 224) == profiles.placemat)
assert(Surfaces.at(track, 778, 465) == profiles.napkin)
assert(Surfaces.at(classic, 560, 224) == profiles.wood)

local wood = marbleAt(480, 224, 0, 180, 0)
local napkin = marbleAt(774, 465, 0, 180, 0)
Physics.step(track, { wood }, { throttle }, STEP)
Physics.step(track, { napkin }, { throttle }, STEP)
near(wood.vx, 180 + wood.tuning.acceleration * STEP)
near(napkin.vx, wood.vx * math.exp(-profiles.napkin.drag * STEP))

wood = marbleAt(480, 224, 0, 130, 70)
local mat = marbleAt(560, 224, 0, 130, 70)
Physics.step(track, { wood }, { neutral }, STEP)
Physics.step(track, { mat }, { neutral }, STEP)
near(wood.vx, 130 * math.exp(-wood.tuning.coastDrag * STEP))
assert(mat.vy > wood.vy, "Placemat did not retain more lateral slip")
local steer = { steer = 1 }
Physics.step(track, { wood }, { steer }, STEP)
Physics.step(track, { mat }, { steer }, STEP)
assert(mat.angle < wood.angle, "Placemat did not soften steering")

local override = {
    surfaceRegions = track.surfaceRegions,
    surfaceProfiles = { wood = profiles.wood, placemat = profiles.placemat, napkin = { drag = 5, grip = 1 } },
}
near(Surfaces.at(override, 778, 465).drag, 5)
print("PASS wood, napkin drag, placemat traction, and configurable surface profiles")

local cereal, ruler
for _, prop in ipairs(track.obstacles) do
    if prop.kind == "cereal" then
        cereal = cereal or prop
    elseif prop.kind == "ruler" then
        ruler = prop
    end
end
local hit = marbleAt(cereal.x, cereal.y - 26, math.pi / 2, 0, 240)
local cerealBounced = false
for _ = 1, 24 do
    Physics.step(track, { hit }, {}, STEP)
    local dx, dy = hit.x - cereal.x, hit.y - cereal.y
    assert(dx * dx + dy * dy >= (hit.radius + cereal.radius - 1e-6) ^ 2)
    cerealBounced = cerealBounced or hit.vy < 0
end
assert(cerealBounced, "Spilled cereal failed to rebound the marble")
print("PASS cereal collision separates and rebounds without repeat penetration")

local dx, dy = ruler.bx - ruler.ax, ruler.by - ruler.ay
local length = math.sqrt(dx * dx + dy * dy)
local tx, ty = dx / length, dy / length
local nx, ny = -ty, tx -- Side facing the race lane.
local x, y = ruler.ax + 0.5 * dx, ruler.ay + 0.5 * dy
local vx, vy = 180 * (tx - nx), 180 * (ty - ny)
local angle = (math.atan2 or math.atan)(vy, vx)
local bank = marbleAt(x + 25 * nx, y + 25 * ny, angle, vx, vy)
local incomingSpeed = bank:speed()
local banked = false
for _ = 1, 12 do
    Physics.step(track, { bank }, {}, STEP)
    assert((bank.x - x) * nx + (bank.y - y) * ny >= bank.radius + ruler.radius - 1e-6)
    if bank.vx < -150 and bank.vy > 0 then
        banked = true
        assert(bank:speed() < incomingSpeed, "The ruler added energy")
    end
end
assert(vx > 0 and banked, "Bank shot did not redirect the marble toward the exit")
print("PASS angled ruler redirects the marble toward the bend exit without adding speed")

local function routeLength(replacements)
    local total = 0
    local previous = track.waypoints[7]
    for index = 8, 13 do
        local point = replacements[index] or track.waypoints[index]
        total = total + math.sqrt((point.x - previous.x) ^ 2 + (point.y - previous.y) ^ 2)
        previous = point
    end
    return total
end
local shortcutLength = routeLength(track.shortcut.waypoints)
local regularLength = routeLength({})
assert(shortcutLength < regularLength * 0.95)

local function simulate(useShortcut)
    local game = Game.newRace(track)
    local player = Driver.new(track.waypoints, {
        pace = 0.95,
        laneOffset = 0,
        useShortcut = useShortcut,
    }, track.shortcut)
    local visitLaps = { {}, {}, {}, {} }
    game:update(FRAME, throttle)
    for _ = 1, 60 * 45 do
        local input = assert(player:update(game.player, FRAME, game.progress.finished), "Scripted driver got stuck")
        local last = game.progress.lastGate
        game:update(FRAME, input)
        if game.progress.lastGate ~= last then
            player:onGate()
        end
        for index, racer in ipairs(game.racers) do
            local px, py = racer.marble.x, racer.marble.y
            -- This part of the inside route was solid in the original layout.
            if not racer.progress.finished and px > 751 and px < 803 and py > 447 and py < 491 then
                assert(racer.progress.nextGateIndex == 3, "Shortcut was taken without crossing the right gate")
                visitLaps[index][racer.progress.completedLaps + 1] = true
            end
        end
        if #game.finishOrder == 4 then
            break
        end
    end
    assert(#game.finishOrder == 4)
    for index, racer in ipairs(game.racers) do
        assert(racer.progress.completedLaps == 3)
        assert(racer.recoveries == 0)
        local expected = index == 3 or (index == 1 and useShortcut)
        for lap = 1, 3 do
            assert((visitLaps[index][lap] == true) == expected, "Unexpected racing line")
        end
    end
    return game.racers[1].finishTime
end

local regularTime, shortcutTime = simulate(false), simulate(true)
print(("PASS both routes finish four racers with three legal laps; %.0f px regular, %.0f px shortcut; scripted player %.2f s / %.2f s")
    :format(regularLength, shortcutLength, regularTime, shortcutTime))
