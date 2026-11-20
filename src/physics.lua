local defaults = require("data.physics.arcade")
local TrackCollision = require("src.track_collision")
local Surfaces = require("src.surfaces")

local Physics = {}
local NEUTRAL = { steer = 0 }
local MAX_CONTACT_PASSES = 12
local POSITION_TOLERANCE = 1e-6

local function resolvePair(a, b, bounce)
    local dx, dy = b.x - a.x, b.y - a.y
    local distanceSquared = dx * dx + dy * dy
    local contactDistance = a.radius + b.radius
    if distanceSquared > contactDistance * contactDistance then
        return false
    end

    local relativeX, relativeY = b.vx - a.vx, b.vy - a.vy
    local distance = math.sqrt(distanceSquared)
    local nx, ny = 1, 0
    if distance > 0 then
        nx, ny = dx / distance, dy / distance
    else
        -- A shared center has no contact normal. Use the approach direction
        -- when moving, or a consistent horizontal axis when both are stationary.
        local relativeSpeed = math.sqrt(relativeX * relativeX + relativeY * relativeY)
        if relativeSpeed > 0 then
            nx, ny = -relativeX / relativeSpeed, -relativeY / relativeSpeed
        end
    end

    -- All marbles have the same mass, so both receive half the correction.
    local overlap = contactDistance - distance
    if overlap > POSITION_TOLERANCE then
        local push = overlap / 2
        a.x, a.y = a.x - nx * push, a.y - ny * push
        b.x, b.y = b.x + nx * push, b.y + ny * push
    end

    -- Apply an impulse only to approaching marbles. Sliding speed is unaffected.
    local normalSpeed = relativeX * nx + relativeY * ny
    if normalSpeed < 0 then
        local impulse = -(1 + bounce) * normalSpeed / 2
        a.vx, a.vy = a.vx - nx * impulse, a.vy - ny * impulse
        b.vx, b.vy = b.vx + nx * impulse, b.vy + ny * impulse
    end
    return overlap > POSITION_TOLERANCE or normalSpeed < 0
end

local function resolveTrack(track, marbles, bounce)
    for _, marble in ipairs(marbles) do
        TrackCollision.resolve(track, marble, bounce)
    end
end

-- Advance every marble before resolving contacts so the pair solver uses positions
-- from the same fixed step. An omitted input lets that marble coast.
function Physics.step(track, marbles, inputs, dt, tuning)
    tuning = tuning or defaults
    for index, marble in ipairs(marbles) do
        local surface = Surfaces.at(track, marble.x, marble.y)
        marble:step(inputs[index] or NEUTRAL, dt, surface)
    end
    resolveTrack(track, marbles, tuning.trackBounce)

    -- A pair correction can push a marble into a rail, prop, or another marble.
    -- Recheck contacts in list order and cap the work in crowded sections.
    for _ = 1, MAX_CONTACT_PASSES do
        local contact = false
        for i = 1, #marbles - 1 do
            for j = i + 1, #marbles do
                if resolvePair(marbles[i], marbles[j], tuning.marbleBounce) then
                    contact = true
                end
            end
        end
        if not contact then
            break
        end
        resolveTrack(track, marbles, tuning.trackBounce)
    end
end

return Physics
