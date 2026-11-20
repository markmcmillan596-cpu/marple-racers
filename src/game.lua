local Marble = require("src.marble")
local Collision = require("src.track_collision")

local Game = {}
Game.__index = Game

local STEP = 1 / 120
local MAX_FRAME_TIME = 0.1

function Game.new(track)
    return setmetatable({
        track = track,
        player = Marble.new(track.checkpoints[1]),
        checkpoint = track.checkpoints[1],
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
    self.player:reset(self.checkpoint)
    self.accumulator = 0
end

function Game:update(dt, input)
    if self.paused then
        return
    end

    -- Fixed simulation steps keep steering and collisions independent of redraw rate.
    self.accumulator = self.accumulator + math.min(dt, MAX_FRAME_TIME)
    while self.accumulator + 1e-10 >= STEP do
        self.accumulator = math.max(0, self.accumulator - STEP)
        self.player:step(input, STEP)
        Collision.resolve(self.track, self.player)

        for _, checkpoint in ipairs(self.track.checkpoints) do
            local dx = self.player.x - checkpoint.x
            local dy = self.player.y - checkpoint.y
            if dx * dx + dy * dy <= checkpoint.radius * checkpoint.radius then
                self.checkpoint = checkpoint
                break
            end
        end
    end
end

return Game
