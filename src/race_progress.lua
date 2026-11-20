local RaceProgress = {}
RaceProgress.__index = RaceProgress

function RaceProgress.new(gates, totalLaps)
    return setmetatable({
        gates = gates,
        totalLaps = totalLaps,
        completedLaps = 0,
        lastGate = gates[1],
        nextGateIndex = 2, -- The start/finish line opens no lap by itself.
        finished = false,
    }, RaceProgress)
end

local function crossesForward(gate, oldX, oldY, x, y)
    local dx, dy = gate.bx - gate.ax, gate.by - gate.ay
    local before = dx * (oldY - gate.ay) - dy * (oldX - gate.ax)
    local after = dx * (y - gate.ay) - dy * (x - gate.ax)
    if before > 0 or after <= 0 then
        return false
    end

    -- Intersect the movement with the gate's line, then check its finite span.
    local fraction = -before / (after - before)
    local hitX = oldX + (x - oldX) * fraction - gate.ax
    local hitY = oldY + (y - oldY) * fraction - gate.ay
    local along = hitX * dx + hitY * dy
    return along >= 0 and along <= dx * dx + dy * dy
end

function RaceProgress:advance(oldX, oldY, x, y)
    local gate = self.gates[self.nextGateIndex]
    if self.finished or not crossesForward(gate, oldX, oldY, x, y) then
        return
    end

    self.lastGate = gate
    if self.nextGateIndex == 1 then
        self.completedLaps = self.completedLaps + 1
        self.finished = self.completedLaps == self.totalLaps
    end
    self.nextGateIndex = self.nextGateIndex % #self.gates + 1
    return gate
end

return RaceProgress
