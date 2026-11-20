-- Run from the project root with lua tests/run.lua (Lua 5.1 or newer).
local Game = require("src.game")
local Marble = require("src.marble")
local Collision = require("src.track_collision")
local Physics = require("src.physics")
local defaults = require("data.physics.arcade")
local track = require("tracks.breakfast")

local neutral = { steer = 0 }
local throttle = { accelerate = true, steer = 0 }
local brake = { brake = true, steer = 0 }
local start = track.gates[1].respawn
local recovery = track.gates[2].respawn
local passed = 0

local function check(name, body)
    body()
    passed = passed + 1
    print("PASS " .. name)
end

local function near(actual, expected)
    assert(math.abs(actual - expected) < 1e-7, ("%g != %g"):format(actual, expected))
end

local function advance(game, frames, input)
    for _ = 1, frames do
        game:update(1 / 60, input)
    end
end

check("spawn and accelerate along the start straight", function()
    local game = Game.new(track)
    near(game.player.x, start.x)
    near(game.player.y, start.y)
    near(game.player:speed(), 0)
    advance(game, 24, throttle)
    assert(game.player.x > start.x + 35)
    near(game.player.y, start.y)
    assert(game.player:speed() > 200)
end)

check("brake takes precedence and stops without reversing", function()
    local game = Game.new(track)
    advance(game, 24, throttle)
    advance(game, 24, { brake = true, accelerate = true, steer = 0 })
    near(game.player:speed(), 0)
    local stopped = game.player.x
    advance(game, 6, brake)
    near(game.player.x, stopped)
end)

check("coasting retains momentum and gradually slows", function()
    local marble = Marble.new(start)
    marble:step(throttle, 1 / 120)
    local speed, x = marble:speed(), marble.x
    marble:step(neutral, 1 / 120)
    assert(marble.x > x)
    assert(marble:speed() > 0 and marble:speed() < speed)
end)

check("left and right steering bend travel in opposite directions", function()
    local left, right = Game.new(track), Game.new(track)
    advance(left, 15, { accelerate = true, steer = -1 })
    advance(right, 15, { accelerate = true, steer = 1 })
    assert(left.player.y < start.y - 2)
    assert(right.player.y > start.y + 2)
    near(left.player.y + right.player.y, start.y * 2)
end)

check("fixed steps give the same result at 30, 60, and 144 FPS", function()
    local reference = Game.new(track)
    local steering = { accelerate = true, steer = 1 }
    advance(reference, 30, steering)
    for _, rate in ipairs({ 30, 144 }) do
        local game = Game.new(track)
        local duration = 0.5
        for _ = 1, rate * duration do
            game:update(1 / rate, steering)
        end
        near(game.player.x, reference.player.x)
        near(game.player.y, reference.player.y)
        near(game.player.angle, reference.player.angle)
    end
end)

check("long frames are capped and pause freezes simulation", function()
    local game, expected = Game.new(track), Game.new(track)
    game:update(3, throttle)
    advance(expected, 6, throttle)
    near(game.player.x, expected.player.x)
    game:togglePause()
    assert(game.paused)
    game:update(1, throttle)
    near(game.player.x, expected.player.x)
    game:togglePause()
    advance(game, 1, throttle)
    assert(game.player.x > expected.player.x)
end)

check("outer rail, infield, and rounded corner contain the marble", function()
    local player = Marble.new(start)
    player.x, player.y, player.vx, player.vy = 493, 177, 50, -100
    Collision.resolve(track, player)
    near(player.y, track.outer.y + player.radius)
    near(player.vx, 50)
    near(player.vy, 42)

    player.x, player.y, player.vx, player.vy = 493, 301, 25, 90
    Collision.resolve(track, player)
    near(player.y, track.island.y - player.radius)
    assert(player.vy < 0)

    player.x, player.y, player.vx, player.vy = 110, 190, -60, -60
    Collision.resolve(track, player)
    local dx = player.x - (track.outer.x + track.outer.corner)
    local dy = player.y - (track.outer.y + track.outer.corner)
    near(math.sqrt(dx * dx + dy * dy), track.outer.corner - player.radius)
    assert(player.vx > 0 and player.vy > 0)
end)

check("household props collide and bounce", function()
    local player = Marble.new(start)
    local prop = track.obstacles[1]
    player.x, player.y, player.vx = prop.x - prop.radius, prop.y, 100
    Collision.resolve(track, player)
    near(player.x, prop.x - prop.radius - player.radius)
    near(player.vx, -42)
end)

check("recovery uses the most recent checkpoint and clears momentum", function()
    local game = Game.new(track)
    game.player.x = start.x + 120
    game:recover()
    near(game.player.x, start.x)
    game.player.x, game.player.y = recovery.x, track.gates[2].ay - 1
    game.player.angle, game.player.vy = recovery.angle, 200
    advance(game, 1, throttle)
    assert(game.progress.lastGate == track.gates[2])
    game.player.x = recovery.x - 100
    game.player.angle = 0
    game.player.vx, game.player.vy = 79, 12
    advance(game, 1, neutral)
    game:recover()
    near(game.player.x, recovery.x)
    near(game.player.y, recovery.y)
    near(game.player.angle, recovery.angle)
    near(game.player:speed(), 0)
end)

