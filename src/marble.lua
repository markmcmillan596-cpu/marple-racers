local defaults = require("data.physics.arcade")
local wood = require("data.physics.surfaces").wood

local Marble = {}
Marble.__index = Marble

function Marble.new(checkpoint, tuning)
    tuning = tuning or defaults
    local marble = setmetatable({ radius = tuning.marbleRadius, tuning = tuning }, Marble)
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

function Marble:step(input, dt, surface)
    surface = surface or wood
    local tuning = self.tuning
    local speed = self:speed()
    local gripLoss = (1 - tuning.minimumSteeringGrip) * speed / tuning.driveSpeed
    local steeringGrip = math.max(tuning.minimumSteeringGrip, 1 - gripLoss)
    self.angle = (self.angle + input.steer * tuning.steeringRate * steeringGrip * surface.grip * dt) % (2 * math.pi)

    local hx, hy = math.cos(self.angle), math.sin(self.angle)
    -- Resolve velocity along and across the heading so lateral slip fades quickly.
    local forward = self.vx * hx + self.vy * hy
    local sideways = (self.vy * hx - self.vx * hy) * math.exp(-tuning.lateralDrag * surface.grip * dt)
    if input.brake then
        local slowdown = math.max(0, speed - tuning.braking * dt) / math.max(speed, 1e-9)
        forward, sideways = forward * slowdown, sideways * slowdown
    elseif input.accelerate then
        forward = math.min(tuning.driveSpeed, forward + tuning.acceleration * dt)
    else
        forward = forward * math.exp(-tuning.coastDrag * dt)
    end

    local drag = math.exp(-surface.drag * dt)
    self.vx = (hx * forward - hy * sideways) * drag
    self.vy = (hy * forward + hx * sideways) * drag
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end

return Marble
