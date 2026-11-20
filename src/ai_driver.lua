local Driver = {}
Driver.__index = Driver

local atan2 = math.atan2 or math.atan
local WAYPOINT_RADIUS = 22
local WAYPOINT_TIMEOUT = 3.5
local GATE_TIMEOUT = 9

function Driver.new(waypoints, style)
    local line = {}
    for index, waypoint in ipairs(waypoints) do
        local previous = waypoints[(index - 2) % #waypoints + 1]
        local following = waypoints[index % #waypoints + 1]
        local dx, dy = following.x - previous.x, following.y - previous.y
        local length = math.sqrt(dx * dx + dy * dy)
        line[index] = {
            x = waypoint.x - style.laneOffset * dy / length,
            y = waypoint.y + style.laneOffset * dx / length,
            speed = waypoint.speed * style.pace,
        }
    end
    return setmetatable({
        line = line,
        nextWaypoint = 1,
        waypointTime = 0,
        gateTime = 0,
        input = {},
    }, Driver)
end

function Driver:onGate()
    self.gateTime = 0
end

function Driver:resetAtGate(gate)
    self.nextWaypoint = gate.nextWaypoint
    self.waypointTime = 0
    self:onGate()
end

function Driver:update(marble, dt, finished)
    self.waypointTime = self.waypointTime + dt
    if not finished then
        self.gateTime = self.gateTime + dt
    end
    local target = self.line[self.nextWaypoint]
    local dx, dy = target.x - marble.x, target.y - marble.y
    local distanceSquared = dx * dx + dy * dy
    if distanceSquared <= WAYPOINT_RADIUS * WAYPOINT_RADIUS then
        self.nextWaypoint = self.nextWaypoint % #self.line + 1
        self.waypointTime = 0
        target = self.line[self.nextWaypoint]
        dx, dy = target.x - marble.x, target.y - marble.y
    end
    if self.waypointTime > WAYPOINT_TIMEOUT or self.gateTime > GATE_TIMEOUT then
        return nil -- Ask the game to use the same recovery rules as the player.
    end

    local angle = (atan2(dy, dx) - marble.angle + math.pi) % (2 * math.pi) - math.pi
    local targetSpeed = target.speed * math.max(0.18, 1 - math.abs(angle) * 0.65)
    local speed = marble:speed()
    local input = self.input
    input.steer = math.max(-1, math.min(1, angle * 4))
    input.accelerate = speed < targetSpeed
    input.brake = speed > targetSpeed + 12
    return input
end

return Driver