local STEP = 1 / 120

check("shared tuning controls drive, braking, steering, drag, and radius", function()
    local tuning = {}
    for name, value in pairs(defaults) do
        tuning[name] = value
    end
    tuning.marbleRadius = 12
    tuning.acceleration = 120
    tuning.driveSpeed = 5
    tuning.braking = 240
    tuning.steeringRate = 2
    tuning.coastDrag = 2
    tuning.lateralDrag = 3
    tuning.trackBounce = 0

    local game = Game.new(track, tuning)
    local player = game.player
    near(player.radius, 12)
    game:update(STEP, throttle)
    near(player:speed(), 1)
    advance(game, 6, throttle)
    near(player:speed(), 5)
    game:update(STEP, brake)
    near(player:speed(), 3)
    player.vy = 10
    game:update(STEP, neutral)
    near(player.vx, 3 * math.exp(-2 * STEP))
    near(player.vy, 10 * math.exp(-3 * STEP))

    game:recover()
    game:update(STEP, { steer = 1 })
    near(player.angle, 2 * STEP)
    player.y, player.vy = track.outer.y + player.radius, -100
    game:update(STEP, neutral)
    near(player.y, track.outer.y + player.radius)
    near(player.vy, 0)
end)

local function racer(x, y, vx, vy)
    local marble = Marble.new({ x = x, y = y, angle = 0 })
    marble.vx, marble.vy = vx, vy
    return marble
end

check("the game loop applies custom marble bounce across frame rates", function()
    local tuning = {}
    for name, value in pairs(defaults) do
        tuning[name] = value
    end
    tuning.marbleBounce = 0
    local function run(frameTime, frames)
        local game = Game.new(track, tuning)
        local player = game.player
        player.vx = 240
        local other = racer(player.x + 32, player.y, -240, 0)
        game.marbles[2] = other
        for _ = 1, frames do
            game:update(frameTime, neutral)
        end
        near(player:speed(), 0)
        near(other:speed(), 0)
        near(other.x - player.x, player.radius + other.radius)
        return player.x
    end
    near(run(1 / 30, 3), run(1 / 60, 6))
end)

check("head-on contact at full speed separates and rebounds both marbles", function()
    local a = racer(484, 236, defaults.driveSpeed, 0)
    local b = racer(520, 236, -defaults.driveSpeed, 0)
    Physics.step(track, { a, b }, {}, STEP)
    near(b.x - a.x, a.radius + b.radius)
    near((a.x + b.x) / 2, 502)
    local rebound = defaults.driveSpeed * math.exp(-defaults.coastDrag * STEP) * defaults.marbleBounce
    near(a.vx, -rebound)
    near(b.vx, rebound)
end)

check("glancing contact transfers normal momentum and preserves sliding motion", function()
    local a, b = racer(480, 236, 160, 50), racer(511, 236, 0, 50)
    Physics.step(track, { a, b }, {}, STEP)
    local approach = 160 * math.exp(-defaults.coastDrag * STEP)
    near(a.vx + b.vx, approach)
    near(b.vx - a.vx, approach * defaults.marbleBounce)
    near(a.vy, 50 * math.exp(-defaults.lateralDrag * STEP))
    near(b.vy, a.vy)
end)

check("overlapping marbles moving apart keep their velocities", function()
    local a, b = racer(480, 236, -30, 0), racer(503, 236, 30, 0)
    Physics.step(track, { a, b }, {}, STEP)
    near(b.x - a.x, a.radius + b.radius)
    near(b.vx, 30 * math.exp(-defaults.coastDrag * STEP))
    near(a.vx, -b.vx)
end)

check("coincident stationary centers separate without gaining speed", function()
    local a, b = racer(480, 236, 0, 0), racer(480, 236, 0, 0)
    Physics.step(track, { a, b }, {}, STEP)
    near(b.x - a.x, a.radius + b.radius)
    near(a:speed(), 0)
    near(b:speed(), 0)
end)

check("four-marble contact near the rail settles without escaping or gaining speed", function()
    local marbles = {
        racer(480, 184, 0, 0),
        racer(480, 214, 0, 0),
        racer(480, 244, 0, 0),
        racer(480, 274, 0, -defaults.driveSpeed),
    }
    for _ = 1, 30 do
        Physics.step(track, marbles, {}, STEP)
        for index, marble in ipairs(marbles) do
            assert(marble.y >= track.outer.y + marble.radius - 1e-7)
            assert(marble:speed() <= defaults.driveSpeed)
            if index > 1 then
                local previous = marbles[index - 1]
                assert(marble.y - previous.y > marble.radius + previous.radius - 0.5)
            end
        end
    end
    for index = 2, #marbles do
        assert(marbles[index].y - marbles[index - 1].y >= 30 - 1e-5)
    end
end)

print(("%d checks passed"):format(passed))
