-- Run from the project root with lua tests/run.lua (Lua 5.1 or newer).
local Game = require("src.game")
local Marble = require("src.marble")
local Collision = require("src.track_collision")
local track = require("tracks.breakfast")

local neutral = { steer = 0 }
local throttle = { accelerate = true, steer = 0 }
local brake = { brake = true, steer = 0 }
local start = track.checkpoints[1]
local recovery = track.checkpoints[2]
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
    game.player.x, game.player.y = recovery.x + 30, recovery.y
    advance(game, 1, throttle)
    assert(game.checkpoint == recovery)
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

print(("%d checks passed"):format(passed))
