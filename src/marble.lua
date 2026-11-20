local Marble = {}
Marble.__index = Marble

local TOP_SPEED = 420
local ACCELERATION = 530
local BRAKING = 880
local STEERING = 3.6

function Marble.new(checkpoint)
    local marble = setmetatable({ radius = 15 }, Marble)
    marble:reset(checkpoint)
    return marble
end

function Marble:reset(checkpoint)
    self.x, self.y = checkpoint.x, checkpoint.y
    self.angle = checkpoint.angle
    self.vx, self.vy = 0, 0
end

function Marble:speed()
    return math.sqrt(self.vx * self.vx + self.vy * self.vy)
end

function Marble:step(input, dt)
    local speed = self:speed()
    local steeringGrip = math.max(0.72, 1 - 0.28 * speed / TOP_SPEED)
    self.angle = (self.angle + input.steer * STEERING * steeringGrip * dt) % (2 * math.pi)

    local hx, hy = math.cos(self.angle), math.sin(self.angle)
    -- Resolve velocity along and across the heading so lateral slip fades quickly.
    local forward = self.vx * hx + self.vy * hy
    local sideways = (self.vy * hx - self.vx * hy) * math.exp(-7 * dt)
    if input.brake then
        local slowdown = math.max(0, speed - BRAKING * dt) / math.max(speed, 1e-9)
        forward, sideways = forward * slowdown, sideways * slowdown
    elseif input.accelerate then
        forward = math.min(TOP_SPEED, forward + ACCELERATION * dt)
    else
        forward = forward * math.exp(-0.9 * dt)
    end

    self.vx = hx * forward - hy * sideways
    self.vy = hy * forward + hx * sideways
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end

return Marble
