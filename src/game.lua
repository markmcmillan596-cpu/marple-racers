local Marble = require("src.marble")
local Physics = require("src.physics")
local RaceProgress = require("src.race_progress")

local Game = {}
Game.__index = Game

local STEP = 1 / 120
local MAX_FRAME_TIME = 0.1

function Game.new(track, tuning)
    local player = Marble.new(track.gates[1].respawn, tuning)
    return setmetatable({
        track = track,
        player = player,
        marbles = { player },
        inputs = {},
        tuning = player.tuning,
        progress = RaceProgress.new(track.gates, track.totalLaps),
        accumulator = 0,
        paused = false,
    }, Game)
end

function Game:pause()
    self.paused = true
    self.accumulator = 0
end

function Game:togglePause()
    if self.paused then
        self.paused = false
    else
        self:pause()
    end
end

function Game:recover()
    self.player:reset(self.progress.lastGate.respawn)
    self.accumulator = 0
end

function Game:update(dt, input)
    if self.paused then
        return
    end

    -- Fixed simulation steps keep steering and collisions independent of redraw rate.
    self.inputs[1] = input
    self.accumulator = self.accumulator + math.min(dt, MAX_FRAME_TIME)
    while self.accumulator + 1e-10 >= STEP do
        self.accumulator = math.max(0, self.accumulator - STEP)
        local oldX, oldY = self.player.x, self.player.y
        Physics.step(self.track, self.marbles, self.inputs, STEP, self.tuning)
        self.progress:advance(oldX, oldY, self.player.x, self.player.y)
    end
end

return Game
